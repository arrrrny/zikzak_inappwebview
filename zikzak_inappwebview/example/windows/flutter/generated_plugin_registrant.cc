//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <url_launcher_windows/url_launcher_windows.h>
#include <zikzak_webview_windows/zikzak_webview_windows_plugin.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  UrlLauncherWindowsRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("UrlLauncherWindows"));
  ZikzakWebviewWindowsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("ZikzakWebviewWindowsPlugin"));
}
