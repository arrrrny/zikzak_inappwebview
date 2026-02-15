#include "include/zikzak_inappwebview_linux/in_app_webview.h"
#include <cstring>
#include <iostream>

struct _InAppWebView {
  FlPixelBufferTexture parent_instance;
  FlPluginRegistrar* registrar;
  char* id;
  FlMethodChannel* channel;
  GtkWidget* web_view;
  int64_t texture_id;
  
  uint8_t* buffer;
  int32_t width;
  int32_t height;
};

G_DEFINE_TYPE(InAppWebView, in_app_webview, fl_pixel_buffer_texture_get_type())

static gboolean in_app_webview_copy_pixels(FlPixelBufferTexture* texture,
                                           const uint8_t** buffer,
                                           uint32_t* width,
                                           uint32_t* height,
                                           GError** error) {
  InAppWebView* self = IN_APP_WEBVIEW(texture);
  
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

static void in_app_webview_dispose(GObject* object) {
  InAppWebView* self = IN_APP_WEBVIEW(object);
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

static void in_app_webview_class_init(InAppWebViewClass* klass) {
  G_OBJECT_CLASS(klass)->dispose = in_app_webview_dispose;
  FL_PIXEL_BUFFER_TEXTURE_CLASS(klass)->copy_pixels = in_app_webview_copy_pixels;
}

static void in_app_webview_init(InAppWebView* self) {
    self->width = 1280;
    self->height = 720;
    self->buffer = (uint8_t*)g_malloc0(self->width * self->height * 4);
    
    // Fill with blue for initial state
    for (int i = 0; i < self->width * self->height; i++) {
        self->buffer[i * 4] = 0;     // R
        self->buffer[i * 4 + 1] = 0; // G
        self->buffer[i * 4 + 2] = 255; // B
        self->buffer[i * 4 + 3] = 255; // A
    }
}

static void in_app_webview_method_call_handler(FlMethodChannel* channel, FlMethodCall* method_call, gpointer user_data) {
    in_app_webview_handle_method_call(IN_APP_WEBVIEW(user_data), method_call);
}

// Helper to update texture from snapshot
static void on_snapshot_ready(GObject* source_object, GAsyncResult* res, gpointer user_data) {
    InAppWebView* self = IN_APP_WEBVIEW(user_data);
    GError* error = nullptr;
    WebKitWebView* web_view = WEBKIT_WEB_VIEW(source_object);
    cairo_surface_t* surface = webkit_web_view_get_snapshot_finish(web_view, res, &error);
    
    if (surface) {
        int width = cairo_image_surface_get_width(surface);
        int height = cairo_image_surface_get_height(surface);
        // int stride = cairo_image_surface_get_stride(surface); // Unused
        unsigned char* data = cairo_image_surface_get_data(surface);
        
        if (width != self->width || height != self->height) {
            g_free(self->buffer);
            self->width = width;
            self->height = height;
            self->buffer = (uint8_t*)g_malloc0(width * height * 4);
        }
        
        // Cairo uses ARGB or RGB24, usually premultiplied. Flutter expects RGBA.
        // WebKit snapshot is usually CAIRO_FORMAT_ARGB32 (premultiplied ARGB, host endian).
        
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
        fl_texture_registrar_mark_texture_frame_available(
            fl_plugin_registrar_get_texture_registrar(self->registrar),
            FL_TEXTURE(self));
    } else {
        if (error) {
            g_warning("Snapshot failed: %s", error->message);
            g_error_free(error);
        }
    }
    
    g_object_unref(self);
}

static void update_texture(InAppWebView* self) {
    webkit_web_view_get_snapshot(WEBKIT_WEB_VIEW(self->web_view),
                                 WEBKIT_SNAPSHOT_REGION_VISIBLE,
                                 WEBKIT_SNAPSHOT_OPTIONS_NONE,
                                 nullptr,
                                 on_snapshot_ready,
                                 g_object_ref(self));
}

static void on_load_changed(WebKitWebView* web_view, WebKitLoadEvent load_event, gpointer user_data) {
    InAppWebView* self = IN_APP_WEBVIEW(user_data);
    // Take snapshot on load events
    if (load_event == WEBKIT_LOAD_FINISHED) {
        update_texture(self);
    }
}

InAppWebView* in_app_webview_new(FlPluginRegistrar* registrar, const char* id) {
  InAppWebView* self = IN_APP_WEBVIEW(g_object_new(IN_APP_WEBVIEW_TYPE, nullptr));
  self->registrar = registrar;
  self->id = g_strdup(id);
  
  g_autofree gchar* channel_name = g_strdup_printf("dev.zuzu/zikzak_inappwebview_%s", id);
  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
  self->channel = fl_method_channel_new(fl_plugin_registrar_get_messenger(registrar),
                                        channel_name,
                                        FL_METHOD_CODEC(codec));
  fl_method_channel_set_method_call_handler(self->channel, in_app_webview_method_call_handler, g_object_ref(self), g_object_unref);
  
  self->web_view = webkit_web_view_new();
  g_object_ref_sink(self->web_view);
  
  // Connect load-changed signal
  g_signal_connect(self->web_view, "load-changed", G_CALLBACK(on_load_changed), self);
  
  // Register texture
  FlTextureRegistrar* texture_registrar = fl_plugin_registrar_get_texture_registrar(registrar);
  if (fl_texture_registrar_register_texture(texture_registrar, FL_TEXTURE(self))) {
      self->texture_id = (int64_t)self;
  } else {
      self->texture_id = 0;
  }
  
  // Set initial size
  gtk_widget_set_size_request(self->web_view, 1280, 720);
  
  return self;
}

int64_t in_app_webview_get_texture_id(InAppWebView* self) {
    return self->texture_id;
}

void in_app_webview_handle_method_call(InAppWebView* self, FlMethodCall* method_call) {
    const gchar* method = fl_method_call_get_name(method_call);
    FlValue* args = fl_method_call_get_args(method_call);
    
    if (strcmp(method, "getUrl") == 0) {
        const gchar* uri = webkit_web_view_get_uri(WEBKIT_WEB_VIEW(self->web_view));
        g_autoptr(FlValue) result = uri ? fl_value_new_string(uri) : fl_value_new_null();
        fl_method_call_respond(method_call, FL_METHOD_RESPONSE(fl_method_success_response_new(result)), nullptr);
    } else if (strcmp(method, "loadUrl") == 0) {
        if (fl_value_get_type(args) == FL_VALUE_TYPE_MAP) {
             FlValue* urlRequest = fl_value_lookup_string(args, "urlRequest");
             if (urlRequest && fl_value_get_type(urlRequest) == FL_VALUE_TYPE_MAP) {
                 FlValue* urlVal = fl_value_lookup_string(urlRequest, "url");
                 if (urlVal && fl_value_get_type(urlVal) == FL_VALUE_TYPE_STRING) {
                     const char* url = fl_value_get_string(urlVal);
                     webkit_web_view_load_uri(WEBKIT_WEB_VIEW(self->web_view), url);
                     fl_method_call_respond(method_call, FL_METHOD_RESPONSE(fl_method_success_response_new(fl_value_new_bool(true))), nullptr);
                     return;
                 }
             }
        }
        fl_method_call_respond(method_call, FL_METHOD_RESPONSE(fl_method_error_response_new("error", "Invalid arguments", nullptr)), nullptr);
    } else {
        fl_method_call_respond(method_call, FL_METHOD_RESPONSE(fl_method_not_implemented_response_new()), nullptr);
    }
}
