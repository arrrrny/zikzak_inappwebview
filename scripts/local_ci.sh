#!/usr/bin/env bash
# local_ci.sh — run THIS repo's CI gate locally, the same steps GitHub Actions runs.
#
# Why: our private repos have no GitHub Actions budget, so every `ci` run ends in
# ~3s with no steps executed. The red check is noise, not signal. This runs the
# same gate locally, so "is CI green?" has a real answer.
#
# HOW IT STAYS IN SYNC: it does not duplicate the workflow. It parses
# `.github/workflows/*` at run time, picks the workflow that runs for the event
# being simulated (default: pull_request), and executes its jobs and steps in
# order. Edit the workflow and the local run changes with it — there is no second
# copy to drift from.
#
# Usage:
#   ./scripts/local_ci.sh                  run the gate (every job, in order)
#   ./scripts/local_ci.sh --plan           print every step that would run
#   ./scripts/local_ci.sh --list           list workflows, triggers and jobs
#   ./scripts/local_ci.sh --job test       run one job (by job id)
#   ./scripts/local_ci.sh --event push     simulate the push-triggered workflow
#   ./scripts/local_ci.sh --workflow .github/workflows/ci.yml
#   ./scripts/local_ci.sh --keep-going     do not stop at the first failure
#   ./scripts/local_ci.sh -v               echo each command before running it
#   ./scripts/local_ci.sh --allow-outside-clone  also run steps that clone over
#                                         an existing sibling checkout (see below)
#
# What it cannot reproduce, and says so out loud instead of guessing:
#   * Linux. CI runs ubuntu-latest; this runs on the local host. The STEP SET is
#     identical, the platform is not. `sudo apt-get install` is mapped to a local
#     presence probe (APT_EQUIVALENTS) rather than silently passed.
#   * `${{ secrets.* }}`, `${{ inputs.* }}`, `${{ vars.* }}`, `${{ steps.* }}`,
#     `${{ needs.* }}`, `${{ github.event.* }}` — there is no GitHub context
#     locally. A step that needs one is SKIPPED with the reason printed, never
#     run with a guessed value.
#   * `uses:` actions are not executed. Toolchain setups (setup-dart, setup-node,
#     flutter-action, rust-toolchain, …) become a version ASSERTION against the
#     local tool; known no-op actions (checkout/cache/artifacts) are noted; any
#     other action is skipped by name.
#   * `container:` jobs run on the host, not in the declared image (noted).
#   * `strategy.matrix` is expanded as a cross product; `include`/`exclude` are
#     not modelled, so a job that uses them is skipped with the reason.
#   * `continue-on-error: true` steps are advisory locally, exactly as in CI.
#
# Exit status: 0 when every executed step passed, 1 otherwise.
set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -n "${LOCAL_CI_ROOT:-}" ]; then
  root="$LOCAL_CI_ROOT"
elif root="$(git -C "$here" rev-parse --show-toplevel 2>/dev/null)" && [ -n "$root" ]; then
  : # installed inside a git repo: the repo root is the checkout root CI uses
elif [ -d "$here/../.github/workflows" ]; then
  root="$(cd "$here/.." && pwd)"
else
  root="$here"
fi
LOCAL_CI_ROOT="$root" exec python3 - "$@" <<'LOCAL_CI_PY'
"""Run a GitHub Actions workflow locally, faithfully, and say what it cannot do.

This is deliberately NOT a second copy of the workflow: it reads
.github/workflows/* at run time, selects the workflow that runs for the
simulated event, and executes its jobs and steps in order.
"""
import atexit
import itertools
import json
import os
import platform
import re
import shlex
import shutil
import subprocess
import sys
import tempfile
import time
from pathlib import Path

ROOT = Path(os.environ.get("LOCAL_CI_ROOT", ".")).resolve()

# `actions/checkout` with a `path:` input stages the repo at <workspace>/<path>
# instead of the workspace root. Locally the repo IS the root, so the layout is
# mirrored with a self-referential symlink; these are removed when the run ends.
CHECKOUT_LINKS = []


def _remove_checkout_links():
    for link in CHECKOUT_LINKS:
        try:
            if link.is_symlink():
                link.unlink()
        except OSError:
            pass


atexit.register(_remove_checkout_links)

BRIGHT, DIM, RESET = "\033[1m", "\033[2m", "\033[0m"
RED, GREEN, YELLOW, CYAN = "\033[31m", "\033[32m", "\033[33m", "\033[36m"


# ------------------------------------------------------------------ YAML subset
# A small indentation-based YAML reader: mappings, sequences, flow lists/maps,
# block scalars (| and >), quoted and plain scalars, comments. It is deliberately
# not a YAML implementation — it covers the shape GitHub Actions files use. It
# never guesses: anything it cannot read raises YamlError with the line number.

class YamlError(Exception):
    pass


def _indent(line):
    return len(line) - len(line.lstrip(" "))


def _ignorable(line):
    s = line.strip()
    return (not s) or s.startswith("#")


def _strip_comment(s):
    out, q = [], None
    for i, ch in enumerate(s):
        if q:
            out.append(ch)
            if ch == q:
                q = None
        elif ch in "'\"":
            q = ch
            out.append(ch)
        elif ch == "#" and (i == 0 or s[i - 1] in " \t"):
            break
        else:
            out.append(ch)
    return "".join(out).rstrip()


def _unquote(s):
    s = s.strip()
    if len(s) >= 2 and s[0] == s[-1] and s[0] in "'\"":
        return s[1:-1]
    return s


def _split_flow(s):
    parts, depth, q, cur = [], 0, None, []
    for ch in s:
        if q:
            cur.append(ch)
            if ch == q:
                q = None
            continue
        if ch in "'\"":
            q = ch
            cur.append(ch)
            continue
        if ch in "[{":
            depth += 1
        elif ch in "]}":
            depth -= 1
        if ch == "," and depth == 0:
            parts.append("".join(cur).strip())
            cur = []
        else:
            cur.append(ch)
    if "".join(cur).strip():
        parts.append("".join(cur).strip())
    return parts


def _scalar(tok):
    tok = tok.strip()
    if tok == "":
        return None
    low = tok.lower()
    if low == "true":
        return True
    if low == "false":
        return False
    if low in ("null", "~"):
        return None
    if tok[0] == "[" and tok[-1] == "]" and len(tok) >= 2:
        inner = tok[1:-1].strip()
        return [_scalar(x) for x in _split_flow(inner)] if inner else []
    if tok[0] == "{" and tok[-1] == "}" and len(tok) >= 2:
        inner = tok[1:-1].strip()
        out = {}
        for part in _split_flow(inner):
            k, _, v = part.partition(":")
            out[_unquote(k)] = _scalar(v)
        return out
    if len(tok) >= 2 and tok[0] == tok[-1] and tok[0] in "'\"":
        return tok[1:-1]
    return tok


def _looks_like_pair(rest):
    """`key: value` / `key:` — but not a plain scalar that merely contains a colon."""
    if rest[:1] in ("'", '"', "[", "{"):
        return False
    return bool(re.match(r"^[A-Za-z_][\w.\-]*\s*:(?:\s|$)", rest))


def _next_content(lines, i):
    while i < len(lines) and _ignorable(lines[i]):
        i += 1
    return i


def _block_scalar(lines, i, key_indent, style):
    body, j = [], i
    while j < len(lines):
        line = lines[j]
        if line.strip() == "":
            body.append("")
            j += 1
            continue
        if _indent(line) <= key_indent:
            break
        body.append(line)
        j += 1
    while body and body[-1] == "":
        body.pop()
    if not body:
        return "", j
    cut = min(_indent(b) for b in body if b.strip())
    text = "\n".join(b[cut:] if b.strip() else "" for b in body)
    if style[0] == ">":
        text = "\n".join(
            " ".join(x.strip() for x in para.split("\n") if x.strip())
            for para in text.split("\n\n")
        )
    return text, j


def parse_map(lines, i, indent):
    out = {}
    while i < len(lines):
        line = lines[i]
        if _ignorable(line):
            i += 1
            continue
        ind = _indent(line)
        if ind < indent:
            break
        if ind > indent:
            i += 1
            continue
        s = _strip_comment(line.strip())
        if re.match(r"^-(?:\s|$)", s):
            break
        if ":" not in s:
            i += 1
            continue
        key, _, val = s.partition(":")
        key = _unquote(key.strip())
        val = val.strip()
        i += 1
        if val[:1] in ("|", ">"):
            body, i = _block_scalar(lines, i, indent, val)
            out[key] = body
            continue
        if val == "":
            j = _next_content(lines, i)
            same_level_seq = j < len(lines) and _indent(lines[j]) == indent \
                and re.match(r"^-(?:\s|$)", lines[j].strip())
            if j < len(lines) and (_indent(lines[j]) > indent or same_level_seq):
                out[key], i = parse_node(lines, j, _indent(lines[j]))
            else:
                out[key] = None
            continue
        out[key] = _scalar(_strip_comment(val))
    return out, i


def parse_seq(lines, i, indent):
    out = []
    while i < len(lines):
        line = lines[i]
        if _ignorable(line):
            i += 1
            continue
        ind = _indent(line)
        if ind < indent:
            break
        if ind > indent:
            i += 1
            continue
        s = _strip_comment(line.strip())
        if not re.match(r"^-(?:\s|$)", s):
            break
        rest = s[1:].lstrip(" ")
        i += 1
        if rest == "":
            j = _next_content(lines, i)
            same_level_seq = j < len(lines) and _indent(lines[j]) == indent \
                and re.match(r"^-(?:\s|$)", lines[j].strip())
            if j < len(lines) and (_indent(lines[j]) > indent or same_level_seq):
                val, i = parse_node(lines, j, _indent(lines[j]))
                out.append(val)
            else:
                out.append(None)
            continue
        if _looks_like_pair(rest):
            # A compact mapping item: re-indent the first pair and swallow the
            # rest of the item's block, including blank lines inside scalars.
            sub = [" " * (indent + 2) + rest]
            pending, j = [], i
            while j < len(lines):
                l2 = lines[j]
                if _ignorable(l2):
                    pending.append(l2)
                    j += 1
                    continue
                if _indent(l2) <= indent:
                    break
                sub.extend(pending)
                pending = []
                sub.append(l2)
                j += 1
            val, _ = parse_map(sub, 0, indent + 2)
            out.append(val)
            i = j
            continue
        out.append(_scalar(rest))
    return out, i


def parse_node(lines, i, indent):
    if i >= len(lines):
        return None, i
    if re.match(r"^-(?:\s|$)", _strip_comment(lines[i].strip())):
        return parse_seq(lines, i, indent)
    return parse_map(lines, i, indent)


def parse_yaml(text):
    lines = text.split("\n")
    lines = [l for l in lines if l.strip() != "---"]
    i = _next_content(lines, 0)
    if i >= len(lines):
        return {}
    val, _ = parse_node(lines, i, _indent(lines[i]))
    return val if isinstance(val, dict) else {}


def parse_workflow(path):
    try:
        return parse_yaml(path.read_text(errors="replace"))
    except YamlError:
        raise
    except Exception as exc:  # pragma: no cover - defensive
        raise YamlError(f"{path}: {exc}") from exc


# ----------------------------------------------------------------- expressions

# Context a local run genuinely does not have. Steps needing these are skipped.
NO_LOCAL_CONTEXT = ("secrets.", "inputs.", "vars.", "steps.", "needs.",
                    "github.event.", "github.token", "github.actor")


def build_github(slug, branch, event, workflow_name, sha):
    return {
        "workspace": str(ROOT),
        "repository": slug,
        "repository_owner": slug.split("/")[0] if "/" in slug else "",
        "ref_name": branch,
        "ref": f"refs/heads/{branch}",
        "event_name": event,
        "workflow": workflow_name,
        "sha": sha,
        "run_id": "0",
        "run_number": "0",
        "run_attempt": "1",
        "server_url": "https://github.com",
        "api_url": "https://api.github.com",
    }


def _split_top(text, op):
    parts, depth, q, cur = [], 0, None, []
    i = 0
    while i < len(text):
        ch = text[i]
        if q:
            cur.append(ch)
            if ch == q:
                q = None
            i += 1
            continue
        if ch in "'\"":
            q = ch
            cur.append(ch)
            i += 1
            continue
        if ch in "([":
            depth += 1
        elif ch in ")]":
            depth -= 1
        if depth == 0 and text.startswith(op, i):
            parts.append("".join(cur).strip())
            cur = []
            i += len(op)
            continue
        cur.append(ch)
        i += 1
    if "".join(cur).strip():
        parts.append("".join(cur).strip())
    return parts


def resolve_ref(expr, ctx, unresolved):
    """Return the string value of a single `${{ … }}` ref, or None."""
    e = expr.strip()
    if e.startswith("github."):
        rest = e[len("github."):]
        if rest in ctx["github"]:
            return str(ctx["github"][rest])
        if rest.startswith("matrix."):
            key = rest[len("matrix."):]
            matrix = ctx.get("matrix") or {}
            if key in matrix:
                return str(matrix[key])
        unresolved.append(e)
        return None
    if e.startswith("matrix."):
        key = e[len("matrix."):]
        matrix = ctx.get("matrix") or {}
        if key in matrix:
            return str(matrix[key])
        unresolved.append(e)
        return None
    if e.startswith("runner."):
        rest = e[len("runner."):]
        if rest in ctx["runner"]:
            return str(ctx["runner"][rest])
        unresolved.append(e)
        return None
    if e.startswith("env."):
        name = e[len("env."):]
        for src in ctx["env_chain"]:
            if name in src:
                return str(src[name])
        unresolved.append(e)
        return None
    if any(e.startswith(p) for p in NO_LOCAL_CONTEXT):
        unresolved.append(e)
        return None
    unresolved.append(e)
    return None


def resolve_value(expr, ctx, unresolved):
    """A `${{ … }}` in a value position: refs and simple == / != comparisons."""
    e = expr.strip()
    if "&&" in e or "||" in e:
        unresolved.append(e)  # a fallback expression; not modelled
        return None
    for op in ("==", "!="):
        if op in e:
            left, _, right = e.partition(op)
            lv, rv = _atom(left, ctx, unresolved), _atom(right, ctx, unresolved)
            if lv is None or rv is None:
                return None
            return "true" if ((lv == rv) if op == "==" else (lv != rv)) else "false"
    return resolve_ref(e, ctx, unresolved)


def _atom(tok, ctx, unresolved):
    t = tok.strip()
    if len(t) >= 2 and t[0] == t[-1] and t[0] in "'\"":
        return t[1:-1]
    if t.startswith("${{") and t.endswith("}}"):
        t = t[3:-2].strip()
    if t in ("true", "false"):
        return t
    if t == "":
        return None
    if not re.match(r"^[A-Za-z_][\w.\-]*$", t):
        return t  # a bare literal (number, path, …)
    return resolve_ref(t, ctx, unresolved)


def eval_condition(text, ctx, unresolved):
    """True / False / None (not modelled — the caller then skips the step)."""
    t = text.strip()
    if t.startswith("${{") and t.endswith("}}"):
        t = t[3:-2].strip()
    if t in ("always()", "!cancelled()", "true"):
        return True
    if t in ("false",):
        return False
    if t == "success()":
        return ctx.get("job_ok", True)
    if t == "failure()":
        return not ctx.get("job_ok", True)
    for op, fn in (("||", any), ("&&", all)):
        parts = _split_top(t, op)
        if len(parts) > 1:
            vals = [eval_condition(p, ctx, unresolved) for p in parts]
            if any(v is None for v in vals):
                return None
            return fn(vals)
    if t.startswith("!"):
        v = eval_condition(t[1:], ctx, unresolved)
        return None if v is None else (not v)
    for op in ("==", "!="):
        if op in t:
            left, _, right = t.partition(op)
            lv, rv = _atom(left, ctx, unresolved), _atom(right, ctx, unresolved)
            if lv is None or rv is None:
                return None
            return (lv == rv) if op == "==" else (lv != rv)
    v = _atom(t, ctx, unresolved)
    if v is None:
        return None
    return v not in ("", "false", "False", "0")


EXPR_RE = re.compile(r"\$\{\{\s*(.*?)\s*\}\}")


def expand(text, ctx, unresolved):
    if not isinstance(text, str):
        text = str(text)

    def repl(m):
        v = resolve_value(m.group(1), ctx, unresolved)
        return m.group(0) if v is None else v

    return EXPR_RE.sub(repl, text)


def has_expr(text):
    return isinstance(text, str) and EXPR_RE.search(text) is not None


# --------------------------------------------------------- local apt equivalents

# A `sudo apt-get install` step cannot run on macOS. It is only honest to skip it
# if the INTENT is checked, so each package we know how to map gets a real local
# probe. An unknown package is a warning, never a silent pass and never a failure.
APT_EQUIVALENTS = {
    "libsqlite3-dev": ("sqlite3 development library", "sqlite3"),
    "libssl-dev": ("OpenSSL development library", "openssl"),
    "pkg-config": ("pkg-config", "pkg-config"),
    "build-essential": ("a C toolchain", "cc"),
    "libsecret-1-dev": ("libsecret (keyring)", "pkg-config"),
    "libwebkit2gtk-4.1-dev": ("WebKitGTK", None),
    "libgtk-3-dev": ("GTK 3", None),
    "sqlite3": ("sqlite3", "sqlite3"),
    "zlib1g-dev": ("zlib development library", None),
}


# -------------------------------------------------------------- toolchain uses

# `uses:` action -> (tool, version-keys, version args). The action is not run;
# instead the local tool is asserted to exist and its version is compared with
# the version the workflow pins.
TOOLCHAIN_ACTIONS = (
    ("setup-dart", "dart", ("sdk", "dart-version", "version"), ("--version",)),
    ("flutter-action", "flutter", ("flutter-version", "version"), ("--version",)),
    ("setup-node", "node", ("node-version", "node-version-file"), ("--version",)),
    ("pnpm/action-setup", "pnpm", ("version",), ("--version",)),
    ("setup-python", "python3", ("python-version",), ("--version",)),
    ("setup-go", "go", ("go-version",), ("version",)),
    ("setup-java", "java", ("java-version", "distribution"), ("-version",)),
    ("setup-dotnet", "dotnet", ("dotnet-version",), ("--version",)),
    ("setup-ruby", "ruby", ("ruby-version",), ("--version",)),
    ("setup-bun", "bun", ("bun-version",), ("--version",)),
    ("setup-swift", "swift", ("swift-version",), ("--version",)),
    ("rust-toolchain", "cargo", ("toolchain",), ("--version",)),
    ("setup-php", "php", ("php-version",), ("--version",)),
)

NOOP_ACTIONS = ("actions/checkout", "actions/cache", "cache/", "upload-artifact",
                "download-artifact", "actions/setup-", "softprops/action-gh-release",
                "actions/github-script", "codecov/", "docker/", "docker/build-push")


class Outcome:
    def __init__(self):
        self.ran = self.checked = 0
        self.skipped, self.advisory, self.failed = [], [], []
        self.local_only = []


class Runner:
    def __init__(self, workflow_path, doc, args):
        self.path = workflow_path
        self.doc = doc
        self.args = args
        self.out = Outcome()
        self.job_ok = True
        self.stopped = False
        self.current_ctx = None
        self.absent_prefixes = ci_absent_prefixes()

    # ------------------------------------------------------------ job plumbing

    def run(self):
        wf_env = self.doc.get("env") or {}
        jobs = self.doc.get("jobs") or {}
        if not isinstance(jobs, dict) or not jobs:
            sys.exit("local_ci.sh: the workflow declares no jobs")

        selected = list(jobs.items())
        if self.args.get("job"):
            selected = [(k, v) for k, v in selected if k == self.args["job"]]
            if not selected:
                sys.exit(f"local_ci.sh: no job {self.args['job']!r} "
                         f"(have: {', '.join(jobs)})")
        else:
            order = job_order(jobs)
            selected = [(k, jobs[k]) for k in order]

        for job_id, job in selected:
            if self.stopped:
                break
            self.run_job(job_id, job, wf_env)

    def run_job(self, job_id, job, wf_env):
        if not isinstance(job, dict):
            self.skip_job(job_id, "job is not a mapping")
            return
        if job.get("uses"):
            self.skip_job(job_id, f"reusable workflow call ({job['uses']})")
            return
        matrix = (job.get("strategy") or {}).get("matrix")
        combos = expand_matrix(matrix, self.base_ctx(None))
        if combos is None:
            self.skip_job(job_id, "strategy.matrix is dynamic — could not be expanded")
            return
        for combo in combos:
            self.run_combo(job_id, job, wf_env, combo)

    def run_combo(self, job_id, job, wf_env, combo):
        label = job_id if not combo else f"{job_id} [matrix: " + ", ".join(
            f"{k}={v}" for k, v in combo.items()) + "]"
        if job.get("if"):
            probe = []
            verdict = eval_condition(job["if"], self.ctx_for(wf_env, {}, {}, combo), probe)
            if verdict is not True:
                self.skip_job(label, f"if: {job['if']}" +
                              ("" if verdict is None else " (false for this run)"))
                return

        runs_on = job.get("runs-on")
        probe = []
        if has_expr(str(runs_on)):
            runs_on = expand(str(runs_on), self.ctx_for(wf_env, {}, {}, combo), probe)
        runs_on = str(runs_on or "")
        if runs_on.startswith("windows"):
            self.skip_job(label, f"runs-on: {runs_on} — a Windows runner cannot be "
                                 "reproduced on this host")
            return

        print(f"\n{BRIGHT}▶ job {label}{RESET}")
        if runs_on and not runs_on.startswith(("ubuntu-", "macos-")):
            print(f"  {YELLOW}note{RESET} runs-on: {runs_on} (running on this host anyway)")
        if job.get("container"):
            image = job["container"]
            if isinstance(image, dict):
                image = image.get("image", "?")
            print(f"  {YELLOW}note{RESET} CI runs this job in container {image}; "
                  "this run uses the host toolchain")

        job_env = job.get("env") or {}
        defaults = ((job.get("defaults") or {}).get("run") or {})
        job_wd = defaults.get("working-directory") or ""
        steps = job.get("steps") or []
        if not isinstance(steps, list):
            self.skip_job(label, "steps is not a list")
            return
        self.job_ok = True
        for n, step in enumerate(steps, 1):
            if self.stopped:
                return
            if not isinstance(step, dict):
                continue
            self.run_step(job_id, step, n, len(steps), wf_env, job_env, job_wd, combo)

    def ctx_for(self, wf_env, job_env, step_env, combo):
        final = {}
        chain = []
        for layer in (wf_env, job_env, step_env):
            for k, v in (layer or {}).items():
                ctx = self.base_ctx(combo)
                ctx["env_chain"] = [final] + chain
                probe = []
                final[k] = expand(v, ctx, probe) if isinstance(v, str) else v
            chain.append(dict(final))
        all_env = dict(os.environ)
        all_env.update({k: str(v) for k, v in final.items() if v is not None})
        return self.base_ctx(combo, env_chain=[final, dict(os.environ)], environ=all_env)

    def base_ctx(self, combo, env_chain=None, environ=None):
        # GitHub's own name for this platform, so `if: runner.os == 'macOS'`
        # steps behave here exactly as they would on a macOS runner.
        runner_os = {"darwin": "macOS"}.get(sys.platform, "Linux")
        return {
            "github": self.github,
            "runner": {"os": runner_os, "arch": "ARM64" if platform.machine() == "arm64" else "X64",
                       "temp": self.runner_temp, "tool_cache": self.runner_temp},
            "matrix": combo or {},
            "env_chain": env_chain or [dict(os.environ)],
            "environ": environ or dict(os.environ),
            "job_ok": self.job_ok,
        }

    # ------------------------------------------------------------- step runner

    def run_step(self, job_id, step, n, total, wf_env, job_env, job_wd, combo):
        label = step_label(step)
        head = f"[{job_id} {n}/{total}] {label}"
        ctx0 = self.ctx_for(wf_env, job_env, {}, combo)

        if step.get("if"):
            probe = []
            verdict = eval_condition(str(step["if"]), ctx0, probe)
            if verdict is not True:
                why = f"if: {step['if']}" + ("" if verdict is None else " (false)")
                self.skip(head, why)
                return

        if step.get("uses"):
            self.current_ctx = ctx0
            self.run_uses(step, head, job_id, job_wd)
            return

        body = step.get("run")
        if not isinstance(body, str) or not body.strip():
            self.skip(head, "empty run step")
            return

        probe = []
        ctx = self.ctx_for(wf_env, job_env, step.get("env") or {}, combo)
        body_expanded = expand(body, ctx, probe)
        wd = step.get("working-directory") or job_wd
        wd_probe = []
        wd = expand(str(wd), ctx, wd_probe) if wd else ""
        probe.extend(wd_probe)
        if probe:
            self.skip(head, "needs GitHub context: "
                            + ", ".join(sorted(set(probe))[:3]))
            return

        apt = self.apt_step(body_expanded, head)
        if apt is not None:
            return

        cwd = ROOT / wd if wd else ROOT
        if not cwd.is_dir():
            self.fail(head, f"working-directory does not exist: {wd}", step)
            return

        # A CI checkout starts empty, so bootstrapping steps clone sibling repos
        # into ../. Locally those paths are the real sibling checkouts: cloning
        # over one fails, and the follow-up `git -C <sibling> checkout` would move
        # someone else's HEAD. Skip it loudly rather than mangle a working tree.
        if not self.args.get("allow_outside_clone"):
            over = [d for d in clone_targets(body_expanded, cwd)
                    if d.exists() and not str(d.resolve()).startswith(str(ROOT))]
            if over:
                self.skip(head, "would clone over an existing local checkout outside this "
                                f"repo ({over[0]}) — CI clones it, here it already exists. "
                                "Pass --allow-outside-clone to run it anyway")
                return

        env = dict(ctx["environ"])
        env.setdefault("CI", "true")
        env.setdefault("GITHUB_ACTIONS", "true")
        env["GITHUB_WORKSPACE"] = str(ROOT)
        if self.github.get("repository"):
            env["GITHUB_REPOSITORY"] = self.github["repository"]
        env["GITHUB_REF_NAME"] = self.github["ref_name"]
        env["GITHUB_EVENT_NAME"] = self.args.get("event", "pull_request")

        shell = step.get("shell") or "bash"
        if shell not in ("bash", "sh"):
            self.skip(head, f"shell: {shell} (not reproduced locally)")
            return
        cmd = [shell, "-e", "-c", body_expanded]

        if self.args.get("verbose") or self.args.get("plan"):
            where = f" (in {wd})" if wd else ""
            print(f"\n{BRIGHT}{CYAN}▶ {head}{RESET}{DIM}{where}{RESET}")
            print(f"{DIM}$ {body_expanded}{RESET}")
        else:
            print(f"\n{BRIGHT}▶ {head}{RESET}")
        if self.args.get("plan"):
            return

        started = time.time()
        code, output = stream_command(cmd, cwd, env)
        took = f"{time.time() - started:5.1f}s"
        if code == 0:
            self.out.ran += 1
            print(f"{GREEN}✓ {took} {head}{RESET}")
            return
        # CI checks out the COMMITTED tree only. A failure whose every mentioned
        # path lives in a gitignored/untracked path cannot happen in CI, so it is
        # reported as local-only rather than as a red gate — loudly, never silently.
        if not self.args.get("strict"):
            absent = ci_absent_hits(output, self.absent_prefixes)
            if absent:
                self.out.local_only.append(f"{head} (exit {code}; only in {absent})")
                print(f"{YELLOW}⚠ {took} {head} (exit {code}) — LOCAL ONLY: every path in "
                      f"the output is under {absent}, which CI's clean checkout does not "
                      f"have. Not a CI failure. Pass --strict to count it.{RESET}")
                return
        self.fail(head, f"exit {code}", step, took)

    def fail(self, head, why, step, took=""):
        self.job_ok = False
        if step is not None and step.get("continue-on-error"):
            self.out.advisory.append(head)
            print(f"{YELLOW}⚠ {took} {head} ({why}) "
                  f"— continue-on-error: advisory, as in CI{RESET}")
            return
        self.out.failed.append(f"{head} ({why})")
        print(f"{RED}✗ {took} {head} ({why}){RESET}")
        if not self.args.get("keep_going"):
            self.summary()
            self.stopped = True
            sys.exit(1)

    def skip(self, head, why):
        print(f"\n{YELLOW}▶ {head}{RESET}\n  {YELLOW}SKIP{RESET} {why}")
        self.out.skipped.append(f"{head}: {why}")

    def skip_job(self, job_id, why):
        print(f"\n{YELLOW}▶ job {job_id}{RESET}\n  {YELLOW}SKIP{RESET} {why}")
        self.out.skipped.append(f"job {job_id}: {why}")

    # -------------------------------------------------------------- uses: steps

    def emulate_checkout(self, step, head):
        """`actions/checkout` with a `with: path:` input checks the repository
        out at <workspace>/<path> rather than the workspace root, and the job
        then reaches it through `defaults.run.working-directory: <path>` and
        `uses: ./<path>/...`. The repo already IS the root here, so stage the
        same tree at the same relative path with a symlink (removed at exit);
        without it every `working-directory: <path>` step would fail against a
        directory CI itself creates."""
        rel = str((step.get("with") or {}).get("path") or "").strip()
        if not rel or Path(rel).is_absolute() or ".." in Path(rel).parts:
            print(f"\n{DIM}▶ {head}{RESET}\n  – no-op locally (checkout at the workspace root)")
            self.out.checked += 1
            return
        dest = ROOT / rel
        if dest.exists() or dest.is_symlink():
            print(f"\n{DIM}▶ {head}{RESET}\n  – no-op locally (a real {rel}/ is "
                  f"already here; CI would check the repo out over it)")
            self.out.checked += 1
            return
        try:
            dest.parent.mkdir(parents=True, exist_ok=True)
            dest.symlink_to(ROOT, target_is_directory=True)
        except OSError as exc:
            print(f"\n{YELLOW}▶ {head}{RESET}\n  {YELLOW}SKIP{RESET} cannot stage the "
                  f"checkout path {rel}/: {exc}")
            self.out.skipped.append(f"{head}: checkout path {rel}: {exc}")
            return
        CHECKOUT_LINKS.append(dest)
        print(f"\n{DIM}▶ {head}{RESET}\n  – checked out at {rel}/ (symlink to this "
              f"checkout, removed when the run ends)")
        self.out.checked += 1

    def run_uses(self, step, head, job_id, job_wd):
        uses = step["uses"]
        wants = step.get("with") or {}

        if any(uses.startswith(a) or a in uses for a in ("actions/checkout",)):
            self.emulate_checkout(step, head)
            return
        if any(s in uses for s in ("actions/cache", "cache/", "upload-artifact",
                                   "download-artifact", "codecov/",
                                   "actions/github-script")):
            print(f"\n{DIM}▶ {head}{RESET}\n  – no-op locally (cache/artifact/coverage)")
            self.out.checked += 1
            return

        for pattern, tool, version_keys, vargs in TOOLCHAIN_ACTIONS:
            if pattern in uses:
                self.assert_toolchain(head, tool, version_keys, vargs, wants, job_wd)
                return

        print(f"\n{YELLOW}▶ {head}{RESET}\n  {YELLOW}SKIP{RESET} action {uses} "
              f"(no local equivalent)")
        self.out.skipped.append(f"{head}: action {uses}")

    def assert_toolchain(self, head, tool, version_keys, vargs, wants, job_wd):
        print(f"\n{BRIGHT}▶ {head}{RESET}")
        exe = shutil.which(tool)
        got_line = tool_version(exe, vargs)
        got = version_of(got_line) or got_line
        ctx = getattr(self, "current_ctx", None) or self.base_ctx(None)
        wants_version, version_key = None, None
        for key in version_keys:
            if key in wants:
                wants_version, version_key = str(wants[key]), key
                break
        if wants_version and has_expr(wants_version):
            probe = []
            wants_version = expand(wants_version, ctx, probe)
            if probe:
                print(f"  {YELLOW}SKIP{RESET} toolchain version needs GitHub context: "
                      f"{', '.join(sorted(set(probe))[:2])}")
                self.out.skipped.append(f"{head}: dynamic toolchain version")
                return
        if version_key and version_key.endswith("-version-file"):
            rel = expand(str(wants[version_key]), ctx, [])
            path = ROOT / rel
            if path.exists():
                wants_version = path.read_text(errors="replace").strip().split("\n")[0].strip()
            else:
                print(f"  {YELLOW}SKIP{RESET} {version_key} {rel} does not exist here")
                self.out.skipped.append(f"{head}: {version_key} {rel} not found")
                return
        if not exe:
            self.out.failed.append(f"{head} ({tool} not installed)")
            print(f"  {RED}✗{RESET} {tool} is NOT installed — this step would fail in CI too")
            return
        if not wants_version or wants_version.lower() in ("stable", "beta", "dev",
                                                          "latest", "current"):
            print(f"  {GREEN}✓{RESET} {tool} {got_line} (workflow pins: "
                  f"{wants_version or 'default'})")
            self.out.checked += 1
            return
        verdict = version_matches(wants_version, got)
        if verdict:
            print(f"  {GREEN}✓{RESET} {tool} {got} (workflow pins {wants_version})")
            self.out.checked += 1
        else:
            self.out.advisory.append(f"{head}: local {tool} {got} != CI {wants_version}")
            print(f"  {YELLOW}⚠{RESET} local {tool} is {got or 'missing'}, workflow pins "
                  f"{wants_version} — results may differ from CI")

    # ----------------------------------------------------------------- apt step

    def apt_step(self, body, head):
        if not re.search(r"\bapt(-get)?\b", body):
            return None
        print(f"\n{BRIGHT}▶ {head}{RESET}")
        print(f"  {YELLOW}SKIP{RESET} apt-get is Linux-only; checking the local equivalent")
        names = [a or b or c for a, b, c in
                 re.findall(r"'([\w.+-]+)'|\"([\w.+-]+)\"|([A-Za-z][\w.+-]*-dev)\b", body)]
        for name in dict.fromkeys(names):
            equiv = APT_EQUIVALENTS.get(name)
            if not equiv:
                print(f"  {YELLOW}⚠{RESET} no local mapping for apt package {name!r} — "
                      "not validated here (it may still be needed in CI)")
                continue
            label, tool = equiv
            if tool is None:
                print(f"  {YELLOW}⚠{RESET} {label}: no macOS equivalent to probe — "
                      "not validated here")
                continue
            found = shutil.which(tool)
            if found:
                print(f"  {GREEN}✓{RESET} {label}: {tool} present ({found})")
                self.out.checked += 1
            else:
                print(f"  {YELLOW}⚠{RESET} {label}: {tool} not found locally "
                      "(needed by the CI build)")
                self.out.advisory.append(f"{head}: {label} not probeable locally")
        return True

    # ---------------------------------------------------------------- summary

    def summary(self):
        print("\n" + "─" * 64)
        print(f"local_ci: {self.out.ran} step(s) ran, {self.out.checked} checked/pinned, "
              f"{len(self.out.skipped)} skipped, {len(self.out.advisory)} advisory, "
              f"{len(self.out.local_only)} local-only, {len(self.out.failed)} failed")
        for f in self.out.failed:
            print(f"  {RED}✗ {f}{RESET}")
        for f in self.out.local_only:
            print(f"  {YELLOW}⚠ local-only failure{RESET} {f}")
        for f in self.out.advisory:
            print(f"  {YELLOW}⚠ {f}{RESET}")
        for s in self.out.skipped:
            print(f"  {YELLOW}· skipped{RESET} {s}")


def stream_command(cmd, cwd, env, cap=400_000):
    """Run a step, echo its output live, and return (exit code, captured tail)."""
    buf, total = [], 0
    proc = subprocess.Popen(cmd, cwd=str(cwd), env=env, stdout=subprocess.PIPE,
                            stderr=subprocess.STDOUT, text=True, bufsize=1)
    try:
        for line in proc.stdout:
            sys.stdout.write(line)
            if total < cap:
                buf.append(line)
                total += len(line)
    finally:
        if proc.stdout:
            proc.stdout.close()
        proc.wait()
    return proc.returncode, "".join(buf)


def ci_absent_prefixes():
    """Paths that exist here but not in CI's checkout: gitignored and untracked.

    Regenerated-everywhere directories (`build/`, `.dart_tool/`, `node_modules/`)
    are excluded: a failure naming one of those is a real failure, not local junk.
    """
    out = []
    for extra in (["--others", "--ignored", "--exclude-standard"],
                  ["--others", "--exclude-standard"]):
        text = run_git("ls-files", *extra, "--directory")
        for line in text.split("\n"):
            line = line.strip()
            if line and not _ci_absent_noise(line):
                out.append(line.rstrip("/") + "/")
    return sorted(set(out))


def _ci_absent_noise(path):
    base = path.rstrip("/").split("/")[-1]
    if base in ("build", ".dart_tool", "node_modules", "__pycache__", ".DS_Store",
                ".packages", ".git"):
        return True
    if path.startswith((".DS_Store", ".env", ".packages", ".flutter-plugins")):
        return True
    return path.endswith((".db", ".db-shm", ".db-wal", ".pyc"))


PATH_RE = re.compile(
    r"(?:^|[\s\"'(=:])([\w./@+-]+\.(?:dart|ts|tsx|js|jsx|mjs|cjs|py|rs|go|swift|kt|kts|"
    r"java|rb|php|cs|cc|cpp|cxx|h|hpp|sh|json|ya?ml|md|lock|toml))(?::\d+)?(?::\d+)?")

# Lines that announce a failure. Only these (and the few lines right after them,
# where e.g. cargo puts its ` --> path`) are asked "which file is this about?" —
# listing every path in the output would count harmless lint infos in tracked
# files and mask a genuine local-only failure.
FAIL_HINT = re.compile(r"(^|\s)(error|Error|ERROR|FAILED|FAIL|failed)\b|:\s*error\b")


def failure_paths(output):
    lines = (output or "").split("\n")
    paths, i = [], 0
    while i < len(lines):
        if FAIL_HINT.search(lines[i]):
            window, j = [lines[i]], i + 1
            # Only a genuine continuation (cargo's ` --> src/main.rs:3:5`) belongs
            # to this failure; the next diagnostic usually starts right after it.
            while j < len(lines) and j <= i + 6 and lines[j].strip():
                if FAIL_HINT.search(lines[j]):
                    break
                if "-->" in lines[j] or re.match(r"^\s*(note|help|expected|found)\s*:",
                                                 lines[j]):
                    window.append(lines[j])
                    j += 1
                    continue
                break
            for line in window:
                # The FIRST path on a diagnostic line is the file being diagnosed;
                # later ones are just mentioned in the message (e.g. a bad import
                # target), so they must not decide the verdict.
                m = PATH_RE.search(line)
                if m:
                    paths.append(m.group(1))
            i = j
        else:
            i += 1
    return paths


def ci_absent_hits(output, prefixes):
    """The CI-absent prefix covering every path the FAILURE output names, if any.

    Returns None when the failure names nothing, or names any path that CI's
    checkout would have — either way it is not explainable as local-only.
    """
    if not prefixes:
        return None
    found = failure_paths(output)
    if not found:
        return None
    matched = set()
    for raw in found:
        p = raw.lstrip("./")
        for pre in prefixes:
            base = pre.rstrip("/")
            if p == base or p.startswith(base + "/"):
                matched.add(base + "/")
                break
        else:
            return None  # a path CI does have: this is a real failure
    return ", ".join(sorted(matched))


def step_label(step):
    if step.get("name"):
        return str(step["name"])
    if step.get("uses"):
        return str(step["uses"])
    first = (step.get("run") or "").strip().split("\n")[0]
    return (first[:70] if first else "(unnamed step)")


def tool_version(exe, args=("--version",)):
    if not exe:
        return ""
    try:
        out = subprocess.run([exe, *args], capture_output=True, text=True, timeout=60)
        text = (out.stdout or "") + (out.stderr or "")
        return text.strip().split("\n")[0].strip()
    except Exception:
        return "present"


VERSION_RE = re.compile(r"\d+\.\d+(?:\.\d+)*")


def version_of(text):
    """The version number inside a tool's `--version` banner."""
    m = VERSION_RE.search(text or "")
    if m:
        return m.group(0)
    m = re.search(r"\b\d+\b", text or "")
    return m.group(0) if m else ""


def version_matches(want, have):
    """True/False/None. A short pin like `22` matches any `22.x.y`."""
    if not want or not have:
        return None
    w, h = want.strip().lstrip("v"), have.strip().lstrip("v")
    if w == h:
        return True
    if re.match(r"^\d+(\.\d+)?$", w):
        return h == w or h.startswith(w + ".")
    return False


def clone_targets(body, base):
    """`git clone <url> <dst>` destinations, resolved, for the outside-repo guard."""
    out = []
    for m in re.finditer(r"git\s+clone\b([^\n;&|]*)", body):
        try:
            toks = shlex.split(m.group(1), posix=True)
        except ValueError:
            continue
        positional = [t for t in toks if not t.startswith("-")]
        if len(positional) >= 2:
            dst = Path(positional[-1])
            if not dst.is_absolute():
                dst = base / dst
            out.append(dst)
    return out


def expand_matrix(matrix, ctx):
    """Matrix combos (cross product, then include/exclude), or None if unmodelled."""
    unresolved = []
    if not matrix:
        return [None]
    if not isinstance(matrix, dict):
        return None
    if has_expr(json_dumps(matrix)):
        matrix = json_loads(expand(json_dumps(matrix), ctx, unresolved))
        if unresolved:
            return None
    axes = {k: v for k, v in matrix.items() if k not in ("include", "exclude")}
    for v in axes.values():
        if not isinstance(v, list):
            return None
    keys = list(axes)
    include = matrix.get("include") or []
    if include and not isinstance(include, list):
        return None
    if keys:
        combos = [dict(zip(keys, vals))
                  for vals in itertools.product(*(axes[k] for k in keys))]
    elif include:
        combos = []  # every combination comes from `include`
    else:
        combos = [{}]
    for entry in include:
        if not isinstance(entry, dict):
            return None
        targets = [c for c in combos
                   if all(k not in c or c[k] == v for k, v in entry.items())]
        if targets and all(k in targets[0] for k in entry):
            for c in targets:
                c.update(entry)  # a plain override of existing combinations
        else:
            for c in (targets or [{}]):
                merged = dict(c)
                merged.update(entry)
                combos.append(merged)
    exclude = matrix.get("exclude") or []
    if exclude:
        if not isinstance(exclude, list):
            return None
        for entry in exclude:
            if not isinstance(entry, dict):
                return None
            combos = [c for c in combos
                      if not all(k in c and c[k] == v for k, v in entry.items())]
    return combos or [None]


def json_dumps(obj):
    return json.dumps(obj)


def json_loads(text):
    try:
        return json.loads(text)
    except ValueError:
        return {}


def job_order(jobs):
    ids, done, out, remaining = list(jobs), set(), [], list(jobs)
    while remaining:
        progressed = False
        for jid in list(remaining):
            job = jobs[jid] if isinstance(jobs[jid], dict) else {}
            needs = job.get("needs") or []
            if isinstance(needs, str):
                needs = [needs]
            if all(n in done or n not in ids for n in needs):
                out.append(jid)
                done.add(jid)
                remaining.remove(jid)
                progressed = True
        if not progressed:
            out.extend(remaining)
            break
    return out


def normalize_triggers(on):
    if on is None:
        return []
    if isinstance(on, str):
        return [on]
    if isinstance(on, list):
        return [str(x) for x in on]
    if isinstance(on, dict):
        return list(on)
    return []


def workflow_files():
    wfdir = ROOT / ".github" / "workflows"
    if not wfdir.is_dir():
        return None
    return sorted(p for p in wfdir.iterdir()
                  if p.suffix in (".yml", ".yaml") and p.is_file())


# A gate is the workflow that actually checks the change. Names that say so.
PREFERRED_NAME = re.compile(
    r"\b(ci|test|tests|check|checks|build|lint|analyze|analysis|validate|validation|"
    r"quality|gate|pipeline|dart|flutter|rust|cargo|go|node|python)\b", re.I)
# Names that are automation around a PR, not a check of it. Running one of these
# locally would call a bot, publish, or relabel — never what "is CI green" means.
NON_GATE_NAME = re.compile(
    r"claude|codex|copilot|coderabbit|review|label|release|publish|deploy|stale|slash|"
    r"\bcla\b|sync|bot|autofix|comment|dependabot|docs|website|preview|docker|nix|"
    r"changelog|notification|mirror|approve", re.I)


def pick_workflow(files, event):
    """(workflow path, note) for the workflow that runs on `event`."""
    if not files:
        return None, ""
    parsed = []
    for p in files:
        try:
            triggers = normalize_triggers(parse_workflow(p).get("on"))
        except YamlError:
            continue
        parsed.append((p, triggers))
    gates = [p for p, triggers in parsed if event in triggers]
    if not gates:
        # The event is not what this repo gates on (a tag/push-only repo): take
        # the first workflow that has any trigger at all, and say so.
        for p, triggers in parsed:
            if triggers:
                return p, f"no workflow runs on {event}; using {p.name} instead"
        return files[0], f"no workflow declares triggers; using {files[0].name}"
    real = [p for p in gates if not NON_GATE_NAME.search(p.stem)]
    pool = real or gates
    note = ""
    if not real:
        note = (f"every {event} workflow looks like automation (bot/release/label), "
                f"not a gate; using {pool[0].name}")
    pref = [p for p in pool if PREFERRED_NAME.search(p.stem)]
    chosen = pref[0] if pref else pool[0]
    if not pref and not note:
        note = f"no gate-looking name among the {event} workflows; using {chosen.name}"
    if len(pool) > 1 and chosen != pool[0] and not note:
        note = f"{len(pool)} {event} workflows; using {chosen.name}"
    return chosen, note


def guess_slug():
    url = run_git("remote", "get-url", "origin")
    m = re.search(r"[:/]([^/]+/[^/]+?)(?:\.git)?$", url or "")
    return m.group(1) if m else ""


def run_git(*args):
    try:
        return subprocess.run(["git", "-C", str(ROOT), *args], capture_output=True,
                              text=True, timeout=30).stdout.strip()
    except Exception:
        return ""


def main(argv):
    args = {"workflow": None, "job": None, "event": "pull_request", "plan": False,
            "keep_going": False, "verbose": False, "allow_outside_clone": False,
            "strict": False}
    i = 0
    while i < len(argv):
        a = argv[i]
        if a in ("--workflow", "--job", "--event"):
            if i + 1 >= len(argv):
                return err(f"{a} needs a value")
            args[a[2:]] = argv[i + 1]
            i += 2
        elif a in ("--plan", "--dry-run"):
            args["plan"] = True
            i += 1
        elif a == "--keep-going":
            args["keep_going"] = True
            i += 1
        elif a == "--allow-outside-clone":
            args["allow_outside_clone"] = True
            i += 1
        elif a == "--strict":
            args["strict"] = True
            i += 1
        elif a in ("-v", "--verbose"):
            args["verbose"] = True
            i += 1
        elif a == "--list":
            return do_list()
        elif a in ("-h", "--help"):
            print(__doc__ or "see the header of local_ci.sh")
            return 0
        else:
            return err(f"unknown argument {a!r}")
    return run(args)


def err(msg):
    sys.stderr.write(f"local_ci.sh: {msg}\n")
    return 2


def do_list():
    files = workflow_files()
    if files is None:
        sys.stderr.write("local_ci.sh: no .github/workflows in this repo — "
                         "there is no CI gate to run locally\n")
        return 2
    if not files:
        sys.stderr.write("local_ci.sh: .github/workflows is empty\n")
        return 2
    print(f"{BRIGHT}local_ci{RESET}  repo={ROOT}")
    for p in files:
        try:
            doc = parse_workflow(p)
        except YamlError as exc:
            print(f"  {p.name:32s} {YELLOW}unreadable: {exc}{RESET}")
            continue
        triggers = ",".join(normalize_triggers(doc.get("on"))) or "?"
        jobs = doc.get("jobs") or {}
        print(f"  {p.name:32s} on={triggers:34s} "
              f"jobs={','.join(jobs) if isinstance(jobs, dict) else '?'}")
    return 0


def run(args):
    explicit = args["workflow"]
    if explicit:
        wf = Path(explicit)
        if not wf.is_absolute():
            wf = ROOT / wf
        if not wf.exists():
            return err(f"workflow not found: {wf}")
    else:
        files = workflow_files()
        if files is None:
            return err("no .github/workflows in this repo — "
                       "there is no CI gate to run locally")
        if not files:
            return err(".github/workflows is empty")
        wf, wf_note = pick_workflow(files, args["event"])
        if wf is None:
            return err(f"no workflow in .github/workflows runs on {args['event']}")

    try:
        doc = parse_workflow(wf)
    except YamlError as exc:
        return err(f"could not read {wf}: {exc}")

    print(f"{BRIGHT}local_ci{RESET}  repo={ROOT}")
    print(f"  workflow : {wf.relative_to(ROOT) if wf.is_relative_to(ROOT) else wf}"
          f"  ({doc.get('name') or 'unnamed'})")
    if wf_note:
        print(f"  {YELLOW}note     : {wf_note} (--workflow <path> picks another){RESET}")
    print(f"  event    : {args['event']} (simulated)")
    print(f"  platform : CI runs ubuntu-latest (Linux); this is {sys.platform}. "
          "Step set identical, platform not.")

    runner = Runner(wf, doc, args)
    runner.github = build_github(guess_slug(), run_git("rev-parse", "--abbrev-ref", "HEAD"),
                                 args["event"], str(doc.get("name") or ""),
                                 run_git("rev-parse", "HEAD"))
    runner.runner_temp = tempfile.mkdtemp(prefix="local_ci_")
    if runner.absent_prefixes:
        print(f"  note     : this checkout has {len(runner.absent_prefixes)} "
              "gitignored/untracked path(s) that CI's clean checkout does not "
              "(list: git ls-files --others --ignored --exclude-standard --directory). "
              "Whole-tree commands (e.g. `dart analyze .`) see them; a failure confined "
              "to them is reported as local-only, not as a CI failure.")
    if run_git("status", "--porcelain"):
        print("  note     : working tree has uncommitted changes; CI runs the "
              "committed tree")
    runner.run()
    runner.summary()
    if args["plan"]:
        print("(plan only — nothing was executed)")
    return 1 if runner.out.failed else 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
LOCAL_CI_PY
