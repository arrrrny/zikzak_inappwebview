///Class representing the share state that should be applied to the custom tab.
enum CustomTabsShareState {
  ///Applies the default share settings depending on the browser.
  SHARE_STATE_DEFAULT,

  ///Shows a share option in the tab.
  SHARE_STATE_ON,

  ///Explicitly does not show a share option in the tab.
  SHARE_STATE_OFF,
}
