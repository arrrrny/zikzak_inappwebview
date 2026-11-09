#include <gtest/gtest.h>

#include "include/zikzak_inappwebview_linux/in_app_web_view_flutter_plugin.h"
#include "include/zikzak_inappwebview_linux/zikzak_inappwebview_linux_plugin.h"

// Placeholder test for the zikzak_inappwebview_linux plugin.
// More comprehensive tests can be added as features are implemented.

namespace zikzak_inappwebview {
namespace test {

TEST(ZikzakInappwebviewLinuxPlugin, Placeholder) {
  // This is a placeholder test to satisfy the CMake build.
  // Real tests should be added for the WebView functionality.
  EXPECT_TRUE(true);
}

// The symbol Flutter's generated registrant calls for
// pubspec.yaml's `pluginClass: InAppWebViewFlutterPlugin`.
TEST(ZikzakInappwebviewLinuxPlugin, RegistrationSymbolExists) {
  void (*register_fn)(FlPluginRegistrar*) =
      in_app_web_view_flutter_plugin_register_with_registrar;
  EXPECT_NE(register_fn, nullptr);
}

TEST(ZikzakInappwebviewLinuxPlugin, MainRegistrationSymbolExists) {
  void (*register_fn)(FlPluginRegistrar*) =
      zikzak_inappwebview_linux_plugin_register_with_registrar;
  EXPECT_NE(register_fn, nullptr);
}

}  // namespace test
}  // namespace zikzak_inappwebview
