#!/usr/bin/env node
// Spec Stats — spec portfolio dashboard generator.
//
// Subcommands:
//   report [--json] [--out <path>] [--render-in <stats.json>]   scan + render (default)
//   scan   [--json] [--out <path>]                              emit stats.json only
//   render [--in <stats.json>] [--out <path>]                  stats.json -> markdown
//   open   [--stale-after <days>] [--json]                      specs not complete
//   not-green [--json]                                         specs with red/unknown health
//   reconcile [--all|<spec>...] [--dry-run] [--drop-mark checked|unchecked]
//                                                          fix tasks.md checkboxes from TDD behaviors
//   runs   [--all|<spec>...] [--dry-run]                       run verified suite per spec
//   record-run --spec <s> --status pass|fail --ms <n> [--tail "..."]
//
// All reads are relative to the current working directory (the host project).
// The TDD-deep table appears only when the TDD extension is installed in that project.

import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { execFileSync } from 'node:child_process';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const ROOT = process.cwd();

// ---------------------------------------------------------------------------
// Config
// ---------------------------------------------------------------------------

function loadConfig() {
  const defaults = {
    output_path: '.specify/stats/SPEC-STATS.md',
    specs_dir: 'specs',
    sort_by: 'number',
    include_bugs: true,
    include_chores: true,
    include_tupec: true,
    use_git: true,
    stale_after_days: 14,
    runs_history_limit: 50,
    emoji: true,
  };
  const p = path.join(ROOT, '.specify', 'extensions', 'spec-stats', 'spec-stats-config.yml');
  if (!fs.existsSync(p)) return defaults;
  try {
    const text = fs.readFileSync(p, 'utf8');
    for (const line of text.split('\n')) {
      const m = line.match(/^([a-z_]+):\s*(.*)$/);
      if (!m) continue;
      let v = m[2].trim();
      if (!v || v.startsWith('#')) continue;
      v = v.replace(/^["']|["']$/g, '');
      if (v === 'true') defaults[m[1]] = true;
      else if (v === 'false') defaults[m[1]] = false;
      else if (/^\d+$/.test(v)) defaults[m[1]] = Number(v);
      else defaults[m[1]] = v;
    }
  } catch { /* keep defaults */ }
  return defaults;
}

// ---------------------------------------------------------------------------
// Filesystem helpers
// ---------------------------------------------------------------------------

const exists = (p) => fs.existsSync(path.join(ROOT, p));
const read = (p) => fs.readFileSync(path.join(ROOT, p), 'utf8');
const readOpt = (p) => (exists(p) ? read(p) : '');

function specsRoot(cfg) {
  return path.join(ROOT, cfg.specs_dir);
}

function listSpecDirs(cfg) {
  const dir = specsRoot(cfg);
  if (!fs.existsSync(dir)) return [];
  return fs.readdirSync(dir)
    .filter((n) => fs.statSync(path.join(dir, n)).isDirectory())
    .filter((n) => /^\d/.test(n))
    .map((n) => ({ dir: n, number: parseInt(n, 10), slug: n.replace(/^\d+-/, '') }))
    .sort((a, b) => (cfg.sort_by === 'number' ? a.number - b.number : a.dir.localeCompare(b.dir)));
}

// ---------------------------------------------------------------------------
// Stage + progress
// ---------------------------------------------------------------------------

function countTasks(specDir) {
  const md = readOpt(path.join(specDir, 'tasks.md'));
  if (!md) return { total: 0, checked: 0 };
  let total = 0, checked = 0;
  for (const line of md.split('\n')) {
    const m = line.match(/^\s*[-*]\s*\[([ xX])\]/);
    if (m) { total++; if (m[1] !== ' ') checked++; }
  }
  return { total, checked };
}

function detectStage(specDir) {
  const has = (f) => exists(path.join(specDir, f));
  if (!has('spec.md')) return 'absent';
  if (!has('plan.md')) return 'specified';
  if (!has('tasks.md')) return 'planned';
  const t = countTasks(specDir);
  if (t.total === 0) return 'tasked';
  if (t.checked === 0) return 'tasked';
  if (t.checked === t.total) return 'complete';
  return 'implementing';
}

function lastUpdated(specDir, cfg) {
  if (cfg.use_git && exists('.git')) {
    try {
      const out = execFileSync('git', ['log', '-1', '--format=%ci %h', '--', specDir],
        { cwd: ROOT, encoding: 'utf8', stdio: ['ignore', 'pipe', 'ignore'] }).trim();
      if (out) {
        const [date, sha] = out.split(' ');
        return { date, sha };
      }
    } catch { /* fall through */ }
  }
  try {
    const st = fs.statSync(path.join(ROOT, specDir));
    return { date: st.mtime.toISOString().slice(0, 10), sha: null };
  } catch { return { date: null, sha: null }; }
}

// ---------------------------------------------------------------------------
// TDD deep parsing
// ---------------------------------------------------------------------------

function tddInstalled() {
  return exists(path.join('.specify', 'memory', 'tdd-profile.md')) ||
    exists(path.join('.specify', 'extensions', 'tdd'));
}

function parseFrontmatter(text) {
  const m = text.match(/^---\n([\s\S]*?)\n---/);
  if (!m) return {};
  const fm = {};
  for (const line of m[1].split('\n')) {
    const kv = line.match(/^(\w+):\s*(.*)$/);
    if (kv) fm[kv[1]] = kv[2].trim();
  }
  return fm;
}

// Parse a TDD test-list.md into behavior rows.
function parseTestList(text) {
  const fm = parseFrontmatter(text);
  const rows = [];
  for (const line of text.split('\n')) {
    if (!line.startsWith('|')) continue;
    const cells = line.split('|').slice(1, -1).map((c) => c.trim());
    if (cells.length < 6) continue;
    const id = cells[0];
    if (!/^[AUC]\d+$/.test(id)) continue;
    rows.push({ id, kind: (cells[3] || '').toLowerCase(), state: (cells[4] || '').toUpperCase() });
  }
  const aCount = rows.filter((r) => r.id[0] === 'A').length;
  const uCount = rows.filter((r) => r.id[0] === 'U').length;
  const charCount = rows.filter((r) => r.kind === 'characterization').length;
  const doneCount = rows.filter((r) => r.state === 'DONE').length;
  const hasUnit = uCount > 0;
  const loop = !hasUnit
    ? 'outer-only'
    : (fm.loop === 'inside-out' ? 'inside-out' : 'full');
  return { present: true, loop, aCount, uCount, charCount, doneCount };
}

function tasksMarked(specDir) {
  const md = readOpt(path.join(specDir, 'tasks.md'));
  return /\[(A|U|C)\d+\]/.test(md);
}

function tddStatsFor(specDir) {
  const tl = path.join(specDir, 'tdd', 'test-list.md');
  if (!exists(tl)) {
    return { present: false, loop: 'absent', aCount: 0, uCount: 0, charCount: 0, doneCount: 0, tasks: '-' };
  }
  const parsed = parseTestList(read(tl));
  return { ...parsed, tasks: tasksMarked(specDir) ? 'updated' : 'absent' };
}

// ---------------------------------------------------------------------------
// Scan
// ---------------------------------------------------------------------------

function scan(cfg) {
  const specs = listSpecDirs(cfg).map((s) => {
    const fsDir = path.join(cfg.specs_dir, s.dir);
    const stage = detectStage(fsDir);
    const t = countTasks(fsDir);
    const tdd = tddInstalled() ? tddStatsFor(fsDir) : null;
    const lu = lastUpdated(fsDir, cfg);
    const percent = t.total ? Math.round((t.checked / t.total) * 100) : 0;
    return {
      id: s.dir,
      number: s.number,
      slug: s.slug,
      stage,
      progress: { checked: t.checked, total: t.total, percent },
      tdd,
      lastUpdated: lu,
    };
  });

  const summary = { total: specs.length, byStage: {} };
  for (const s of specs) summary.byStage[s.stage] = (summary.byStage[s.stage] || 0) + 1;

  const tdd = {
    installed: tddInstalled(),
    totals: specs.reduce((acc, s) => {
      if (s.tdd) {
        acc.aCount += s.tdd.aCount;
        acc.uCount += s.tdd.uCount;
        acc.charCount += s.tdd.charCount;
        acc.doneCount += s.tdd.doneCount;
      }
      return acc;
    }, { aCount: 0, uCount: 0, charCount: 0, doneCount: 0 }),
  };

  return { generatedAt: new Date().toISOString(), repoName: path.basename(ROOT), specs, summary, tdd };
}

// ---------------------------------------------------------------------------
// Box table renderer (left-aligned, UTF-8 box drawing)
// ---------------------------------------------------------------------------

function boxTable(headers, rows) {
  const cols = headers.length;
  const widths = headers.map((h, i) => {
    let w = h.length;
    for (const r of rows) w = Math.max(w, String(r[i] ?? '').length);
    return w;
  });
  const bar = (l, m, r) =>
    l + widths.map((w) => '─'.repeat(w + 2)).join(m) + r;
  const row = (cells) =>
    '│' + cells.map((c, i) => ' ' + String(c ?? '').padEnd(widths[i]) + ' ').join('│') + '│';

  let out = '';
  out += bar('┌', '┬', '┐') + '\n';
  out += row(headers) + '\n';
  out += bar('├', '┼', '┤') + '\n';
  for (const r of rows) {
    out += row(r) + '\n';
  }
  out += bar('└', '┴', '┘') + '\n';
  return out;
}

// ---------------------------------------------------------------------------
// Render (markdown)
// ---------------------------------------------------------------------------

function renderMarkdown(data, cfg) {
  const lines = [];
  lines.push(`# Spec Stats Dashboard: ${data.repoName}`);
  lines.push('');
  lines.push(`*Generated: ${data.generatedAt} | Repo: ${data.repoName} | TDD: ${data.tdd.installed ? 'installed' : 'not installed'}*`);
  lines.push('');

  // Portfolio summary
  lines.push('## Portfolio Summary');
  lines.push('');
  lines.push('| Stage | Count |');
  lines.push('|-------|-------|');
  const stageOrder = ['specified', 'planned', 'tasked', 'test-listed', 'implementing', 'complete', 'absent'];
  const stages = new Set([...stageOrder, ...Object.keys(data.summary.byStage)]);
  for (const st of stages) {
    if (data.summary.byStage[st] != null) {
      lines.push(`| ${st} | ${data.summary.byStage[st]} |`);
    }
  }
  lines.push('');
  lines.push(`**Overall**: ${data.summary.total} specs`);
  lines.push('');

  // At a glance (stage / progress)
  lines.push('## At a Glance');
  lines.push('');
  const glance = [['#', 'feature', 'stage', 'progress']];
  for (const s of data.specs) {
    glance.push([
      String(s.number).padStart(3, '0'),
      s.slug,
      s.stage,
      s.progress.total ? `${s.progress.percent}% (${s.progress.checked}/${s.progress.total})` : '—',
    ]);
  }
  lines.push(boxTable(glance[0], glance.slice(1)));
  lines.push('');

  // TDD deep table
  if (data.tdd.installed) {
    lines.push('## TDD Deep Stats');
    lines.push('');
    const headers = ['#', 'feature', 'A', 'U', 'char', 'DONE', 'loop', 'tasks.md'];
    const rows = data.specs.map((s) => {
      const t = s.tdd || { present: false, loop: 'absent', aCount: 0, uCount: 0, charCount: 0, doneCount: 0, tasks: '-' };
      return [
        String(s.number).padStart(3, '0'),
        s.slug,
        String(t.aCount),
        String(t.uCount),
        String(t.charCount),
        String(t.doneCount),
        t.loop,
        t.tasks,
      ];
    });
    const totals = ['', 'total',
      String(data.tdd.totals.aCount),
      String(data.tdd.totals.uCount),
      String(data.tdd.totals.charCount),
      String(data.tdd.totals.doneCount),
      '', ''];
    rows.push(totals);
    lines.push(boxTable(headers, rows));
    lines.push('');
    lines.push('- `A` acceptance behaviors, `U` unit behaviors, `char` characterization behaviors, `DONE` behaviors in `DONE` state.');
    lines.push('- `loop`: `full` (outer + inner derived), `outer-only` (acceptance only), `inside-out`, or `absent` (no TDD list).');
    lines.push('- `tasks.md`: `updated` (TDD markers present) or `absent`.');
    lines.push('');
  }

  return lines.join('\n');
}

// ---------------------------------------------------------------------------
// Open view
// ---------------------------------------------------------------------------

function openView(data, cfg) {
  const rows = data.specs.filter((s) => s.stage !== 'complete' && s.stage !== 'absent');
  const lines = ['# Spec Stats — Open (not complete)', ''];
  if (!rows.length) { lines.push('_Nothing open._'); return lines.join('\n'); }
  for (const s of rows) {
    const lu = s.lastUpdated.date || 'unknown';
    const days = lu !== 'unknown'
      ? Math.floor((Date.now() - new Date(lu).getTime()) / 86400000)
      : null;
    const stale = days != null && days > cfg.stale_after_days;
    lines.push(`- **${s.id}** — stage \`${s.stage}\`${stale ? ` ⚠️ stale (${days}d)` : ''}`);
    lines.push(`  - progress: ${s.progress.total ? `${s.progress.checked}/${s.progress.total}` : 'n/a'} | last updated: ${lu}`);
  }
  return lines.join('\n');
}

// ---------------------------------------------------------------------------
// Not-green view
// ---------------------------------------------------------------------------

function notGreenView(data, cfg) {
  const lines = ['# Spec Stats — Not Green', ''];
  let any = false;
  for (const s of data.specs) {
    if (!s.tdd || !s.tdd.present) continue;
    const tl = path.join(s.id, 'tdd', 'test-list.md');
    const anyDone = s.tdd.doneCount > 0;
    if (anyDone) continue;
    any = true;
    lines.push(`- **${s.id}** — TDD list present but 0 DONE behaviors (loop: ${s.tdd.loop})`);
  }
  if (!any) lines.push('_All TDD-tracked specs have at least one DONE behavior, or none are TDD-tracked._');
  return lines.join('\n');
}

// ---------------------------------------------------------------------------
// Reconcile — fix tasks.md checkboxes based on TDD test-list.md DONE behaviors
// ---------------------------------------------------------------------------

// Parse test-list.md and return behavior IDs with their states.
function parseTestListFull(text) {
  const behaviors = new Map(); // id → state
  for (const line of text.split('\n')) {
    if (!line.startsWith('|')) continue;
    const cells = line.split('|').slice(1, -1).map((c) => c.trim());
    if (cells.length < 6) continue;
    const id = cells[0];
    if (!/^[AUC]\d+$/.test(id)) continue;
    const state = (cells[4] || '').toUpperCase();
    behaviors.set(id, state);
  }
  return behaviors;
}

// Extract behavior markers from a task line (e.g., [A1], [U8], [U44]).
function extractBehaviorMarkers(line) {
  const markers = [];
  const re = /\[([AUC]\d+)\]/g;
  let m;
  while ((m = re.exec(line)) !== null) {
    markers.push(m[1]);
  }
  return markers;
}

// Check if a file path referenced in a task exists.
function extractFilePaths(line) {
  const paths = [];
  // Match backtick-quoted paths: `lib/src/foo.dart`
  const backtickRe = /`([^`]+\.[a-z]{1,5})`/g;
  let m;
  while ((m = backtickRe.exec(line)) !== null) {
    paths.push(m[1]);
  }
  // Match bare paths: lib/src/foo.dart or test/unit/foo_test.dart
  const bareRe = /((?:lib|test|bin|src)\/[\w/._-]+\.(?:dart|ts|js|py|go|rs))/g;
  while ((m = bareRe.exec(line)) !== null) {
    if (!paths.includes(m[1])) paths.push(m[1]);
  }
  return paths;
}

function reconcileSpec(specDir, cfg, opts) {
  const tasksPath = path.join(specDir, 'tasks.md');
  const tlPath = path.join(specDir, 'tdd', 'test-list.md');
  const dryRun = opts.dryRun;
  const dropMark = opts.dropMark || 'unchecked';

  // Read tasks.md
  if (!fs.existsSync(path.join(ROOT, tasksPath))) {
    return { spec: specDir, changed: 0, skipped: 0, verified: 0, needsCheck: 0, error: 'no tasks.md' };
  }
  const tasksText = fs.readFileSync(path.join(ROOT, tasksPath), 'utf8');

  // Parse test-list.md for DONE/DROPPED behaviors
  let doneBehaviors = new Set();
  let droppedBehaviors = new Set();
  const hasTestList = fs.existsSync(path.join(ROOT, tlPath));
  if (hasTestList) {
    const tlText = fs.readFileSync(path.join(ROOT, tlPath), 'utf8');
    const behaviors = parseTestListFull(tlText);
    for (const [id, state] of behaviors) {
      if (state === 'DONE') doneBehaviors.add(id);
      else if (state === 'DROPPED') droppedBehaviors.add(id);
    }
  }

  // Process each line in tasks.md
  const lines = tasksText.split('\n');
  let changed = 0, skipped = 0, verified = 0, needsCheck = 0;
  const report = [];

  for (let i = 0; i < lines.length; i++) {
    const line = lines[i];
    const taskMatch = line.match(/^(\s*[-*]\s*)\[([ xX])\](.*)$/);
    if (!taskMatch) continue;

    const [, prefix, check, rest] = taskMatch;
    const alreadyChecked = check !== ' ';
    const markers = extractBehaviorMarkers(rest);

    if (alreadyChecked) {
      skipped++;
      continue;
    }

    let shouldCheck = false;
    let reason = '';

    // Strategy 1: behavior markers — check if all marked behaviors are DONE
    if (markers.length > 0) {
      const allDone = markers.every((m) => doneBehaviors.has(m));
      const anyDropped = markers.some((m) => droppedBehaviors.has(m));

      if (allDone) {
        shouldCheck = true;
        reason = `behaviors [${markers.join(', ')}] all DONE`;
      } else if (anyDropped && dropMark === 'checked') {
        shouldCheck = true;
        reason = `behaviors [${markers.join(', ')}] DROPPED (drop-mark=checked)`;
      }
    }

    // Strategy 2: no behavior markers — check file existence
    if (!shouldCheck && markers.length === 0) {
      const paths = extractFilePaths(rest);
      if (paths.length > 0) {
        const allExist = paths.every((p) => fs.existsSync(path.join(ROOT, p)));
        if (allExist) {
          shouldCheck = true;
          reason = `files exist: ${paths.join(', ')}`;
        } else {
          const missing = paths.filter((p) => !fs.existsSync(path.join(ROOT, p)));
          needsCheck++;
          report.push(`  ⚠ T${String(i).padStart(3, '0')} needs check: missing ${missing.join(', ')}`);
        }
      } else {
        // No paths to verify — can't auto-check
        needsCheck++;
      }
    }

    if (shouldCheck) {
      lines[i] = `${prefix}[x]${rest}`;
      changed++;
      verified++;
      report.push(`  ✓ ${rest.trim().slice(0, 70)} — ${reason}`);
    }
  }

  // Write back if changed
  if (changed > 0 && !dryRun) {
    fs.writeFileSync(path.join(ROOT, tasksPath), lines.join('\n'));
  }

  return { spec: specDir, changed, skipped, verified, needsCheck, report, doneBehaviors: doneBehaviors.size, droppedBehaviors: droppedBehaviors.size };
}

function reconcileView(targets, opts) {
  const lines = ['# Spec Stats — Reconcile', ''];
  const dryRun = opts.dryRun;
  if (dryRun) lines.push('_Dry run — no files modified._');
  lines.push('');

  let totalChanged = 0, totalSkipped = 0, totalNeedsCheck = 0;

  for (const t of targets) {
    const specDir = t;
    const specName = path.basename(t);
    const result = reconcileSpec(specDir, {}, opts);

    if (result.error) {
      lines.push(`- **${specName}**: ${result.error}`);
      continue;
    }

    lines.push(`- **${specName}**: ${result.changed} checked, ${result.skipped} already done, ${result.needsCheck} need manual check`);
    if (result.report && result.report.length > 0) {
      lines.push(...result.report);
    }
    totalChanged += result.changed;
    totalSkipped += result.skipped;
    totalNeedsCheck += result.needsCheck;
  }

  lines.push('');
  lines.push(`**Total**: ${totalChanged} tasks reconciled, ${totalSkipped} already correct, ${totalNeedsCheck} need manual check`);

  if (dryRun) {
    lines.push('');
    lines.push('_Run without --dry-run to apply changes._');
  }

  return lines.join('\n');
}

// ---------------------------------------------------------------------------
// Runs view (execute verified suite per spec)
// ---------------------------------------------------------------------------

function loadTddProfile() {
  const p = path.join(ROOT, '.specify', 'memory', 'tdd-profile.md');
  if (!fs.existsSync(p)) return null;
  const text = fs.readFileSync(p, 'utf8');
  const m = text.match(/full suite[:\s]+`?([^\n`]+)`?/i) || text.match(/suite[:\s]+`?([^\n`]+)`?/i);
  return m ? m[1].trim() : null;
}

function runsView(targets, dryRun) {
  const suite = loadTddProfile();
  if (!suite) {
    return 'No TDD profile (.specify/memory/tdd-profile.md). Run /speckit.tdd.setup first.';
  }
  const lines = ['# Spec Stats — Runs', ''];
  if (!targets || !targets.length) { lines.push('_No specs selected and no active feature set._'); return lines.join('\n'); }

  const history = [];
  for (const t of targets) {
    lines.push(`- **${t}**: \`${suite}\``);
    if (dryRun) { lines.push('  - (dry run, not executed)'); continue; }
    const start = Date.now();
    let status = 'pass', tail = '';
    try {
      tail = execFileSync('sh', ['-c', suite], { cwd: path.join(ROOT, t), encoding: 'utf8', stdio: ['ignore', 'pipe', 'pipe'] });
    } catch (e) {
      status = 'fail';
      tail = (e.stdout || '') + (e.stderr || '');
    }
    const ms = Date.now() - start;
    history.push({ spec: t, status, ms, tail: tail.split('\n').slice(-5).join('\n') });
    lines.push(`  - ${status} in ${ms}ms`);
  }

  // record to runs.json
  try {
    const rp = path.join(ROOT, '.specify', 'stats', 'runs.json');
    fs.mkdirSync(path.dirname(rp), { recursive: true });
    let arr = [];
    if (fs.existsSync(rp)) arr = JSON.parse(fs.readFileSync(rp, 'utf8'));
    arr.push(...history.map((h) => ({ ...h, at: new Date().toISOString() })));
    const limit = loadConfig().runs_history_limit || 50;
    arr = arr.slice(-limit);
    fs.writeFileSync(rp, JSON.stringify(arr, null, 2));
  } catch { /* ignore */ }
  return lines.join('\n');
}

// ---------------------------------------------------------------------------
// Output helpers
// ---------------------------------------------------------------------------

function writeOut(content, outPath) {
  if (outPath) {
    const abs = path.isAbsolute(outPath) ? outPath : path.join(ROOT, outPath);
    fs.mkdirSync(path.dirname(abs), { recursive: true });
    fs.writeFileSync(abs, content);
    console.log(`Wrote ${abs}`);
  } else {
    console.log(content);
  }
}

// ---------------------------------------------------------------------------
// CLI
// ---------------------------------------------------------------------------

function parseArgs(argv) {
  const o = { _: [] };
  for (let i = 0; i < argv.length; i++) {
    const a = argv[i];
    if (a.startsWith('--')) {
      const k = a.slice(2);
      const n = argv[i + 1];
      if (n !== undefined && !n.startsWith('--')) { o[k] = n; i++; }
      else o[k] = true;
    } else o._.push(a);
  }
  return o;
}

function main() {
  const args = parseArgs(process.argv.slice(2));
  const cmd = args._.shift() || 'report';
  const cfg = loadConfig();

  if (cmd === 'scan') {
    const data = scan(cfg);
    const json = JSON.stringify(data, null, 2);
    if (args.json) console.log(json);
    else writeOut(json, args.out || path.join(cfg.output_path.replace(/SPEC-STATS\.md$/, 'stats.json')));
    return;
  }

  if (cmd === 'render') {
    const jsonPath = args.in || path.join(ROOT, cfg.output_path.replace(/SPEC-STATS\.md$/, 'stats.json'));
    const data = JSON.parse(fs.readFileSync(jsonPath, 'utf8'));
    writeOut(renderMarkdown(data, cfg), args.out || path.join(ROOT, cfg.output_path));
    return;
  }

  if (cmd === 'open') {
    const data = scan(cfg);
    writeOut(openView(data, cfg), args.out);
    return;
  }

  if (cmd === 'not-green') {
    const data = scan(cfg);
    writeOut(notGreenView(data, cfg), args.out);
    return;
  }

  if (cmd === 'reconcile') {
    let targets;
    if (args.all) {
      targets = listSpecDirs(cfg).map((s) => path.join(cfg.specs_dir, s.dir));
    } else if (args._.length) {
      targets = args._.map((t) => t.startsWith(cfg.specs_dir) ? t : path.join(cfg.specs_dir, t));
    } else if (exists(path.join('.specify', 'feature.json'))) {
      targets = [JSON.parse(read(path.join('.specify', 'feature.json'))).feature_directory];
    } else {
      targets = listSpecDirs(cfg).map((s) => path.join(cfg.specs_dir, s.dir));
    }
    const out = reconcileView(targets, { dryRun: !!args['dry-run'], dropMark: args['drop-mark'] || 'unchecked' });
    writeOut(out, args.out);
    return;
  }

  if (cmd === 'runs') {
    let targets;
    if (args.all) {
      targets = listSpecDirs(cfg).map((s) => path.join(cfg.specs_dir, s.dir));
    } else if (args._.length) {
      targets = args._.map((t) => t.startsWith(cfg.specs_dir) ? t : path.join(cfg.specs_dir, t));
    } else if (exists(path.join('.specify', 'feature.json'))) {
      targets = [JSON.parse(read(path.join('.specify', 'feature.json'))).feature_directory];
    } else {
      targets = [];
    }
    const out = runsView(targets, !!args['dry-run']);
    writeOut(out, args.out);
    return;
  }

  if (cmd === 'record-run') {
    const rp = path.join(ROOT, '.specify', 'stats', 'runs.json');
    fs.mkdirSync(path.dirname(rp), { recursive: true });
    let arr = fs.existsSync(rp) ? JSON.parse(fs.readFileSync(rp, 'utf8')) : [];
    arr.push({ spec: args.spec, status: args.status, ms: Number(args.ms || 0), tail: args.tail || '', at: new Date().toISOString() });
    arr = arr.slice(-(cfg.runs_history_limit || 50));
    fs.writeFileSync(rp, JSON.stringify(arr, null, 2));
    console.log('Recorded run.');
    return;
  }

  // default: report
  const data = scan(cfg);
  if (args.json) { console.log(JSON.stringify(data, null, 2)); return; }
  writeOut(renderMarkdown(data, cfg), args.out || path.join(ROOT, cfg.output_path));
}

main();
