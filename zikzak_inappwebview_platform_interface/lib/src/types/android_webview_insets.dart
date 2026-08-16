///Window-inset types that an Android WebView can be told to **ignore** when
///laying out web content.
///
///This is the zikzak equivalent of `webview_flutter_android`'s
///`setInsetsForWebContentToIgnore` / `AndroidWebViewInsets`. When an inset type
///is listed in [InAppWebViewSettings.insetsForWebContentToIgnore], the Android
///WebView will no longer pad or shrink its content for that inset, allowing web
///content to render edge-to-edge behind the status bar, navigation bar, IME
///(keyboard), display cutout and/or system-gesture areas.
///
///The native string values mirror the names used by
///`androidx.core.view.WindowInsetsCompat.Type` so they are stable across the
///Dart ↔ Android boundary.
class AndroidWebViewInsets {
  final String _value;
  final String _nativeValue;
  const AndroidWebViewInsets._internal(this._value, this._nativeValue);

  ///Insets for the IME (the on-screen keyboard). Ignoring this lets web
  ///content render behind the keyboard instead of being resized by it.
  static const ime = AndroidWebViewInsets._internal('ime', 'ime');

  ///Insets for the system bars (status bar + navigation bar). Ignoring this
  ///lets web content render behind the status bar and navigation bar — the
  ///primary edge-to-edge / immersive case.
  static const systemBars = AndroidWebViewInsets._internal(
    'systemBars',
    'systemBars',
  );

  ///Insets for system gestures (such as the swipe-from-edge back gesture).
  static const systemGestures = AndroidWebViewInsets._internal(
    'systemGestures',
    'systemGestures',
  );

  ///Insets for mandatory system gestures that the system reserves for itself
  ///and that cannot be overridden by the app.
  static const mandatorySystemGestures = AndroidWebViewInsets._internal(
    'mandatorySystemGestures',
    'mandatorySystemGestures',
  );

  ///Insets for the tappable element area (the region reserved for system
  ///gestures that should remain tappable).
  static const tappableElement = AndroidWebViewInsets._internal(
    'tappableElement',
    'tappableElement',
  );

  ///Insets for the display cutout (notches / punch-holes). Ignoring this lets
  ///web content render behind the cutout.
  static const displayCutout = AndroidWebViewInsets._internal(
    'displayCutout',
    'displayCutout',
  );

  ///Set of all values of [AndroidWebViewInsets].
  static final Set<AndroidWebViewInsets> values = [
    AndroidWebViewInsets.ime,
    AndroidWebViewInsets.systemBars,
    AndroidWebViewInsets.systemGestures,
    AndroidWebViewInsets.mandatorySystemGestures,
    AndroidWebViewInsets.tappableElement,
    AndroidWebViewInsets.displayCutout,
  ].toSet();

  ///Gets a possible [AndroidWebViewInsets] instance from [String] value.
  static AndroidWebViewInsets? fromValue(String? value) {
    if (value != null) {
      try {
        return AndroidWebViewInsets.values.firstWhere(
          (element) => element.toValue() == value,
        );
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  ///Gets a possible [AndroidWebViewInsets] instance from a native value.
  static AndroidWebViewInsets? fromNativeValue(String? value) =>
      fromValue(value);

  ///Gets [String] value.
  String toValue() => _value;

  ///Gets [String] native value.
  String toNativeValue() => _nativeValue;

  @override
  int get hashCode => _value.hashCode;

  @override
  bool operator ==(Object other) =>
      other is AndroidWebViewInsets && other._value == _value;

  @override
  String toString() => _value;
}
