#ifndef FLUTTER_PLUGIN_IN_APP_WEB_VIEW_FLUTTER_PLUGIN_H_
#define FLUTTER_PLUGIN_IN_APP_WEB_VIEW_FLUTTER_PLUGIN_H_

#include <flutter_linux/flutter_linux.h>

#ifndef FLUTTER_PLUGIN_EXPORT
#define FLUTTER_PLUGIN_EXPORT
#endif

#ifdef __cplusplus
extern "C" {
#endif

FLUTTER_PLUGIN_EXPORT void
in_app_web_view_flutter_plugin_register_with_registrar(
    FlPluginRegistrar *registrar);

#ifdef __cplusplus
}
#endif

#endif // FLUTTER_PLUGIN_IN_APP_WEB_VIEW_FLUTTER_PLUGIN_H_
