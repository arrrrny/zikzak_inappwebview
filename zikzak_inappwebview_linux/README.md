# zikzak_inappwebview_linux

The Linux implementation of the [zikzak_inappwebview](https://pub.dev/packages/zikzak_inappwebview) plugin, built on [WPE WebKit](https://wpewebkit.org/). Pages are rendered off-screen and shown in Flutter as a texture; input, resize, HiDPI scaling, IME, popups, context menus and cookies are handled by the plugin.

This package is endorsed: use `zikzak_inappwebview` normally and this package is included in Linux builds automatically.

## Requirements

WPE WebKit 2.50 or newer with the headless WPEPlatform backend. The build looks for these `pkg-config` modules and fails configuration with an explanatory message if one is missing:

| module | needed for |
|---|---|
| `wpe-webkit-2.0` (>= 2.50) | WPE WebKit |
| `wpe-platform-2.0` | WPEPlatform |
| `wpe-platform-headless-2.0` | headless (off-screen) WPEPlatform backend |
| `wpe-1.0` | libwpe |

CMake 3.12 or newer is required (non-system WPE prefix support uses `*_LINK_LIBRARIES`).

### Installing WPE WebKit

- **Debian 13, Fedora, Arch Linux:** install the distribution packages (WPE WebKit with its development files, `libwpe` and the WPEPlatform headless backend).
- **Ubuntu 24.04:** WPE WebKit 2.50+ is not packaged; build it from source as below. This is `~/.cache/wpe-build/build.sh` from the development machine, reduced to its steps. Ubuntu 24.04 has no `libbacktrace-dev`, hence `-DUSE_LIBBACKTRACE=OFF`.

Build dependencies:

```bash
sudo apt install build-essential cmake ninja-build meson pkg-config ruby ruby-dev python3 gperf unifdef \
  libglib2.0-dev libsoup-3.0-dev libssl-dev libgnutls28-dev libsecret-1-dev libgcrypt20-dev libtasn1-6-dev \
  libepoxy-dev libegl-dev libgles-dev libcairo2-dev libharfbuzz-dev libfreetype6-dev libfontconfig1-dev \
  libicu-dev libxml2-dev libhyphen-dev libenchant-2-dev libsqlite3-dev libjpeg-dev libpng-dev libwebp-dev \
  libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libgstreamer-plugins-bad1.0-dev \
  gstreamer1.0-plugins-base gstreamer1.0-plugins-good libjxl-dev libavif-dev libwoff-dev liblcms2-dev \
  libatk1.0-dev libatk-bridge2.0-dev libdrm-dev libgbm-dev libxslt1-dev libsystemd-dev bubblewrap \
  xdg-dbus-proxy libseccomp-dev libwayland-dev wayland-protocols libxkbcommon-dev libinput-dev libudev-dev
```

Build and install libwpe and WPE WebKit into a user prefix. `PREFIX` is where they are installed; `WORK` holds the downloads and build trees:

```bash
PREFIX="$HOME/.local/opt/wpe"
WORK="$HOME/.cache/wpe-build"
LIBWPE=1.16.3
WPEWEBKIT=2.54.2
mkdir -p "$WORK" && cd "$WORK"
export PKG_CONFIG_PATH="$PREFIX/lib/pkgconfig:${PKG_CONFIG_PATH:-}"

# libwpe
curl -fLO https://wpewebkit.org/releases/libwpe-$LIBWPE.tar.xz
tar xf libwpe-$LIBWPE.tar.xz
meson setup libwpe-$LIBWPE/build libwpe-$LIBWPE --prefix="$PREFIX" --libdir=lib --buildtype=release
ninja -C libwpe-$LIBWPE/build install

# WPE WebKit (takes a long time and a lot of memory)
curl -fLO https://wpewebkit.org/releases/wpewebkit-$WPEWEBKIT.tar.xz
tar xf wpewebkit-$WPEWEBKIT.tar.xz
cmake -S wpewebkit-$WPEWEBKIT -B wpewebkit-$WPEWEBKIT/build -G Ninja \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX="$PREFIX" \
  -DCMAKE_INSTALL_LIBDIR=lib \
  -DCMAKE_INSTALL_RPATH="$PREFIX/lib" \
  -DPORT=WPE \
  -DENABLE_WPE_PLATFORM=ON \
  -DENABLE_WPE_PLATFORM_HEADLESS=ON \
  -DENABLE_DOCUMENTATION=OFF \
  -DENABLE_INTROSPECTION=OFF \
  -DENABLE_WEBDRIVER=OFF \
  -DENABLE_MINIBROWSER=OFF \
  -DENABLE_SPEECH_SYNTHESIS=OFF \
  -DENABLE_GAMEPAD=OFF \
  -DUSE_LIBBACKTRACE=OFF \
  -DUSE_GSTREAMER_WEBRTC=OFF
ninja -C wpewebkit-$WPEWEBKIT/build
ninja -C wpewebkit-$WPEWEBKIT/build install
```

Before building an app (or this package's example), point `pkg-config` at the prefix:

```bash
export PKG_CONFIG_PATH=$HOME/.local/opt/wpe/lib/pkgconfig
```

When WPE is found in a non-system prefix, the plugin records that prefix's `lib` directory as an rpath. The plugin's `RUNPATH` is `$ORIGIN:<prefix>/lib`, so `flutter run` works without `LD_LIBRARY_PATH`.

WPE is not bundled: `libWPEWebKit-2.0` and `libwpe-1.0` are loaded from the WPE install, and so are its helper processes (`WPEWebProcess`, `WPENetworkProcess`, `WPEGPUProcess`, found at the `libexec` path compiled into WPE WebKit). Shipping WPE with an app is out of scope for this plugin, so a bundle moved to another machine needs WPE installed there at the same location. Do not set `LIBRARY_PATH`, `LDFLAGS` or `LD_LIBRARY_PATH`.

`WPE_BACKEND.md` in this package is upstream's generic WPE install guide, kept as imported. Where it differs from this README (install prefix, log names, bundling), this README takes precedence for zikzak.

Under CMake 4 the example needs `CMAKE_POLICY_VERSION_MINIMUM=3.5` (its googletest 1.11 dependency): `CMAKE_POLICY_VERSION_MINIMUM=3.5 flutter build linux --debug`. If a rebuild fails at the install step, delete `build` and `.dart_tool/flutter_build` first.

## Linux-only methods

These methods exist on `LinuxInAppWebViewController` and not in zikzak's platform interface. Reach them through the controller's platform object:

```dart
final linux = controller.platform as LinuxInAppWebViewController;
await linux.setMuted(muted: true);
```

- Focus and input: `requestFocus({InAppWebViewRect? previouslyFocusedRect})`, `requestPointerLock()`
- Visibility and scale: `isVisible()`, `setVisible({required bool visible})`, `getScreenScale()`, `setScreenScale({required double scale})`, `setTargetRefreshRate({required int rate})`
- Fullscreen: `requestEnterFullscreen()`, `requestExitFullscreen()`
- Audio: `isMuted()`, `setMuted({required bool muted})`, `isPlayingAudio()`
- Session state: `saveState()`, `restoreState(Uint8List state)`
- Process: `terminateWebProcess()`

Notes:

- `requestFocus` has no `FocusDirection` parameter (zikzak has no such type), unlike upstream.
- `pressKey` (a zikzak method): `key` takes DOM key names; `keyCode` (a macOS virtual key code) is ignored on Linux; upper-case letters are sent without a Shift modifier.
- When `onAjaxReadyStateChange` or `onAjaxProgress` is set, the plugin enables native Ajax readyState/progress interception automatically. For `InAppBrowser` it enables them whenever `useShouldInterceptAjaxRequest` is true.

## Logging

Like the iOS and Android packages, the Dart side traces native→Dart method
calls through `PlatformInAppWebViewController.debugLoggingSettings` (on by
default in debug builds, via `developer.log` unless `usePrint` is set).

The native side follows the same switch: every webview, headless webview and
`InAppBrowser` creation sends `debugLoggingSettings.enabled`, and native info
logs (GLib messages prefixed `[zikzak_inappwebview] file(line):`) print only
while it is on. Errors always print, in release builds too. `excludeFilter`,
`maxLogMessageLength` and `usePrint` apply to the Dart-side tracing only.

```dart
// Silence native info logs (and Dart tracing) from the next webview on:
PlatformInAppWebViewController.debugLoggingSettings.enabled = false;
```

A change applies from the next creation call. The few lines logged at plugin
start-up (GPU detection) run before any setting can reach native code, so they
follow the build default: printed in debug builds, not in release builds.

## Known gaps

- `createPdf` returns `null`: WPE has no print-to-PDF API.
- `onShowFileChooser` is not exposed (zikzak's interface lacks it). `<input type="file">` opens the native WPE/GTK file chooser instead of calling the app.
- `URLProtectionSpace` authentication-method strings (Basic, Digest, HTMLForm, Default) and `ClientCertChallenge.isProxy` are lost: zikzak's interface lacks the fields.
- `PermissionRequest`: the native resource types geolocation, notifications, device info and pointer lock arrive as an empty `resources` list (zikzak has no equivalent).
- `WebViewEnvironment` is not supported on Linux: `createPlatformWebViewEnvironment` is not overridden, so it throws the interface's `UnimplementedError`, and `webViewEnvironmentId` is not sent.
- `setCookie`'s `maxAge` is converted in Dart to an absolute `expiresDate` (now + `maxAge` seconds) because native never reads `maxAge`; an explicit `expiresDate` takes precedence.
- 24 controller methods that upstream's interface declares are not exposed because zikzak's interface lacks them (15 more are available as the Linux-only methods above); the list is in spec 017, FR-6.
- Three upstream-only settings use WPE's native defaults because zikzak cannot send them: `allowModalDialogs`, `enable2DCanvasAcceleration`, `enableEncryptedMedia`. See `tool/wire_parity/README.md`, which also lists every other settings key zikzak cannot send.

## Manual testing

The example app (`example/`) has a page for checking behaviour that automated tests cannot see. Build and run it (at 1x and at 2x display scaling):

```bash
cd example
export PKG_CONFIG_PATH=$HOME/.local/opt/wpe/lib/pkgconfig
rm -rf build .dart_tool/flutter_build
CMAKE_POLICY_VERSION_MINIMUM=3.5 flutter build linux --debug
./build/linux/x64/debug/bundle/zikzak_inappwebview_linux_example
```

| # | Check | Expected |
|---|---|---|
| 1 | Click the button, type in the input | count increases; typed text echoes |
| 2 | Dead key / compose (e.g. `´` then `e`) and the desktop IME | composed character appears; preedit visible while composing |
| 3 | Open the `<select>`, pick "three" | popup appears at the element; "selected three" shown |
| 4 | Right-click the textarea | context menu at the pointer; Copy/Paste work |
| 5 | Scroll wheel / touchpad | page scrolls smoothly |
| 6 | Resize the window | size label changes; no stretching |
| 7 | 2x scaling | sharp text; `@2` in the size label |
| 8 | Open the Flutter dialog (layers icon) | dialog drawn over the page |
| 9 | Hover the link / input | pointer / I-beam cursor |
| 10 | Pop the route | no exception in the log |
| 11 | Tab through the page's controls; drag across text | focus moves in order; dragging selects text |
| 12 | Set + read cookie (plus icon) | `zz_check` shown with sameSite Lax |
| 13 | Delete all cookies, then read (sweep icon) | empty |
| 14 | Headless | not exercised by the example app; covered only by the Dart tests (`test/in_app_webview/headless_in_app_webview_test.dart`) |

Rows 12 and 13 use `https://example.com/` through `LinuxCookieManager` and show the result in a SnackBar. The globe icon loads example.com in the webview and the eye icon reads its cookies again.

## Credit

Based on flutter_inappwebview_linux 0.1.0-beta.1 by Lorenzo Pichilli and contributors (Apache-2.0). See `NOTICE`.
