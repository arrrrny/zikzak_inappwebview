# TDD cycle log: iOS custom-scheme navigation

## Cycle 1

- Red: `ios_custom_scheme_navigation_test.dart` timed out because the native
  URL validator cancelled `weixin://` before `shouldOverrideUrlLoading` ran.
- Green: unknown custom schemes now reach the host navigation delegate; the
  iOS Simulator integration test passes when the host cancels `weixin://`.
- Refactor: explicit dangerous schemes and invalid built-in schemes remain
  blocked before the host callback, while unhandled custom schemes retain the
  conservative default cancellation policy.
