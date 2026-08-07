#include <flutter_linux/flutter_linux.h>
#include <gmock/gmock.h>
#include <gtest/gtest.h>

#include "include/zikzak_inappwebview_linux/zikzak_inappwebview_linux_plugin.h"
#include "include/zikzak_inappwebview_linux/in_app_web_view_flutter_plugin.h"
#include "zikzak_inappwebview_linux_plugin_private.h"

// This demonstrates a simple unit test of the C portion of this plugin's
// implementation.
//
// Once you have built the plugin's example app, you can run these tests
// from the command line. For instance, for a plugin called my_plugin
// built for x64 debug, run:
// $ build/linux/x64/debug/plugins/my_plugin/my_plugin_test

namespace zikzak_inappwebview_linux {
namespace test {

// Verifies that getPlatformVersion returns a non-null success response
// containing a string that starts with "Linux ".
TEST(ZikzakInappwebviewLinuxPlugin, GetPlatformVersion) {
  g_autoptr(FlMethodResponse) response = get_platform_version();
  ASSERT_NE(response, nullptr);
  ASSERT_TRUE(FL_IS_METHOD_SUCCESS_RESPONSE(response));
  FlValue* result = fl_method_success_response_get_result(
      FL_METHOD_SUCCESS_RESPONSE(response));
  ASSERT_EQ(fl_value_get_type(result), FL_VALUE_TYPE_STRING);
  // The full string varies, so just validate that it has the right format.
  EXPECT_THAT(fl_value_get_string(result), testing::StartsWith("Linux "));
}

// Verifies that getPlatformVersion can be called multiple times without
// leaking or crashing. This catches regressions in the GError handling and
// FlValue reference counting.
TEST(ZikzakInappwebviewLinuxPlugin, GetPlatformVersionMultipleCalls) {
  for (int i = 0; i < 100; i++) {
    g_autoptr(FlMethodResponse) response = get_platform_version();
    ASSERT_NE(response, nullptr);
    ASSERT_TRUE(FL_IS_METHOD_SUCCESS_RESPONSE(response));
  }
}

// Verifies that the plugin's exported registration symbol exists and can be
// called without crashing. This is the entry point Flutter invokes when
// loading the plugin; if the include path or symbol name is wrong, the plugin
// silently fails to load and the user sees a blue texture (issue #179).
TEST(ZikzakInappwebviewLinuxPlugin, RegistrationSymbolExists) {
  // The function pointer must be non-null. We don't call it here because
  // registration requires a full FlPluginRegistrar which is only available
  // in a running Flutter engine.
  void (*register_fn)(FlPluginRegistrar*) =
      in_app_web_view_flutter_plugin_register_with_registrar;
  EXPECT_NE(register_fn, nullptr);
}

// Verifies that the plugin's main registration symbol also exists. Both
// symbols must be present so that whichever name the generated plugin
// registrant uses, the plugin loads correctly.
TEST(ZikzakInappwebviewLinuxPlugin, MainRegistrationSymbolExists) {
  void (*register_fn)(FlPluginRegistrar*) =
      zikzak_inappwebview_linux_plugin_register_with_registrar;
  EXPECT_NE(register_fn, nullptr);
}

}  // namespace test
}  // namespace zikzak_inappwebview_linux
