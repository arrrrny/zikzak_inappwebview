#ifndef IN_APP_WEBVIEW_H_
#define IN_APP_WEBVIEW_H_

#include <flutter_linux/flutter_linux.h>
#include <gtk/gtk.h>
#include <webkit2/webkit2.h>

G_BEGIN_DECLS

#define IN_APP_WEBVIEW_TYPE (in_app_webview_get_type())
G_DECLARE_FINAL_TYPE(InAppWebView, in_app_webview, IN_APP, WEBVIEW, FlPixelBufferTexture)

InAppWebView* in_app_webview_new(FlBinaryMessenger* messenger, FlTextureRegistrar* texture_registrar, const char* id);

// Registers initial user scripts and loads the initial URL/data from
// the "params" argument map of the create/run channel calls.
void in_app_webview_load_initial(InAppWebView* self, FlValue* params);

// Registers initial user scripts and loads the initial URL/data from
// the "params" argument map of the create/run channel calls.
void in_app_webview_load_initial(InAppWebView* self, FlValue* params);
int64_t in_app_webview_get_texture_id(InAppWebView* self);
void in_app_webview_handle_method_call(InAppWebView* self, FlMethodCall* method_call);

G_END_DECLS

#endif
