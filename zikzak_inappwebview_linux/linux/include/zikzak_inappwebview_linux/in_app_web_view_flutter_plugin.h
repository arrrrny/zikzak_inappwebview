#ifndef ZIKZAK_INAPPWEBVIEW_LINUX_IN_APP_WEB_VIEW_FLUTTER_PLUGIN_H_
#define ZIKZAK_INAPPWEBVIEW_LINUX_IN_APP_WEB_VIEW_FLUTTER_PLUGIN_H_

#include <flutter_linux/flutter_linux.h>

#ifdef FLUTTER_PLUGIN_IMPL
#define FLUTTER_PLUGIN_EXPORT __attribute__((visibility("default")))
#else
#define FLUTTER_PLUGIN_EXPORT
#endif

G_BEGIN_DECLS

// Entry point named after pubspec.yaml's `pluginClass: InAppWebViewFlutterPlugin`,
// which Flutter's generated_plugin_registrant.cc calls.
FLUTTER_PLUGIN_EXPORT void in_app_web_view_flutter_plugin_register_with_registrar(
    FlPluginRegistrar* registrar);

G_END_DECLS

#endif  // ZIKZAK_INAPPWEBVIEW_LINUX_IN_APP_WEB_VIEW_FLUTTER_PLUGIN_H_
