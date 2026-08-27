#include "include/zikzak_inappwebview_linux/in_app_webview.h"
#include <cstring>
#include <glib/gstdio.h>

struct _InAppWebView {
  FlPixelBufferTexture parent_instance;
  FlBinaryMessenger *messenger;
  FlTextureRegistrar *texture_registrar;
  char *id;
  FlMethodChannel *channel;
  GtkWidget *web_view;
  int64_t texture_id;

  // Offscreen window hosting the webview so it actually renders.
  // We use GtkOffscreenWindow which provides a proper offscreen rendering
  // context without requiring a visible native window. This is essential
  // for WebKitGTK to render on compositors that don't allocate GL surfaces
  // for offscreen windows (e.g. WSLg/Weston, nested Wayland).
  GtkWidget *offscreen_window;
  // Periodic snapshot timer id (see on_update_timeout).
  guint update_timeout_id;
  // Guards against overlapping draws from the timer.
  gboolean draw_in_flight;

  uint8_t *buffer;
  int32_t width;
  int32_t height;

  // One-shot readiness gate for the headless "run" flow (see
  // in_app_webview_set_first_load_callback). NULL by default — no effect on
  // regular web views.
  InAppWebViewFirstLoadCallback first_load_callback;
  gpointer first_load_callback_data;
};

G_DEFINE_TYPE(InAppWebView, in_app_webview, fl_pixel_buffer_texture_get_type())

static void update_texture(InAppWebView *self);

/**
 * @brief Supplies the current pixel buffer for the Flutter texture.
 *
 * @param texture Texture whose pixel data is requested.
 * @param buffer Receives the RGBA pixel buffer.
 * @param width Receives the buffer width in pixels.
 * @param height Receives the buffer height in pixels.
 * @param error Receives an error if pixel retrieval fails.
 * @return TRUE after supplying the pixel buffer.
 */
static gboolean in_app_webview_copy_pixels(FlPixelBufferTexture *texture,
                                           const uint8_t **buffer,
                                           uint32_t *width, uint32_t *height,
                                           GError **error) {
  InAppWebView *self = IN_APP_WEBVIEW(texture);

  if (self->buffer == nullptr) {
    // Return a 1x1 transparent pixel so the Flutter texture doesn't show
    // a garbage/random color before the first frame is rendered.
    *width = 1;
    *height = 1;
    static uint8_t dummy[4] = {0, 0, 0, 0};
    *buffer = dummy;
    return TRUE;
  }

  *buffer = self->buffer;
  *width = self->width;
  *height = self->height;
  return TRUE;
}

/**
 * @brief Releases resources associated with the in-app web view.
 *
 * Stops scheduled texture updates and releases the offscreen window, web view,
 * communication channel, pixel buffer, and texture identifier before delegating
 * disposal to the parent class.
 *
 * @param object GObject instance being disposed.
 */
static void in_app_webview_dispose(GObject *object) {
  InAppWebView *self = IN_APP_WEBVIEW(object);
  if (self->update_timeout_id != 0) {
    g_source_remove(self->update_timeout_id);
    self->update_timeout_id = 0;
  }
  if (self->offscreen_window) {
    // Destroying the window also destroys the web_view child widget.
    // Null out web_view so we don't double-free it below.
    gtk_widget_destroy(self->offscreen_window);
    // offscreen_window was ref-sunk, so unref after destroy.
    g_object_unref(self->offscreen_window);
    self->offscreen_window = nullptr;
    self->web_view = nullptr;
  }
  if (self->web_view) {
    // Only reached if web_view was NOT inside the offscreen window.
    g_object_unref(self->web_view);
    self->web_view = nullptr;
  }
  if (self->channel) {
    g_object_unref(self->channel);
    self->channel = nullptr;
  }
  if (self->buffer) {
    g_free(self->buffer);
    self->buffer = nullptr;
  }
  if (self->id) {
    g_free(self->id);
    self->id = nullptr;
  }
  G_OBJECT_CLASS(in_app_webview_parent_class)->dispose(object);
}

static void in_app_webview_class_init(InAppWebViewClass *klass) {
  G_OBJECT_CLASS(klass)->dispose = in_app_webview_dispose;
  FL_PIXEL_BUFFER_TEXTURE_CLASS(klass)->copy_pixels =
      in_app_webview_copy_pixels;
}

/**
 * @brief Initializes the web view's rendering state and default dimensions.
 *
 * @param self Web view instance to initialize.
 */
static void in_app_webview_init(InAppWebView *self) {
  self->width = 1280;
  self->height = 720;
  self->buffer = nullptr;
  self->offscreen_window = nullptr;
  self->update_timeout_id = 0;
  self->draw_in_flight = FALSE;
}

/**
 * @brief Refreshes the Flutter texture from the current offscreen render.
 *
 * @param user_data The associated InAppWebView instance.
 * @return G_SOURCE_CONTINUE to keep the periodic callback active.
 */
static gboolean on_update_timeout(gpointer user_data) {
  InAppWebView *self = IN_APP_WEBVIEW(user_data);
  update_texture(self);
  return G_SOURCE_CONTINUE;
}

/**
 * @brief Dispatches a method channel call to an in-app web view.
 *
 * @param channel Method channel receiving the call.
 * @param method_call Method call to handle.
 * @param user_data In-app web view instance that handles the call.
 */
static void in_app_webview_method_call_handler(FlMethodChannel *channel,
                                               FlMethodCall *method_call,
                                               gpointer user_data) {
  in_app_webview_handle_method_call(IN_APP_WEBVIEW(user_data), method_call);
}

/**
 * @brief Converts a cairo ARGB32 surface to straight RGBA and pushes it as the
 *        new Flutter texture frame.
 *
 * WebKit snapshots / gtk_widget_draw produce CAIRO_FORMAT_ARGB32
 * (0xAARRGGBB) in native-endian format. Flutter's pixel buffer texture
 * expects straight (non-premultiplied) RGBA, so this function also
 * unpremultiplies the alpha channel.
 *
 * @param surface The cairo surface to copy from. May be nullptr.
 * @param self The InAppWebView whose buffer and texture should be updated.
 */
static void push_surface_to_texture(cairo_surface_t *surface,
                                    InAppWebView *self) {
  if (surface == nullptr) {
    return;
  }

  // Ensure the surface is flushed so pixel data is up to date.
  cairo_surface_flush(surface);

  int width = cairo_image_surface_get_width(surface);
  int height = cairo_image_surface_get_height(surface);
  unsigned char *data = cairo_image_surface_get_data(surface);

  if (width <= 0 || height <= 0 || data == nullptr) {
    cairo_surface_destroy(surface);
    return;
  }

  if (self->buffer == nullptr || width != self->width ||
      height != self->height) {
    g_free(self->buffer);
    self->width = width;
    self->height = height;
    self->buffer = (uint8_t *)g_malloc0(width * height * 4);
  }

  // WebKit snapshot is CAIRO_FORMAT_ARGB32 (0xAARRGGBB) in native-endian
  // format; memory order is BGRA on little-endian and ARGB on big-endian,
  // but reading it back as a native-endian uint32 always yields the same
  // 0xAARRGGBB value. Flutter's pixel buffer texture expects straight
  // (non-premultiplied) RGBA, so also unpremultiply the alpha channel.
  for (int i = 0; i < width * height; i++) {
    uint32_t pixel = ((uint32_t *)data)[i];

    uint8_t b = (pixel >> 0) & 0xFF;
    uint8_t g = (pixel >> 8) & 0xFF;
    uint8_t r = (pixel >> 16) & 0xFF;
    uint8_t a = (pixel >> 24) & 0xFF;

    // Unpremultiply alpha (rounding division).
    if (a != 0 && a != 255) {
      r = (r * 255 + a / 2) / a;
      g = (g * 255 + a / 2) / a;
      b = (b * 255 + a / 2) / a;
    }

    self->buffer[i * 4] = r;
    self->buffer[i * 4 + 1] = g;
    self->buffer[i * 4 + 2] = b;
    self->buffer[i * 4 + 3] = a;
  }

  cairo_surface_destroy(surface);

  // Notify texture updated
  if (self->texture_registrar != nullptr) {
    fl_texture_registrar_mark_texture_frame_available(self->texture_registrar,
                                                      FL_TEXTURE(self));
  }
}

/**
 * @brief Updates the Flutter texture by directly rendering the webview to a
 *        cairo surface via gtk_widget_draw.
 *
 * This bypasses WebKit's compositor entirely, so it works even when the
 * webview is inside a GtkOffscreenWindow on compositors that don't
 * allocate GL surfaces for offscreen windows (WSLg, nested Wayland, etc.).
 *
 * @param self Web view whose content should be captured.
 */
static void update_texture(InAppWebView *self) {
  if (self->draw_in_flight || self->web_view == nullptr) {
    return;
  }
  self->draw_in_flight = TRUE;

  // Get the webview's allocated size. Fall back to the default if unset.
  GtkAllocation alloc;
  gtk_widget_get_allocation(self->web_view, &alloc);
  int width = alloc.width > 0 ? alloc.width : self->width;
  int height = alloc.height > 0 ? alloc.height : self->height;

  if (width <= 0 || height <= 0) {
    self->draw_in_flight = FALSE;
    return;
  }

  // Create a cairo image surface and force the webview to render into it.
  // gtk_widget_draw works regardless of whether the widget is visible or
  // mapped, as long as it has been realized and has a valid allocation.
  cairo_surface_t *surface =
      cairo_image_surface_create(CAIRO_FORMAT_ARGB32, width, height);
  if (cairo_surface_status(surface) != CAIRO_STATUS_SUCCESS) {
    cairo_surface_destroy(surface);
    self->draw_in_flight = FALSE;
    return;
  }

  cairo_t *cr = cairo_create(surface);
  if (cairo_status(cr) != CAIRO_STATUS_SUCCESS) {
    cairo_destroy(cr);
    cairo_surface_destroy(surface);
    self->draw_in_flight = FALSE;
    return;
  }

  // Paint a white background first so transparent pages don't show
  // uninitialized memory.
  cairo_set_source_rgb(cr, 1.0, 1.0, 1.0);
  cairo_paint(cr);

  // Force the webview to draw itself into our cairo context.
  gtk_widget_draw(self->web_view, cr);

  cairo_destroy(cr);

  push_surface_to_texture(surface, self);

  self->draw_in_flight = FALSE;
}

/**
 * @brief Handles WebKit load state changes and updates the Flutter texture.
 *
 * @param web_view WebKit web view whose load state changed.
 * @param load_event Load event that triggered the callback.
 * @param user_data InAppWebView instance associated with the web view.
 */
static void on_load_changed(WebKitWebView *web_view, WebKitLoadEvent load_event,
                            gpointer user_data) {
  InAppWebView *self = IN_APP_WEBVIEW(user_data);
  if (load_event == WEBKIT_LOAD_STARTED) {
    const gchar *uri = webkit_web_view_get_uri(web_view);
    g_autoptr(FlValue) args = fl_value_new_map();
    fl_value_set_string(args, "url",
                        uri ? fl_value_new_string(uri) : fl_value_new_null());
    fl_method_channel_invoke_method(self->channel, "onLoadStart", args, nullptr,
                                    nullptr, nullptr);
  }
  if (load_event == WEBKIT_LOAD_FINISHED) {
    gtk_widget_queue_draw(self->web_view);
    const gchar *uri = webkit_web_view_get_uri(web_view);
    g_autoptr(FlValue) args = fl_value_new_map();
    fl_value_set_string(args, "url",
                        uri ? fl_value_new_string(uri) : fl_value_new_null());
    fl_method_channel_invoke_method(self->channel, "onLoadStop", args, nullptr,
                                    nullptr, nullptr);
    update_texture(self);

    // One-shot readiness gate: fire and disarm. WEBKIT_LOAD_FINISHED is the
    // terminal load event (WebKitGTK emits it for both success and failure),
    // and its arrival proves the web process handled the load.
    if (self->first_load_callback) {
      InAppWebViewFirstLoadCallback callback = self->first_load_callback;
      gpointer data = self->first_load_callback_data;
      self->first_load_callback = NULL;
      self->first_load_callback_data = NULL;
      callback(self, data);
    }
  }
}

void in_app_webview_set_first_load_callback(InAppWebView *self,
                                            InAppWebViewFirstLoadCallback callback,
                                            gpointer user_data) {
  self->first_load_callback = callback;
  self->first_load_callback_data = user_data;
}

// ---------------- network capture support: JS bridge & events ----------------

// Injected at document start so page scripts can reach Dart handlers via
// window.zikzak_inappwebview.callHandler(name, ...args).
static const char *ZIKZAK_BRIDGE_JS =
    "window.zikzak_inappwebview = window.zikzak_inappwebview || {};\n"
    "window.zikzak_inappwebview.callHandler = function(name) {\n"
    "  var args = Array.prototype.slice.call(arguments, 1);\n"
    "  window.webkit.messageHandlers.zikzakCallHandler.postMessage("
    "JSON.stringify({handlerName: name, args: args}));\n"
    "  return Promise.resolve(null);\n"
    "};";

// Forwards console messages to Dart as onConsoleMessage events.
static const char *ZIKZAK_CONSOLE_JS =
    "(function(){\n"
    "var levels=['log','info','warn','error','debug'];\n"
    "levels.forEach(function(l){\n"
    "  var orig=console[l];\n"
    "  console[l]=function(){\n"
    "    try{\n"
    "      var m=Array.prototype.map.call(arguments,function(a){\n"
    "        if(typeof a==='string')return a;\n"
    "        try{return JSON.stringify(a)}catch(e){return String(a)}\n"
    "      }).join(' ');\n"
    "      window.webkit.messageHandlers.zikzakConsole.postMessage("
    "JSON.stringify({level:l,message:m}));\n"
    "    }catch(e){}\n"
    "    return orig.apply(console,arguments);\n"
    "  };\n"
    "});\n"
    "})();";

static FlValue *jsc_to_flvalue(JSCValue *value) {
  if (value == nullptr || jsc_value_is_null(value) ||
      jsc_value_is_undefined(value)) {
    return fl_value_new_null();
  }
  if (jsc_value_is_boolean(value)) {
    return fl_value_new_bool(jsc_value_to_boolean(value));
  }
  if (jsc_value_is_number(value)) {
    double d = jsc_value_to_double(value);
    int64_t i = (int64_t)d;
    if ((double)i == d && d < 9.0e15 && d > -9.0e15) {
      return fl_value_new_int(i);
    }
    return fl_value_new_float(d);
  }
  if (jsc_value_is_string(value)) {
    g_autofree gchar *str = jsc_value_to_string(value);
    return fl_value_new_string(str);
  }
  if (jsc_value_is_array(value)) {
    FlValue *list = fl_value_new_list();
    g_autoptr(JSCValue) len_v = jsc_value_object_get_property(value, "length");
    int32_t len =
        len_v && jsc_value_is_number(len_v) ? jsc_value_to_int32(len_v) : 0;
    for (int32_t i = 0; i < len; i++) {
      g_autoptr(JSCValue) item =
          jsc_value_object_get_property_at_index(value, i);
      fl_value_append_take(list, jsc_to_flvalue(item));
    }
    return list;
  }
  if (jsc_value_is_object(value)) {
    FlValue *map = fl_value_new_map();
    gchar **keys = jsc_value_object_enumerate_properties(value);
    for (gchar **k = keys; k != nullptr && *k != nullptr; k++) {
      g_autoptr(JSCValue) pv = jsc_value_object_get_property(value, *k);
      fl_value_set_string_take(map, *k, jsc_to_flvalue(pv));
    }
    if (keys != nullptr) {
      g_strfreev(keys);
    }
    return map;
  }
  return fl_value_new_null();
}

static void on_script_message_call_handler(WebKitUserContentManager *manager,
                                           WebKitJavascriptResult *result,
                                           gpointer user_data) {
  InAppWebView *self = IN_APP_WEBVIEW(user_data);
  JSCValue *value = webkit_javascript_result_get_js_value(result);
  if (!value || !jsc_value_is_string(value)) {
    return;
  }
  g_autofree gchar *json_str = jsc_value_to_string(value);
  g_autoptr(JSCValue) parsed =
      jsc_value_new_from_json(jsc_value_get_context(value), json_str);
  if (!parsed || !jsc_value_is_object(parsed)) {
    return;
  }
  g_autoptr(JSCValue) name_v =
      jsc_value_object_get_property(parsed, "handlerName");
  if (!name_v || !jsc_value_is_string(name_v)) {
    return;
  }
  g_autofree gchar *handler_name = jsc_value_to_string(name_v);
  g_autoptr(JSCValue) args_v = jsc_value_object_get_property(parsed, "args");
  g_autoptr(FlValue) payload = fl_value_new_map();
  fl_value_set_string(payload, "handlerName",
                      fl_value_new_string(handler_name));
  fl_value_set_string_take(payload, "args", jsc_to_flvalue(args_v));
  fl_method_channel_invoke_method(self->channel, "onCallJsHandler", payload,
                                  nullptr, nullptr, nullptr);
}

static void on_script_message_console(WebKitUserContentManager *manager,
                                      WebKitJavascriptResult *result,
                                      gpointer user_data) {
  InAppWebView *self = IN_APP_WEBVIEW(user_data);
  JSCValue *value = webkit_javascript_result_get_js_value(result);
  if (!value || !jsc_value_is_string(value)) {
    return;
  }
  g_autofree gchar *json_str = jsc_value_to_string(value);
  g_autoptr(JSCValue) parsed =
      jsc_value_new_from_json(jsc_value_get_context(value), json_str);
  if (!parsed || !jsc_value_is_object(parsed)) {
    return;
  }
  g_autoptr(JSCValue) level_v = jsc_value_object_get_property(parsed, "level");
  g_autoptr(JSCValue) msg_v = jsc_value_object_get_property(parsed, "message");
  if (!msg_v || !jsc_value_is_string(msg_v)) {
    return;
  }
  g_autofree gchar *level = jsc_value_is_string(level_v)
                                ? jsc_value_to_string(level_v)
                                : g_strdup("log");
  g_autofree gchar *message = jsc_value_to_string(msg_v);
  int64_t level_int = 1; // ConsoleMessageLevel.LOG
  if (g_strcmp0(level, "warn") == 0) {
    level_int = 2;
  } else if (g_strcmp0(level, "error") == 0) {
    level_int = 3;
  } else if (g_strcmp0(level, "debug") == 0) {
    level_int = 4;
  }
  g_autoptr(FlValue) payload = fl_value_new_map();
  fl_value_set_string(payload, "message", fl_value_new_string(message));
  fl_value_set_string(payload, "messageLevel", fl_value_new_int(level_int));
  fl_method_channel_invoke_method(self->channel, "onConsoleMessage", payload,
                                  nullptr, nullptr, nullptr);
}

static void on_progress_notify(GObject *object, GParamSpec *pspec,
                               gpointer user_data) {
  InAppWebView *self = IN_APP_WEBVIEW(user_data);
  double p = webkit_web_view_get_estimated_load_progress(
      WEBKIT_WEB_VIEW(self->web_view));
  g_autoptr(FlValue) args = fl_value_new_map();
  fl_value_set_string(args, "progress", fl_value_new_int((int64_t)(p * 100.0)));
  fl_method_channel_invoke_method(self->channel, "onProgressChanged", args,
                                  nullptr, nullptr, nullptr);
}

static void evaluate_javascript_ready_cb(GObject *object, GAsyncResult *result,
                                         gpointer user_data) {
  FlMethodCall *method_call = FL_METHOD_CALL(user_data);
  GError *error = nullptr;
  JSCValue *value = webkit_web_view_evaluate_javascript_finish(
      WEBKIT_WEB_VIEW(object), result, &error);
  if (!value) {
    fl_method_call_respond(method_call,
                           FL_METHOD_RESPONSE(fl_method_error_response_new(
                               "error", error->message, nullptr)),
                           nullptr);
    if (error) {
      g_error_free(error);
    }
  } else {
    fl_method_call_respond(method_call,
                           FL_METHOD_RESPONSE(fl_method_success_response_new(
                               jsc_to_flvalue(value))),
                           nullptr);
    g_object_unref(value);
  }
  g_object_unref(method_call);
}

void in_app_webview_load_initial(InAppWebView *self, FlValue *params) {
  if (params == nullptr || fl_value_get_type(params) != FL_VALUE_TYPE_MAP) {
    return;
  }
  WebKitUserContentManager *ucm =
      webkit_web_view_get_user_content_manager(WEBKIT_WEB_VIEW(self->web_view));
  FlValue *scripts = fl_value_lookup_string(params, "initialUserScripts");
  if (scripts != nullptr && fl_value_get_type(scripts) == FL_VALUE_TYPE_LIST) {
    for (size_t i = 0; i < fl_value_get_length(scripts); i++) {
      FlValue *script = fl_value_get_list_value(scripts, i);
      if (fl_value_get_type(script) != FL_VALUE_TYPE_MAP) {
        continue;
      }
      FlValue *source = fl_value_lookup_string(script, "source");
      FlValue *injection_time = fl_value_lookup_string(script, "injectionTime");
      FlValue *main_only = fl_value_lookup_string(script, "forMainFrameOnly");
      if (source == nullptr ||
          fl_value_get_type(source) != FL_VALUE_TYPE_STRING) {
        continue;
      }
      WebKitUserScriptInjectionTime time =
          WEBKIT_USER_SCRIPT_INJECT_AT_DOCUMENT_START;
      if (injection_time != nullptr &&
          fl_value_get_type(injection_time) == FL_VALUE_TYPE_INT &&
          fl_value_get_int(injection_time) == 1) {
        time = WEBKIT_USER_SCRIPT_INJECT_AT_DOCUMENT_END;
      }
      WebKitUserContentInjectedFrames frames =
          WEBKIT_USER_CONTENT_INJECT_ALL_FRAMES;
      if (main_only != nullptr &&
          fl_value_get_type(main_only) == FL_VALUE_TYPE_BOOL &&
          fl_value_get_bool(main_only)) {
        frames = WEBKIT_USER_CONTENT_INJECT_TOP_FRAME;
      }
      webkit_user_content_manager_add_script(
          ucm, webkit_user_script_new(fl_value_get_string(source), frames, time,
                                      nullptr, nullptr));
    }
  }
  FlValue *url_request = fl_value_lookup_string(params, "initialUrlRequest");
  if (url_request != nullptr &&
      fl_value_get_type(url_request) == FL_VALUE_TYPE_MAP) {
    FlValue *url = fl_value_lookup_string(url_request, "url");
    if (url != nullptr && fl_value_get_type(url) == FL_VALUE_TYPE_STRING) {
      webkit_web_view_load_uri(WEBKIT_WEB_VIEW(self->web_view),
                               fl_value_get_string(url));
      return;
    }
  }
  FlValue *initial_data = fl_value_lookup_string(params, "initialData");
  if (initial_data != nullptr &&
      fl_value_get_type(initial_data) == FL_VALUE_TYPE_MAP) {
    FlValue *data = fl_value_lookup_string(initial_data, "data");
    FlValue *base_url = fl_value_lookup_string(initial_data, "baseUrl");
    if (data != nullptr && fl_value_get_type(data) == FL_VALUE_TYPE_STRING) {
      webkit_web_view_load_html(
          WEBKIT_WEB_VIEW(self->web_view), fl_value_get_string(data),
          (base_url != nullptr &&
           fl_value_get_type(base_url) == FL_VALUE_TYPE_STRING)
              ? fl_value_get_string(base_url)
              : nullptr);
    }
  }
}

/**
 * @brief Creates and initializes an offscreen WebKit web view registered as a Flutter texture.
 *
 * @param messenger Flutter binary messenger used for method-channel communication.
 * @param texture_registrar Flutter texture registrar used to register the web view texture.
 * @param id Identifier used to construct the method-channel name.
 * @return InAppWebView* Newly initialized web view instance.
 */
InAppWebView *in_app_webview_new(FlBinaryMessenger *messenger,
                                 FlTextureRegistrar *texture_registrar,
                                 const char *id) {
  InAppWebView *self =
      IN_APP_WEBVIEW(g_object_new(IN_APP_WEBVIEW_TYPE, nullptr));
  self->messenger = messenger;
  self->texture_registrar = texture_registrar;
  self->id = g_strdup(id);

  g_autofree gchar *channel_name =
      g_strdup_printf("dev.zuzu/zikzak_inappwebview_%s", id);
  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
  self->channel =
      fl_method_channel_new(messenger, channel_name, FL_METHOD_CODEC(codec));
  fl_method_channel_set_method_call_handler(self->channel,
                                            in_app_webview_method_call_handler,
                                            g_object_ref(self), g_object_unref);

  WebKitUserContentManager *ucm = webkit_user_content_manager_new();
  webkit_user_content_manager_register_script_message_handler(
      ucm, "zikzakCallHandler");
  g_signal_connect(ucm, "script-message-received::zikzakCallHandler",
                   G_CALLBACK(on_script_message_call_handler), self);
  webkit_user_content_manager_register_script_message_handler(ucm,
                                                              "zikzakConsole");
  g_signal_connect(ucm, "script-message-received::zikzakConsole",
                   G_CALLBACK(on_script_message_console), self);
  webkit_user_content_manager_add_script(
      ucm, webkit_user_script_new(
               ZIKZAK_BRIDGE_JS, WEBKIT_USER_CONTENT_INJECT_ALL_FRAMES,
               WEBKIT_USER_SCRIPT_INJECT_AT_DOCUMENT_START, nullptr, nullptr));
  webkit_user_content_manager_add_script(
      ucm, webkit_user_script_new(
               ZIKZAK_CONSOLE_JS, WEBKIT_USER_CONTENT_INJECT_ALL_FRAMES,
               WEBKIT_USER_SCRIPT_INJECT_AT_DOCUMENT_START, nullptr, nullptr));
  self->web_view = webkit_web_view_new_with_user_content_manager(ucm);
  g_object_unref(ucm);
  g_object_ref_sink(self->web_view);

  // Force software rendering. This is CRITICAL for offscreen rendering:
  // WebKitGTK's hardware-accelerated path uses DMA-BUF / GL surfaces which
  // are only allocated for visible, native windows. On compositors like
  // WSLg (Weston) or nested Wayland, offscreen windows never get a GL
  // surface, so the compositor never paints and snapshots return empty.
  // Software rendering makes gtk_widget_draw() produce real pixels.
  WebKitSettings *settings =
      webkit_web_view_get_settings(WEBKIT_WEB_VIEW(self->web_view));
  webkit_settings_set_hardware_acceleration_policy(
      settings, WEBKIT_HARDWARE_ACCELERATION_POLICY_NEVER);

  // Create a GtkOffscreenWindow to host the webview. Unlike a real
  // GTK_WINDOW_TOPLEVEL moved off-screen, GtkOffscreenWindow:
  //   1. Never appears on screen (no compositor surface needed)
  //   2. Provides a proper offscreen rendering context for gtk_widget_draw
  //   3. Allocates / realizes child widgets correctly
  // Combined with software rendering above, this lets us capture webview
  // content even on WSLg / headless Wayland where the previous TOPLEVEL +
  // move-off-screen approach produced a blue (empty) texture.
  self->offscreen_window = gtk_offscreen_window_new();
  g_object_ref_sink(self->offscreen_window);
  gtk_window_set_default_size(GTK_WINDOW(self->offscreen_window), 1280, 720);
  gtk_container_add(GTK_CONTAINER(self->offscreen_window), self->web_view);
  gtk_widget_set_size_request(self->web_view, 1280, 720);

  // Realize + show so the widget hierarchy is prepared for rendering.
  // GtkOffscreenWindow doesn't map to the actual display, so show_all()
  // just realizes widgets without putting anything on screen.
  gtk_widget_realize(self->offscreen_window);
  gtk_widget_show_all(self->offscreen_window);

  // Connect load-changed signal
  g_signal_connect(self->web_view, "load-changed", G_CALLBACK(on_load_changed),
                   self);
  g_signal_connect(self->web_view, "notify::estimated-load-progress",
                   G_CALLBACK(on_progress_notify), self);

  // Register texture
  if (self->texture_registrar != nullptr &&
      fl_texture_registrar_register_texture(self->texture_registrar,
                                            FL_TEXTURE(self))) {
    self->texture_id = fl_texture_get_id(FL_TEXTURE(self));
  } else {
    self->texture_id = 0;
  }

  // Start periodic texture refresh (~30fps). WebKit does not notify us when
  // content repaints, so poll gtk_widget_draw to keep the Flutter texture
  // live. This is cheap because software rendering into a cairo image
  // surface is fast and we skip re-entrancy via draw_in_flight.
  self->update_timeout_id = g_timeout_add(33, on_update_timeout, self);

  return self;
}

int64_t in_app_webview_get_texture_id(InAppWebView *self) {
  return self->texture_id;
}

typedef struct {
  FlMethodCall *method_call;
  char *filename;
} PrintContext;

static void print_finished_callback(WebKitPrintOperation *operation,
                                    gpointer user_data) {
  PrintContext *context = (PrintContext *)user_data;
  FlMethodCall *method_call = context->method_call;
  char *filename = context->filename;

  GError *error = nullptr;
  gchar *contents = nullptr;
  gsize length = 0;

  if (g_file_get_contents(filename, &contents, &length, &error)) {
    FlValue *result =
        fl_value_new_uint8_list((const uint8_t *)contents, length);
    fl_method_call_respond(
        method_call, FL_METHOD_RESPONSE(fl_method_success_response_new(result)),
        nullptr);
    g_free(contents);
  } else {
    fl_method_call_respond(method_call,
                           FL_METHOD_RESPONSE(fl_method_error_response_new(
                               "error", error->message, nullptr)),
                           nullptr);
    g_error_free(error);
  }

  g_unlink(filename);
  g_free(filename);
  g_free(context);
  g_object_unref(method_call);
}

static void print_failed_callback(WebKitPrintOperation *operation,
                                  GError *error, gpointer user_data) {
  PrintContext *context = (PrintContext *)user_data;
  FlMethodCall *method_call = context->method_call;
  char *filename = context->filename;

  fl_method_call_respond(method_call,
                         FL_METHOD_RESPONSE(fl_method_error_response_new(
                             "error", error->message, nullptr)),
                         nullptr);

  g_unlink(filename);
  g_free(filename);
  g_free(context);
  g_object_unref(method_call);
}

/**
 * @brief Handles a method-channel request for the web view.
 *
 * Dispatches navigation, loading, JavaScript, content retrieval, screenshot,
 * PDF generation, developer tools, and state queries, responding with the
 * operation result or an error when the request is invalid or unsupported.
 *
 * @param self The web view instance receiving the request.
 * @param method_call The method-channel call to process and respond.
 */
void in_app_webview_handle_method_call(InAppWebView *self,
                                       FlMethodCall *method_call) {
  const gchar *method = fl_method_call_get_name(method_call);
  FlValue *args = fl_method_call_get_args(method_call);

  if (strcmp(method, "evaluateJavascript") == 0) {
    const gchar *source = nullptr;
    if (fl_value_get_type(args) == FL_VALUE_TYPE_MAP) {
      FlValue *source_val = fl_value_lookup_string(args, "source");
      if (source_val != nullptr &&
          fl_value_get_type(source_val) == FL_VALUE_TYPE_STRING) {
        source = fl_value_get_string(source_val);
      }
    }
    if (source == nullptr) {
      fl_method_call_respond(method_call,
                             FL_METHOD_RESPONSE(fl_method_error_response_new(
                                 "error", "Missing source", nullptr)),
                             nullptr);
      return;
    }
    webkit_web_view_evaluate_javascript(
        WEBKIT_WEB_VIEW(self->web_view), source, -1, nullptr, nullptr, nullptr,
        evaluate_javascript_ready_cb, g_object_ref(method_call));
    return;
  } else if (strcmp(method, "loadData") == 0) {
    const gchar *data = nullptr;
    const gchar *base_url = nullptr;
    if (fl_value_get_type(args) == FL_VALUE_TYPE_MAP) {
      FlValue *data_val = fl_value_lookup_string(args, "data");
      FlValue *base_url_val = fl_value_lookup_string(args, "baseUrl");
      if (data_val != nullptr &&
          fl_value_get_type(data_val) == FL_VALUE_TYPE_STRING) {
        data = fl_value_get_string(data_val);
      }
      if (base_url_val != nullptr &&
          fl_value_get_type(base_url_val) == FL_VALUE_TYPE_STRING) {
        base_url = fl_value_get_string(base_url_val);
      }
    }
    if (data == nullptr) {
      fl_method_call_respond(method_call,
                             FL_METHOD_RESPONSE(fl_method_error_response_new(
                                 "error", "Missing data", nullptr)),
                             nullptr);
      return;
    }
    webkit_web_view_load_html(WEBKIT_WEB_VIEW(self->web_view), data, base_url);
    fl_method_call_respond(method_call,
                           FL_METHOD_RESPONSE(fl_method_success_response_new(
                               fl_value_new_bool(true))),
                           nullptr);
    return;
  } else if (strcmp(method, "getTitle") == 0) {
    const gchar *title =
        webkit_web_view_get_title(WEBKIT_WEB_VIEW(self->web_view));
    g_autoptr(FlValue) result =
        title ? fl_value_new_string(title) : fl_value_new_null();
    fl_method_call_respond(
        method_call, FL_METHOD_RESPONSE(fl_method_success_response_new(result)),
        nullptr);
    return;
  } else if (strcmp(method, "getProgress") == 0) {
    double p = webkit_web_view_get_estimated_load_progress(
        WEBKIT_WEB_VIEW(self->web_view));
    fl_method_call_respond(method_call,
                           FL_METHOD_RESPONSE(fl_method_success_response_new(
                               fl_value_new_int((int64_t)(p * 100.0)))),
                           nullptr);
    return;
  } else if (strcmp(method, "isLoading") == 0) {
    fl_method_call_respond(
        method_call,
        FL_METHOD_RESPONSE(fl_method_success_response_new(fl_value_new_bool(
            webkit_web_view_is_loading(WEBKIT_WEB_VIEW(self->web_view))))),
        nullptr);
    return;
  } else if (strcmp(method, "reload") == 0) {
    webkit_web_view_reload(WEBKIT_WEB_VIEW(self->web_view));
    fl_method_call_respond(method_call,
                           FL_METHOD_RESPONSE(fl_method_success_response_new(
                               fl_value_new_bool(true))),
                           nullptr);
    return;
  } else if (strcmp(method, "goBack") == 0) {
    webkit_web_view_go_back(WEBKIT_WEB_VIEW(self->web_view));
    fl_method_call_respond(method_call,
                           FL_METHOD_RESPONSE(fl_method_success_response_new(
                               fl_value_new_bool(true))),
                           nullptr);
    return;
  } else if (strcmp(method, "goForward") == 0) {
    webkit_web_view_go_forward(WEBKIT_WEB_VIEW(self->web_view));
    fl_method_call_respond(method_call,
                           FL_METHOD_RESPONSE(fl_method_success_response_new(
                               fl_value_new_bool(true))),
                           nullptr);
    return;
  } else if (strcmp(method, "canGoBack") == 0) {
    fl_method_call_respond(
        method_call,
        FL_METHOD_RESPONSE(fl_method_success_response_new(fl_value_new_bool(
            webkit_web_view_can_go_back(WEBKIT_WEB_VIEW(self->web_view))))),
        nullptr);
    return;
  } else if (strcmp(method, "canGoForward") == 0) {
    fl_method_call_respond(
        method_call,
        FL_METHOD_RESPONSE(fl_method_success_response_new(fl_value_new_bool(
            webkit_web_view_can_go_forward(WEBKIT_WEB_VIEW(self->web_view))))),
        nullptr);
    return;
  } else if (strcmp(method, "stopLoading") == 0) {
    webkit_web_view_stop_loading(WEBKIT_WEB_VIEW(self->web_view));
    fl_method_call_respond(method_call,
                           FL_METHOD_RESPONSE(fl_method_success_response_new(
                               fl_value_new_bool(true))),
                           nullptr);
    return;
  } else if (strcmp(method, "addJavaScriptHandler") == 0 ||
             strcmp(method, "removeJavaScriptHandler") == 0) {
    // The script message bridge forwards every callHandler message; the
    // Dart side keeps the handler registry and dispatches.
    fl_method_call_respond(method_call,
                           FL_METHOD_RESPONSE(fl_method_success_response_new(
                               fl_value_new_bool(true))),
                           nullptr);
    return;
  } else if (strcmp(method, "getUrl") == 0) {
    const gchar *uri = webkit_web_view_get_uri(WEBKIT_WEB_VIEW(self->web_view));
    g_autoptr(FlValue) result =
        uri ? fl_value_new_string(uri) : fl_value_new_null();
    fl_method_call_respond(
        method_call, FL_METHOD_RESPONSE(fl_method_success_response_new(result)),
        nullptr);
    return;
  } else if (strcmp(method, "getHtml") == 0) {
    webkit_web_view_evaluate_javascript(
        WEBKIT_WEB_VIEW(self->web_view), "document.documentElement.outerHTML",
        -1, nullptr, nullptr, nullptr,
        [](GObject *object, GAsyncResult *result, gpointer user_data) {
          FlMethodCall *method_call = FL_METHOD_CALL(user_data);
          GError *error = nullptr;
          JSCValue *value = webkit_web_view_evaluate_javascript_finish(
              WEBKIT_WEB_VIEW(object), result, &error);

          if (!value) {
            fl_method_call_respond(
                method_call,
                FL_METHOD_RESPONSE(fl_method_error_response_new(
                    "error", error->message, nullptr)),
                nullptr);
            g_error_free(error);
          } else {
            if (jsc_value_is_string(value)) {
              g_autofree gchar *str_value = jsc_value_to_string(value);
              fl_method_call_respond(
                  method_call,
                  FL_METHOD_RESPONSE(fl_method_success_response_new(
                      fl_value_new_string(str_value))),
                  nullptr);
            } else {
              fl_method_call_respond(
                  method_call,
                  FL_METHOD_RESPONSE(
                      fl_method_success_response_new(fl_value_new_null())),
                  nullptr);
            }
            g_object_unref(value);
          }
          g_object_unref(method_call);
        },
        g_object_ref(method_call));
    return;
  } else if (strcmp(method, "loadUrl") == 0) {
    if (fl_value_get_type(args) == FL_VALUE_TYPE_MAP) {
      FlValue *urlRequest = fl_value_lookup_string(args, "urlRequest");
      if (urlRequest && fl_value_get_type(urlRequest) == FL_VALUE_TYPE_MAP) {
        FlValue *urlVal = fl_value_lookup_string(urlRequest, "url");
        if (urlVal && fl_value_get_type(urlVal) == FL_VALUE_TYPE_STRING) {
          const char *url = fl_value_get_string(urlVal);
          webkit_web_view_load_uri(WEBKIT_WEB_VIEW(self->web_view), url);
          fl_method_call_respond(
              method_call,
              FL_METHOD_RESPONSE(
                  fl_method_success_response_new(fl_value_new_bool(true))),
              nullptr);
          return;
        }
      }
    }
    fl_method_call_respond(method_call,
                           FL_METHOD_RESPONSE(fl_method_error_response_new(
                               "error", "Invalid arguments", nullptr)),
                           nullptr);
    return;
  } else if (strcmp(method, "createPdf") == 0) {
    WebKitPrintOperation *operation =
        webkit_print_operation_new(WEBKIT_WEB_VIEW(self->web_view));

    GtkPrintSettings *settings = gtk_print_settings_new();

    gchar *filename = g_strdup_printf(
        "/tmp/zikzak_inappwebview_print_%p_%ld.pdf", self, g_get_real_time());
    gchar *uri = g_strdup_printf("file://%s", filename);

    gtk_print_settings_set(settings, GTK_PRINT_SETTINGS_OUTPUT_URI, uri);
    gtk_print_settings_set(settings, GTK_PRINT_SETTINGS_OUTPUT_FILE_FORMAT,
                           "pdf");

    webkit_print_operation_set_print_settings(operation, settings);

    PrintContext *context = g_new(PrintContext, 1);
    context->method_call = method_call;
    g_object_ref(context->method_call);
    context->filename = filename;

    g_signal_connect(operation, "finished", G_CALLBACK(print_finished_callback),
                     context);
    g_signal_connect(operation, "failed", G_CALLBACK(print_failed_callback),
                     context);

    webkit_print_operation_print(operation);

    g_object_unref(settings);
    g_free(uri);
    return;
  } else if (strcmp(method, "takeScreenshot") == 0) {
    // Capture the current webview content using gtk_widget_draw, which
    // works offscreen (unlike webkit_web_view_get_snapshot on some
    // compositors). Encode the result as PNG and return to Dart.
    GtkAllocation alloc;
    gtk_widget_get_allocation(self->web_view, &alloc);
    int width = alloc.width > 0 ? alloc.width : self->width;
    int height = alloc.height > 0 ? alloc.height : self->height;

    if (width <= 0 || height <= 0) {
      fl_method_call_respond(
          method_call,
          FL_METHOD_RESPONSE(
              fl_method_success_response_new(fl_value_new_null())),
          nullptr);
      return;
    }

    cairo_surface_t *surface =
        cairo_image_surface_create(CAIRO_FORMAT_ARGB32, width, height);
    cairo_t *cr = cairo_create(surface);
    cairo_set_source_rgb(cr, 1.0, 1.0, 1.0);
    cairo_paint(cr);
    gtk_widget_draw(self->web_view, cr);
    cairo_destroy(cr);

    GdkPixbuf *pixbuf = gdk_pixbuf_get_from_surface(surface, 0, 0, width, height);
    cairo_surface_destroy(surface);

    if (pixbuf == nullptr) {
      fl_method_call_respond(
          method_call,
          FL_METHOD_RESPONSE(
              fl_method_success_response_new(fl_value_new_null())),
          nullptr);
      return;
    }

    gchar *buffer = nullptr;
    gsize buffer_size = 0;
    gboolean saved = gdk_pixbuf_save_to_buffer(pixbuf, &buffer, &buffer_size,
                                                "png", nullptr, nullptr);
    g_object_unref(pixbuf);

    if (saved && buffer && buffer_size > 0) {
      g_autoptr(FlValue) fl_data =
          fl_value_new_uint8_list((const uint8_t *)buffer, buffer_size);
      fl_method_call_respond(
          method_call,
          FL_METHOD_RESPONSE(fl_method_success_response_new(fl_data)),
          nullptr);
      g_free(buffer);
    } else {
      fl_method_call_respond(
          method_call,
          FL_METHOD_RESPONSE(
              fl_method_success_response_new(fl_value_new_null())),
          nullptr);
    }
    return;
  } else if (strcmp(method, "openDevTools") == 0) {
    // The WebKit inspector is a no-op unless developer extras are enabled.
    // Enable lazily here so the setting stays off for ordinary webviews.
    WebKitSettings *settings =
        webkit_web_view_get_settings(WEBKIT_WEB_VIEW(self->web_view));
    webkit_settings_set_enable_developer_extras(settings, TRUE);
    WebKitWebInspector *inspector =
        webkit_web_view_get_inspector(WEBKIT_WEB_VIEW(self->web_view));
    webkit_web_inspector_show(inspector);
    fl_method_call_respond(method_call,
                           FL_METHOD_RESPONSE(fl_method_success_response_new(
                               fl_value_new_bool(true))),
                           nullptr);
    return;
  } else {
    fl_method_call_respond(
        method_call,
        FL_METHOD_RESPONSE(fl_method_not_implemented_response_new()), nullptr);
  }
}
