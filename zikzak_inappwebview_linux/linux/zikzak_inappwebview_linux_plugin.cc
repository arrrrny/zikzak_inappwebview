#include "include/zikzak_inappwebview_linux/zikzak_inappwebview_linux_plugin.h"
#include "include/zikzak_inappwebview_linux/in_app_web_view_flutter_plugin.h"

#include "zikzak_inappwebview_linux_plugin_private.h"
#include "plugin_instance.h"

#include <flutter_linux/flutter_linux.h>
#include <gdk/gdk.h>
#include <gtk/gtk.h>

#include <cstring>
#include <memory>

#include "cookie_manager.h"
#include "credential_database.h"
#include "headless_in_app_webview/headless_in_app_webview_manager.h"
#include "in_app_browser/in_app_browser_manager.h"
#include "in_app_webview/in_app_webview_manager.h"
#include "proxy_manager.h"
#include "utils/software_rendering.h"
#include "web_storage_manager.h"
#include "webview_environment.h"

#define ZIKZAK_INAPPWEBVIEW_LINUX_PLUGIN(obj)                                     \
  (G_TYPE_CHECK_INSTANCE_CAST((obj), zikzak_inappwebview_linux_plugin_get_type(), \
                              ZikzakInappwebviewLinuxPlugin))

struct _ZikzakInappwebviewLinuxPlugin {
  GObject parent_instance;
  FlPluginRegistrar* registrar;
  
  // C++ plugin instance for passing to managers
  std::unique_ptr<zikzak_inappwebview::PluginInstance> plugin_instance;
  
  // Managers are owned by the GObject
  std::unique_ptr<zikzak_inappwebview::InAppWebViewManager> in_app_webview_manager;
  std::unique_ptr<zikzak_inappwebview::HeadlessInAppWebViewManager> headless_in_app_webview_manager;
  std::unique_ptr<zikzak_inappwebview::InAppBrowserManager> in_app_browser_manager;
  std::unique_ptr<zikzak_inappwebview::CookieManager> cookie_manager;
  std::unique_ptr<zikzak_inappwebview::CredentialDatabase> credential_database;
  std::unique_ptr<zikzak_inappwebview::ProxyManager> proxy_manager;
  std::unique_ptr<zikzak_inappwebview::WebStorageManager> web_storage_manager;
  std::unique_ptr<zikzak_inappwebview::WebViewEnvironment> webview_environment;
};

G_DEFINE_TYPE(ZikzakInappwebviewLinuxPlugin, zikzak_inappwebview_linux_plugin,
              g_object_get_type())

static void zikzak_inappwebview_linux_plugin_dispose(GObject* object) {
  ZikzakInappwebviewLinuxPlugin* self = ZIKZAK_INAPPWEBVIEW_LINUX_PLUGIN(object);

  // Clean up the managers
  self->in_app_webview_manager.reset();
  self->headless_in_app_webview_manager.reset();
  self->in_app_browser_manager.reset();
  self->cookie_manager.reset();
  self->credential_database.reset();
  self->proxy_manager.reset();
  self->web_storage_manager.reset();
  self->webview_environment.reset();
  
  // Clean up the plugin instance last (after managers are gone)
  self->plugin_instance.reset();

  G_OBJECT_CLASS(zikzak_inappwebview_linux_plugin_parent_class)->dispose(object);
}

static void zikzak_inappwebview_linux_plugin_class_init(
    ZikzakInappwebviewLinuxPluginClass* klass) {
  G_OBJECT_CLASS(klass)->dispose = zikzak_inappwebview_linux_plugin_dispose;
}

static void zikzak_inappwebview_linux_plugin_init(ZikzakInappwebviewLinuxPlugin* self) {
  self->registrar = nullptr;
  // Note: in_app_webview_manager is initialized by its default constructor
}

void zikzak_inappwebview_linux_plugin_register_with_registrar(FlPluginRegistrar* registrar) {
  // === CRITICAL: Check for VM/problematic GPU BEFORE any WebKit initialization ===
  // This must happen before any WPEDisplay is created, because WebKit's WebProcess
  // inherits environment variables at spawn time. Setting LIBGL_ALWAYS_SOFTWARE
  // after WebProcess starts has no effect.
  zikzak_inappwebview::ApplySoftwareRenderingIfNeeded();

  ZikzakInappwebviewLinuxPlugin* plugin = ZIKZAK_INAPPWEBVIEW_LINUX_PLUGIN(
      g_object_new(zikzak_inappwebview_linux_plugin_get_type(), nullptr));

  plugin->registrar = registrar;

  plugin->plugin_instance = std::make_unique<zikzak_inappwebview::PluginInstance>(registrar);
  auto* pluginInstance = plugin->plugin_instance.get();

  plugin->in_app_webview_manager =
      std::make_unique<zikzak_inappwebview::InAppWebViewManager>(pluginInstance);
  pluginInstance->inAppWebViewManager = plugin->in_app_webview_manager.get();

  plugin->headless_in_app_webview_manager =
      std::make_unique<zikzak_inappwebview::HeadlessInAppWebViewManager>(pluginInstance);
  pluginInstance->headlessInAppWebViewManager = plugin->headless_in_app_webview_manager.get();

  plugin->in_app_browser_manager =
      std::make_unique<zikzak_inappwebview::InAppBrowserManager>(pluginInstance);
  pluginInstance->inAppBrowserManager = plugin->in_app_browser_manager.get();

  plugin->cookie_manager = std::make_unique<zikzak_inappwebview::CookieManager>(pluginInstance);
  pluginInstance->cookieManager = plugin->cookie_manager.get();

  plugin->credential_database =
      std::make_unique<zikzak_inappwebview::CredentialDatabase>(pluginInstance);
  pluginInstance->credentialDatabase = plugin->credential_database.get();

  plugin->proxy_manager = std::make_unique<zikzak_inappwebview::ProxyManager>(pluginInstance);
  pluginInstance->proxyManager = plugin->proxy_manager.get();

  plugin->web_storage_manager = std::make_unique<zikzak_inappwebview::WebStorageManager>(pluginInstance);
  pluginInstance->webStorageManager = plugin->web_storage_manager.get();

  plugin->webview_environment = std::make_unique<zikzak_inappwebview::WebViewEnvironment>(pluginInstance);
  pluginInstance->webViewEnvironment = plugin->webview_environment.get();

  // Note: We don't unref the plugin here as it needs to stay alive
  // for the lifetime of the application
  g_object_ref(plugin);
}

// === Helper functions for accessing Flutter view and window ===

FlView* zikzak_inappwebview_linux_plugin_get_view(FlPluginRegistrar* registrar) {
  if (registrar == nullptr) {
    return nullptr;
  }
  return fl_plugin_registrar_get_view(registrar);
}

GtkWindow* zikzak_inappwebview_linux_plugin_get_window(FlPluginRegistrar* registrar) {
  FlView* view = zikzak_inappwebview_linux_plugin_get_view(registrar);
  if (view == nullptr) {
    return nullptr;
  }

  GtkWidget* widget = GTK_WIDGET(view);
  if (widget == nullptr) {
    return nullptr;
  }

  GtkWidget* toplevel = gtk_widget_get_toplevel(widget);
  if (toplevel == nullptr || !GTK_IS_WINDOW(toplevel)) {
    return nullptr;
  }

  return GTK_WINDOW(toplevel);
}

int zikzak_inappwebview_linux_plugin_get_monitor_refresh_rate(FlPluginRegistrar* registrar) {
  GtkWindow* window = zikzak_inappwebview_linux_plugin_get_window(registrar);
  return zikzak_inappwebview_linux_plugin_get_monitor_refresh_rate_for_window(window);
}

int zikzak_inappwebview_linux_plugin_get_monitor_refresh_rate_for_window(GtkWindow* window) {
  if (window == nullptr) {
    return 0;
  }

  GdkWindow* gdk_window = gtk_widget_get_window(GTK_WIDGET(window));
  if (gdk_window == nullptr) {
    return 0;
  }

  GdkDisplay* display = gdk_display_get_default();
  if (display == nullptr) {
    return 0;
  }

  GdkMonitor* monitor = gdk_display_get_monitor_at_window(display, gdk_window);
  if (monitor == nullptr) {
    return 0;
  }

  // gdk_monitor_get_refresh_rate returns the refresh rate in millihertz
  // (e.g., 60000 for 60 Hz)
  return gdk_monitor_get_refresh_rate(monitor);
}


void in_app_web_view_flutter_plugin_register_with_registrar(
    FlPluginRegistrar* registrar) {
  zikzak_inappwebview_linux_plugin_register_with_registrar(registrar);
}
