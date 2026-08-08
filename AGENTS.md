
# Shared terminal (`herdr`)

Long-running or user-visible commands (e.g. `flutter run`, `dart run build_runner build`, `bun run watch:dev`) should run in the **`herdr` terminal workspace** so both the human and agents see the same terminal. The human attaches with `herdr`; agents drive it via the `herdr` CLI or the socket API: `herdr agent list`, `herdr agent prompt <id> <text>`, `herdr agent read <id>`, `herdr agent wait <id> --state blocked`, `herdr pane send-keys <pane> <key...>`. See `~/Developer/herdr` + `herdr --help`.

<!-- SPECKIT START -->
For additional context about technologies to be used, project structure,
shell commands, and other important information, read the current plan
<!-- SPECKIT END -->
