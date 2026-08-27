# Comment to post on the github/spec-kit PR (e.g. hook overrides / modifies_hooks)

Use or shorten as needed.

---

Thanks for the feedback — I agree with the boundary and I’m **closing / withdrawing this PR** in favor of the approach you described.

**Cross-extension configuration:** I won’t ship logic where one extension rewrites another’s hooks or config on install (including `modifies_hooks` targeting the Git extension). That coupling is brittle when the Git extension evolves and it conflicts with **Git becoming opt-in at 1.0.0**.

**Parallel worktrees:** The real issue is that `before_specify → speckit.git.feature` runs `git checkout` / `git checkout -b` on the **shared** primary checkout, which disrupts parallel agents. Worktree-based flows should rely on **`git worktree add -b`** (branch created in the new worktree, primary `HEAD` unchanged) and on **explicit** project config: users who need a stable primary branch can set `enabled: false` on that hook in **`.specify/extensions.yml`**.

**Presets:** Opinionated “worktree-first” command text and ordering should live in a **preset** that overrides only the commands that need to differ — so teams stay in control.

**Spec-kit follow-up:** No spec-kit changes are required from this PR. The operational guidance (*parallel agents*, `.specify/extensions.yml`, presets) lives in the **Worktrees extension** repository README so it ships with the extension.

---
