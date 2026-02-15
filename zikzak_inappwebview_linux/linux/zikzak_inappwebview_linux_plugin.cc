#include "include/zikzak_inappwebview_linux/zikzak_inappwebview_linux_plugin.h"

#include <flutter_linux/flutter_linux.h>
#include <gtk/gtk.h>
#include <sys/utsname.h>

#include <cstring>
#include <iostream>

#include "zikzak_inappwebview_linux_plugin_private.h"
#include "include/zikzak_inappwebview_linux/in_app_webview.h"

#define ZIKZAK_INAPPWEBVIEW_LINUX_PLUGIN(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST((obj), zikzak_inappwebview_linux_plugin_get_type(), \
                              ZikzakInappwebviewLinuxPlugin))

struct _ZikzakInappwebviewLinuxPlugin {
  GObject parent_instance;
  FlPluginRegistrar* registrar;
  GHashTable* web_views;
};

G_DEFINE_TYPE(ZikzakInappwebviewLinuxPlugin, zikzak_inappwebview_linux_plugin, g_object_get_type())

// Called when a method call is received from Flutter.
static void zikzak_inappwebview_linux_plugin_handle_method_call(
    ZikzakInappwebviewLinuxPlugin* self,
    FlMethodCall* method_call) {
  g_autoptr(FlMethodResponse) response = nullptr;

  const gchar* method = fl_method_call_get_name(method_call);
  FlValue* args = fl_method_call_get_args(method_call);

  if (strcmp(method, "getPlatformVersion") == 0) {
    response = get_platform_version();
  } else if (strcmp(method, "create") == 0) {
      if (fl_value_get_type(args) == FL_VALUE_TYPE_MAP) {
          FlValue* idVal = fl_value_lookup_string(args, "id");
          if (idVal && fl_value_get_type(idVal) == FL_VALUE_TYPE_STRING) {
              const char* id = fl_value_get_string(idVal);
              
              InAppWebView* webview = in_app_webview_new(self->registrar, id);
              
              g_hash_table_insert(self->web_views, g_strdup(id), webview);
              
              int64_t texture_id = in_app_webview_get_texture_id(webview);
              response = FL_METHOD_RESPONSE(fl_method_success_response_new(fl_value_new_int(texture_id)));
          }
      }
      if (!response) {
         response = FL_METHOD_RESPONSE(fl_method_error_response_new("error", "Invalid arguments", nullptr));
      }
  } else {
    response = FL_METHOD_RESPONSE(fl_method_not_implemented_response_new());
  }

  fl_method_call_respond(method_call, response, nullptr);
}

static void headless_method_call_cb(FlMethodChannel* channel, FlMethodCall* method_call, gpointer user_data) {
  ZikzakInappwebviewLinuxPlugin* self = ZIKZAK_INAPPWEBVIEW_LINUX_PLUGIN(user_data);
  g_autoptr(FlMethodResponse) response = nullptr;
  
  const gchar* method = fl_method_call_get_name(method_call);
  FlValue* args = fl_method_call_get_args(method_call);
  
  if (strcmp(method, "createHeadless") == 0) {
      if (fl_value_get_type(args) == FL_VALUE_TYPE_MAP) {
          FlValue* idVal = fl_value_lookup_string(args, "id");
          if (idVal && fl_value_get_type(idVal) == FL_VALUE_TYPE_STRING) {
              const char* id = fl_value_get_string(idVal);
              
              InAppWebView* webview = in_app_webview_new(self->registrar, id);
              g_hash_table_insert(self->web_views, g_strdup(id), webview);
              
              response = FL_METHOD_RESPONSE(fl_method_success_response_new(fl_value_new_bool(true)));
          }
      }
  } else {
      response = FL_METHOD_RESPONSE(fl_method_not_implemented_response_new());
  }
  
  if (!response) {
     response = FL_METHOD_RESPONSE(fl_method_error_response_new("error", "Invalid arguments", nullptr));
  }
  
  fl_method_call_respond(method_call, response, nullptr);
}

static void browser_method_call_cb(FlMethodChannel* channel, FlMethodCall* method_call, gpointer user_data) {
    fl_method_call_respond(method_call, FL_METHOD_RESPONSE(fl_method_not_implemented_response_new()), nullptr);
}

FlMethodResponse* get_platform_version() {
  struct utsname uname_data = {};
  uname(&uname_data);
  g_autofree gchar *version = g_strdup_printf("Linux %s", uname_data.version);
  g_autoptr(FlValue) result = fl_value_new_string(version);
  return FL_METHOD_RESPONSE(fl_method_success_response_new(result));
}

static void zikzak_inappwebview_linux_plugin_dispose(GObject* object) {
  ZikzakInappwebviewLinuxPlugin* self = ZIKZAK_INAPPWEBVIEW_LINUX_PLUGIN(object);
  if (self->web_views) {
      g_hash_table_destroy(self->web_views);
  }
  G_OBJECT_CLASS(zikzak_inappwebview_linux_plugin_parent_class)->dispose(object);
}

static void zikzak_inappwebview_linux_plugin_class_init(ZikzakInappwebviewLinuxPluginClass* klass) {
  G_OBJECT_CLASS(klass)->dispose = zikzak_inappwebview_linux_plugin_dispose;
}

static void zikzak_inappwebview_linux_plugin_init(ZikzakInappwebviewLinuxPlugin* self) {
    self->web_views = g_hash_table_new_full(g_str_hash, g_str_equal, g_free, g_object_unref);
}

static void method_call_cb(FlMethodChannel* channel, FlMethodCall* method_call,
                           gpointer user_data) {
  ZikzakInappwebviewLinuxPlugin* plugin = ZIKZAK_INAPPWEBVIEW_LINUX_PLUGIN(user_data);
  zikzak_inappwebview_linux_plugin_handle_method_call(plugin, method_call);
}

void zikzak_inappwebview_linux_plugin_register_with_registrar(FlPluginRegistrar* registrar) {
  ZikzakInappwebviewLinuxPlugin* plugin = ZIKZAK_INAPPWEBVIEW_LINUX_PLUGIN(
      g_object_new(zikzak_inappwebview_linux_plugin_get_type(), nullptr));
  
  plugin->registrar = registrar;

  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
  g_autoptr(FlMethodChannel) channel =
      fl_method_channel_new(fl_plugin_registrar_get_messenger(registrar),
                            "zikzak_inappwebview_linux",
                            FL_METHOD_CODEC(codec));
  fl_method_channel_set_method_call_handler(channel, method_call_cb,
                                            g_object_ref(plugin),
                                            g_object_unref);

  g_autoptr(FlStandardMethodCodec) headless_codec = fl_standard_method_codec_new();
  g_autoptr(FlMethodChannel) headless_channel =
      fl_method_channel_new(fl_plugin_registrar_get_messenger(registrar),
                            "wtf.zikzak/flutter_headless_inappwebview",
                            FL_METHOD_CODEC(headless_codec));
  fl_method_channel_set_method_call_handler(headless_channel, headless_method_call_cb,
                                            g_object_ref(plugin),
                                            g_object_unref);

  g_autoptr(FlStandardMethodCodec) browser_codec = fl_standard_method_codec_new();
  g_autoptr(FlMethodChannel) browser_channel =
      fl_method_channel_new(fl_plugin_registrar_get_messenger(registrar),
                            "dev.zuzu/flutter_inappbrowser",
                            FL_METHOD_CODEC(browser_codec));
  fl_method_channel_set_method_call_handler(browser_channel, browser_method_call_cb,
                                            g_object_ref(plugin),
                                            g_object_unref);

  g_object_unref(plugin);
}
