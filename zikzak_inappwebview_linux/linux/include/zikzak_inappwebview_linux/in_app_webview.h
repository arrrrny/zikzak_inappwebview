#ifndef IN_APP_WEBVIEW_H_
#define IN_APP_WEBVIEW_H_

#include <flutter_linux/flutter_linux.h>
#include <gtk/gtk.h>
#include <webkit2/webkit2.h>

G_BEGIN_DECLS

#define IN_APP_WEBVIEW_TYPE (in_app_webview_get_type())
G_DECLARE_FINAL_TYPE(InAppWebView, in_app_webview, IN_APP, WEBVIEW, FlPixelBufferTexture)

InAppWebView* in_app_webview_new(FlPluginRegistrar* registrar, const char* id);
int64_t in_app_webview_get_texture_id(InAppWebView* self);
void in_app_webview_handle_method_call(InAppWebView* self, FlMethodCall* method_call);

G_END_DECLS

#endif
