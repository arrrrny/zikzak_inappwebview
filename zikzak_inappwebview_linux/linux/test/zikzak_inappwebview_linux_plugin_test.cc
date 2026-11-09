#include <flutter_linux/flutter_linux.h>
#include <gtest/gtest.h>

#include <cstring>
#include <string>
#include <vector>

#include "cookie_manager.h"
#include "include/zikzak_inappwebview_linux/in_app_web_view_flutter_plugin.h"
#include "include/zikzak_inappwebview_linux/zikzak_inappwebview_linux_plugin.h"
#include "in_app_webview/simd_convert.h"
#include "types/url_request.h"
#include "types/user_script.h"
#include "utils/string.h"

// Restored regression coverage for the WPE port. The rewrite deleted the
// GetPlatformVersion tests that guarded GError handling and FlValue
// reference counting; these tests cover the equivalent FlValue-construction
// paths that are runnable headless (no engine): Cookie/URLRequest/UserScript
// construction from FlValues, repeated round-trips as a FlValue refcount
// regression guard, and the pure helpers the native layer depends on (SIMD
// pixel conversion contract, JS identifier validation/escaping).

namespace zikzak_inappwebview {
namespace test {

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

namespace {

// Builds a FlValue map the way the Dart side serializes it.
FlValue* MakeCookieMap() {
  FlValue* map = fl_value_new_map();
  fl_value_set_string_take(map, "name", fl_value_new_string("session"));
  fl_value_set_string_take(map, "value", fl_value_new_string("abc123"));
  fl_value_set_string_take(map, "domain", fl_value_new_string(".example.com"));
  fl_value_set_string_take(map, "path", fl_value_new_string("/"));
  fl_value_set_string_take(map, "isSecure", fl_value_new_bool(TRUE));
  fl_value_set_string_take(map, "isHttpOnly", fl_value_new_bool(FALSE));
  fl_value_set_string_take(map, "sameSite", fl_value_new_string("Lax"));
  return map;
}

}  // namespace

// Verifies Cookie parses every field from the Dart wire map.
TEST(CookieFromFlValue, ParsesAllFields) {
  FlValue* map = MakeCookieMap();
  Cookie cookie(map);
  fl_value_unref(map);

  EXPECT_EQ(cookie.name, "session");
  EXPECT_EQ(cookie.value, "abc123");
  ASSERT_TRUE(cookie.domain.has_value());
  // The leading dot libsoup stores must survive the round-trip so
  // deleteCookies can match it.
  EXPECT_EQ(*cookie.domain, ".example.com");
  ASSERT_TRUE(cookie.path.has_value());
  EXPECT_EQ(*cookie.path, "/");
  EXPECT_TRUE(cookie.isSecure);
  EXPECT_FALSE(cookie.isHttpOnly);
  ASSERT_TRUE(cookie.sameSite.has_value());
  EXPECT_EQ(*cookie.sameSite, "Lax");
}

// Running the FlValue parse repeatedly catches FlValue refcount regressions
// (the role the deleted GetPlatformVersionMultipleCalls test played).
TEST(CookieFromFlValue, RepeatedConstructionDoesNotLeakOrCrash) {
  for (int i = 0; i < 100; i++) {
    FlValue* map = MakeCookieMap();
    Cookie cookie(map);
    fl_value_unref(map);
    ASSERT_EQ(cookie.name, "session");
    g_autoptr(FlValue) back = cookie.toFlValue();
    ASSERT_NE(back, nullptr);
  }
}

// Verifies URLRequest parses url/method/headers/body from the wire map.
TEST(URLRequestFromFlValue, ParsesUrlMethodHeadersAndBody) {
  FlValue* headers = fl_value_new_map();
  fl_value_set_string_take(headers, "X-Test", fl_value_new_string("yes"));
  uint8_t body_bytes[] = {1, 2, 3};
  FlValue* body = fl_value_new_uint8_list(body_bytes, sizeof(body_bytes));

  FlValue* map = fl_value_new_map();
  fl_value_set_string_take(map, "url", fl_value_new_string("https://example.com/post"));
  fl_value_set_string_take(map, "method", fl_value_new_string("POST"));
  fl_value_set_string_take(map, "headers", headers);
  fl_value_set_string_take(map, "body", body);

  URLRequest request(map);
  fl_value_unref(map);

  ASSERT_TRUE(request.url.has_value());
  EXPECT_EQ(*request.url, "https://example.com/post");
  ASSERT_TRUE(request.method.has_value());
  EXPECT_EQ(*request.method, "POST");
  ASSERT_TRUE(request.headers.has_value());
  EXPECT_EQ(request.headers->at("X-Test"), "yes");
  ASSERT_TRUE(request.body.has_value());
  EXPECT_EQ(request.body->size(), 3u);
}

TEST(URLRequestFromFlValue, EmptyMapYieldsNulloptFields) {
  FlValue* map = fl_value_new_map();
  URLRequest request(map);
  fl_value_unref(map);
  EXPECT_FALSE(request.url.has_value());
  EXPECT_FALSE(request.method.has_value());
  EXPECT_FALSE(request.headers.has_value());
  EXPECT_FALSE(request.body.has_value());
}

// Verifies UserScript carries allowedOriginRules from the wire (the rules
// must reach the native model so createWebKitUserScript can pass them to
// WebKit's allow_list).
TEST(UserScriptFromFlValue, PreservesAllowedOriginRules) {
  FlValue* rules = fl_value_new_list();
  fl_value_append_take(rules, fl_value_new_string("https://example.com"));

  FlValue* map = fl_value_new_map();
  fl_value_set_string_take(map, "groupName", fl_value_new_string("group"));
  fl_value_set_string_take(map, "source", fl_value_new_string("console.log(1);"));
  fl_value_set_string_take(map, "injectionTime", fl_value_new_int64(0));
  fl_value_set_string_take(map, "forMainFrameOnly", fl_value_new_bool(TRUE));
  fl_value_set_string_take(map, "allowedOriginRules", rules);

  UserScript script(map);
  fl_value_unref(map);

  ASSERT_TRUE(script.allowedOriginRules.has_value());
  ASSERT_EQ(script.allowedOriginRules->size(), 1u);
  EXPECT_EQ((*script.allowedOriginRules)[0], "https://example.com");
}

TEST(UserScriptFromFlValue, UnsetRulesStayUnset) {
  FlValue* map = fl_value_new_map();
  fl_value_set_string_take(map, "source", fl_value_new_string("1;"));

  UserScript script(map);
  fl_value_unref(map);
  EXPECT_FALSE(script.allowedOriginRules.has_value());
}

// Regression for the premultiplied-alpha contract: every path (SIMD fast
// path and scalar tail) must perform the same BGRA->RGBA channel swap and
// preserve the source alpha — no un-premultiplication, no forced opacity.
TEST(ConvertARGB32ToRGBA, ChannelSwapPreservesPremultipliedAlpha) {
  // One pixel: BGRA (b=0x11, g=0x22, r=0x33, a=0x44) — translucent.
  const uint8_t bgra[4] = {0x11, 0x22, 0x33, 0x44};
  uint8_t rgba[4] = {0, 0, 0, 0};
  ConvertARGB32ToRGBA(bgra, rgba, 1, 1, 4);
  EXPECT_EQ(rgba[0], 0x33);  // R from BGRA byte 2
  EXPECT_EQ(rgba[1], 0x22);  // G unchanged
  EXPECT_EQ(rgba[2], 0x11);  // B from BGRA byte 0
  EXPECT_EQ(rgba[3], 0x44);  // alpha preserved, not forced opaque
}

TEST(ConvertARGB32ToRGBA, TransparentStaysTransparent) {
  const uint8_t bgra[4] = {0, 0, 0, 0};
  uint8_t rgba[4] = {0xFF, 0xFF, 0xFF, 0xFF};
  ConvertARGB32ToRGBA(bgra, rgba, 1, 1, 4);
  EXPECT_EQ(rgba[3], 0x00);
}

// The scalar tail (widths that are not a multiple of the SIMD block) must
// produce byte-identical results to the vector loop, or translucent rows
// show color seams.
TEST(ConvertARGB32ToRGBA, TailMatchesVectorPathForOddWidths) {
  const int height = 2;
  const int stride = 32 * 4;
  std::vector<uint8_t> src(stride * height);
  for (size_t i = 0; i < src.size(); i++) {
    src[i] = static_cast<uint8_t>(i * 7);
  }

  for (int width : {1, 3, 5, 7, 9, 16, 31}) {
    for (int y = 0; y < height; y++) {
      std::vector<uint8_t> dst(static_cast<size_t>(width) * 4);
      ConvertARGB32ToRGBA(src.data() + y * stride, dst.data(), width, 1, stride);
      for (int x = 0; x < width; x++) {
        ASSERT_EQ(dst[x * 4 + 0], src[y * stride + x * 4 + 2])
            << "width=" << width << " px=" << x;
        ASSERT_EQ(dst[x * 4 + 1], src[y * stride + x * 4 + 1])
            << "width=" << width << " px=" << x;
        ASSERT_EQ(dst[x * 4 + 2], src[y * stride + x * 4 + 0])
            << "width=" << width << " px=" << x;
        ASSERT_EQ(dst[x * 4 + 3], src[y * stride + x * 4 + 3])
            << "width=" << width << " px=" << x;
      }
    }
  }
}

// jsObjectName ends up embedded in injected page JS; only valid JS
// identifiers may be exposed (else injection is skipped).
TEST(JsIdentifier, AcceptsValidIdentifiers) {
  EXPECT_TRUE(is_js_identifier("foo"));
  EXPECT_TRUE(is_js_identifier("_foo"));
  EXPECT_TRUE(is_js_identifier("$foo1"));
  EXPECT_TRUE(is_js_identifier("foo_bar$2"));
  EXPECT_FALSE(is_js_identifier(""));
  EXPECT_FALSE(is_js_identifier("1foo"));
  EXPECT_FALSE(is_js_identifier("foo.bar"));
  EXPECT_FALSE(is_js_identifier("foo bar"));
  EXPECT_FALSE(is_js_identifier("foo-bar"));
  EXPECT_FALSE(is_js_identifier("a\\b"));
}

// Backslashes must be escaped before quotes so a trailing backslash cannot
// flip the synthetic closing quote of the surrounding JS string.
TEST(EscapeJsSingleQuoted, EscapesBackslashesAndQuotes) {
  EXPECT_EQ(escape_js_single_quoted("abc"), "abc");
  EXPECT_EQ(escape_js_single_quoted("o'clock"), "o\\'clock");
  EXPECT_EQ(escape_js_single_quoted("back\\slash"), "back\\\\slash");
  EXPECT_EQ(escape_js_single_quoted("trail\\"), "trail\\\\");
  // window['<escaped>'] must not let the quote be neutralized by a
  // trailing backslash in the name.
  std::string embedded = "window['" + escape_js_single_quoted("trail\\") + "'];";
  EXPECT_NE(embedded.find("trail\\\\'"), std::string::npos);
}

}  // namespace test
}  // namespace zikzak_inappwebview
