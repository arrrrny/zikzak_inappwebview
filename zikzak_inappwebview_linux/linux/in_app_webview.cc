#include "include/zikzak_inappwebview_linux/in_app_webview.h"
#include <cstring>
#include <glib/gstdio.h>
#include <iostream>

struct _InAppWebView {
  FlPixelBufferTexture parent_instance;
  FlBinaryMessenger *messenger;
  FlTextureRegistrar *texture_registrar;
  char *id;
  FlMethodChannel *channel;
  GtkWidget *web_view;
  int64_t texture_id;

  uint8_t *buffer;
  int32_t width;
  int32_t height;
};

G_DEFINE_TYPE(InAppWebView, in_app_webview, fl_pixel_buffer_texture_get_type())

static gboolean in_app_webview_copy_pixels(FlPixelBufferTexture *texture,
                                           const uint8_t **buffer,
                                           uint32_t *width, uint32_t *height,
                                           GError **error) {
  InAppWebView *self = IN_APP_WEBVIEW(texture);

  if (self->buffer == nullptr) {
    *width = 1;
    *height = 1;
    static uint8_t dummy[4] = {255, 0, 0, 255};
    *buffer = dummy;
    return TRUE;
  }

  *buffer = self->buffer;
  *width = self->width;
  *height = self->height;
  return TRUE;
}

static void in_app_webview_dispose(GObject *object) {
  InAppWebView *self = IN_APP_WEBVIEW(object);
  if (self->web_view) {
    // gtk_widget_destroy(self->web_view); // WebKitWebView is a GtkWidget
    // But since we own the ref via g_object_ref_sink, we should unref it.
    // If it was added to a container, the container would own it.
    // Here we don't add it to a container, so we own it.
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

static void in_app_webview_init(InAppWebView *self) {
  self->width = 1280;
  self->height = 720;
  self->buffer = (uint8_t *)g_malloc0(self->width * self->height * 4);

  // Fill with blue for initial state
  for (int i = 0; i < self->width * self->height; i++) {
    self->buffer[i * 4] = 0;       // R
    self->buffer[i * 4 + 1] = 0;   // G
    self->buffer[i * 4 + 2] = 255; // B
    self->buffer[i * 4 + 3] = 255; // A
  }
}

static void in_app_webview_method_call_handler(FlMethodChannel *channel,
                                               FlMethodCall *method_call,
                                               gpointer user_data) {
  in_app_webview_handle_method_call(IN_APP_WEBVIEW(user_data), method_call);
}

// Helper to update texture from snapshot
static void on_snapshot_ready(GObject *source_object, GAsyncResult *res,
                              gpointer user_data) {
  InAppWebView *self = IN_APP_WEBVIEW(user_data);
  GError *error = nullptr;
  WebKitWebView *web_view = WEBKIT_WEB_VIEW(source_object);
  cairo_surface_t *surface =
      webkit_web_view_get_snapshot_finish(web_view, res, &error);

  if (surface) {
    int width = cairo_image_surface_get_width(surface);
    int height = cairo_image_surface_get_height(surface);
    // int stride = cairo_image_surface_get_stride(surface); // Unused
    unsigned char *data = cairo_image_surface_get_data(surface);

    if (width != self->width || height != self->height) {
      g_free(self->buffer);
      self->width = width;
      self->height = height;
      self->buffer = (uint8_t *)g_malloc0(width * height * 4);
    }

    // Cairo uses ARGB or RGB24, usually premultiplied. Flutter expects RGBA.
    // WebKit snapshot is usually CAIRO_FORMAT_ARGB32 (premultiplied ARGB, host
    // endian).

    // Convert ARGB to RGBA
    for (int i = 0; i < width * height; i++) {
      // uint32_t* pixel = (uint32_t*)(data + i * 4);

      uint8_t b = data[i * 4];
      uint8_t g = data[i * 4 + 1];
      uint8_t r = data[i * 4 + 2];
      uint8_t a = data[i * 4 + 3];

      self->buffer[i * 4] = r;
      self->buffer[i * 4 + 1] = g;
      self->buffer[i * 4 + 2] = b;
      self->buffer[i * 4 + 3] = a;
    }

    cairo_surface_destroy(surface);

    // Notify texture updated
    fl_texture_registrar_mark_texture_frame_available(self->texture_registrar,
                                                      FL_TEXTURE(self));
  } else {
    if (error) {
      g_warning("Snapshot failed: %s", error->message);
      g_error_free(error);
    }
  }

  g_object_unref(self);
}

static void update_texture(InAppWebView *self) {
  webkit_web_view_get_snapshot(WEBKIT_WEB_VIEW(self->web_view),
                               WEBKIT_SNAPSHOT_REGION_VISIBLE,
                               WEBKIT_SNAPSHOT_OPTIONS_NONE, nullptr,
                               on_snapshot_ready, g_object_ref(self));
}

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
    const gchar *uri = webkit_web_view_get_uri(web_view);
    g_autoptr(FlValue) args = fl_value_new_map();
    fl_value_set_string(args, "url",
                        uri ? fl_value_new_string(uri) : fl_value_new_null());
    fl_method_channel_invoke_method(self->channel, "onLoadStop", args, nullptr,
                                    nullptr, nullptr);
    update_texture(self);
  }
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

  // Connect load-changed signal
  g_signal_connect(self->web_view, "load-changed", G_CALLBACK(on_load_changed),
                   self);
  g_signal_connect(self->web_view, "notify::estimated-load-progress",
                   G_CALLBACK(on_progress_notify), self);

  // Register texture
  if (self->texture_registrar != nullptr &&
      fl_texture_registrar_register_texture(self->texture_registrar,
                                            FL_TEXTURE(self))) {
    self->texture_id = (int64_t)self;
  } else {
    self->texture_id = 0;
  }

  // Set initial size
  gtk_widget_set_size_request(self->web_view, 1280, 720);

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
  } else if (strcmp(method, "createPdf") == 0) {
    WebKitPrintOperation *operation =
        webkit_print_operation_new(WEBKIT_WEB_VIEW(self->web_view));

    GtkPrintSettings *settings = gtk_print_settings_new();

    gchar *filename = g_strdup_printf(
        "/tmp/flutter_inappwebview_print_%p_%ld.pdf", self, g_get_real_time());
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
    g_object_ref(method_call);
    webkit_web_view_get_snapshot(
        WEBKIT_WEB_VIEW(self->web_view), WEBKIT_SNAPSHOT_REGION_VISIBLE,
        WEBKIT_SNAPSHOT_OPTIONS_NONE, nullptr,
        [](GObject *source_object, GAsyncResult *res, gpointer user_data) {
          FlMethodCall *method_call = FL_METHOD_CALL(user_data);
          GError *error = nullptr;
          WebKitWebView *web_view = WEBKIT_WEB_VIEW(source_object);
          cairo_surface_t *surface =
              webkit_web_view_get_snapshot_finish(web_view, res, &error);

          if (!surface) {
            fl_method_call_respond(
                method_call,
                FL_METHOD_RESPONSE(
                    fl_method_success_response_new(fl_value_new_null())),
                nullptr);
            if (error) {
              g_error_free(error);
            }
            g_object_unref(method_call);
            return;
          }

          cairo_surface_flush(surface);

          guchar *png_data = nullptr;
          gsize png_size = 0;

          GdkPixbuf *pixbuf = gdk_pixbuf_get_from_surface(
              surface, 0, 0, cairo_image_surface_get_width(surface),
              cairo_image_surface_get_height(surface));

          if (pixbuf) {
            gchar *buffer = nullptr;
            gsize buffer_size = 0;
            gboolean saved = gdk_pixbuf_save_to_buffer(
                pixbuf, &buffer, &buffer_size, "png", nullptr, nullptr);
            if (saved && buffer && buffer_size > 0) {
              png_data = (guchar *)g_malloc(buffer_size);
              memcpy(png_data, buffer, buffer_size);
              png_size = buffer_size;
              g_free(buffer);
            }
            g_object_unref(pixbuf);
          }

          cairo_surface_destroy(surface);

          if (png_data && png_size > 0) {
            g_autoptr(FlValue) fl_data =
                fl_value_new_uint8_list(png_data, png_size);
            fl_method_call_respond(
                method_call,
                FL_METHOD_RESPONSE(fl_method_success_response_new(fl_data)),
                nullptr);
            g_free(png_data);
          } else {
            fl_method_call_respond(
                method_call,
                FL_METHOD_RESPONSE(
                    fl_method_success_response_new(fl_value_new_null())),
                nullptr);
          }

          g_object_unref(method_call);
        },
        g_object_ref(method_call));
    return;
  } else {
    fl_method_call_respond(
        method_call,
        FL_METHOD_RESPONSE(fl_method_not_implemented_response_new()), nullptr);
  }
}
