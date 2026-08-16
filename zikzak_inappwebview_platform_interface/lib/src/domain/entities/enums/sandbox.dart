

///Class that describes what to allow in the iframe.
enum Sandbox {
  _ALL,
  _NONE,
  ///Allow all.
  ALLOW_ALL,
  ///Allow none.
  ALLOW_NONE,
  ///Allows for downloads to occur with a gesture from the user.
  ALLOW_DOWNLOADS,
  ///Allows the resource to submit forms. If this keyword is not used, form submission is blocked.
  ALLOW_FORMS,
  ///Lets the resource open modal windows.
  ALLOW_MODALS,
  ///Lets the resource lock the screen orientation.
  ALLOW_ORIENTATION_LOCK,
  ///Lets the resource use the Pointer Lock API.
  ALLOW_POINTER_LOCK,
  ///Allows popups (such as `window.open()`, `target="_blank"`, or `showModalDialog()`).
  ///If this keyword is not used, the popup will silently fail to open.
  ALLOW_POPUPS,
  ///Lets the sandboxed document open new windows without those windows inheriting the sandboxing.
  ///For example, this can safely sandbox an advertisement without forcing the same restrictions upon the page the ad links to.
  ALLOW_POPUPS_TO_ESCAPE_SANDBOX,
  ///Lets the resource start a presentation session.
  ALLOW_PRESENTATION,
  ///If this token is not used, the resource is treated as being from a special origin that always fails the
  ///same-origin policy (potentially preventing access to data storage/cookies and some JavaScript APIs).
  ALLOW_SAME_ORIGIN,
  ///Lets the resource run scripts (but not create popup windows).
  ALLOW_SCRIPTS,
  ///Lets the resource navigate the top-level browsing context (the one named `_top`).
  ALLOW_TOP_NAVIGATION,
  ///Lets the resource navigate the top-level browsing context, but only if initiated by a user gesture.
  ALLOW_TOP_NAVIGATION_BY_USER_ACTIVATION,
}


///Sandbox wire values are strings ('null' / '' / 'allow-...') — lookup by value.
const _sandboxWire = ['null', '', 'allow-all', 'allow-none', 'allow-downloads', 'allow-forms', 'allow-modals', 'allow-orientation-lock', 'allow-pointer-lock', 'allow-popups', 'allow-popups-to-escape-sandbox', 'allow-presentation', 'allow-same-origin', 'allow-scripts', 'allow-top-navigation', 'allow-top-navigation-by-user-activation'];

Sandbox? sandboxFromWire(Object? value) {
  if (value is! String) return null;
  final index = _sandboxWire.indexOf(value);
  return index >= 0 ? Sandbox.values[index] : null;
}

Object? sandboxToWire(Sandbox? value) =>
    value == null ? null : _sandboxWire[value.index];
