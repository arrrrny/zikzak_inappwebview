/// Profile-isolated browser abstraction for zikzak_inappwebview.
///
/// `zuraffa_browser` layers a multi-profile browser API (Browser / Profile /
/// Page) on top of the zikzak_inappwebview plugin core and adds network-level
/// isolation to session-level isolation: a **global proxy** shared by all
/// profiles plus an optional **per-profile proxy** that overrides it, with a
/// one-off per-page override on top.
///
/// Spec: 279 (https://github.com/arrrrny/zikzak_inappwebview/issues/279)
library;
