# The Flutter tooling requires that developers have CMake 3.10 or later
# installed. You should not increase this version, as doing so will cause
# the plugin to fail to compile for some customers of the plugin.
cmake_minimum_required(VERSION 3.10)

# Project-level configuration.
set(PROJECT_NAME "zikzak_inappwebview_linux")
project(${PROJECT_NAME} LANGUAGES CXX C)

# This value is used when generating builds using this plugin, so it must
# not be changed.
set(PLUGIN_NAME "zikzak_inappwebview_linux_plugin")

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# nlohmann/json version for JSON parsing
set(NLOHMANN_JSON_VERSION "3.11.3")

# === WPE WebKit Backend ===
# This plugin uses WPE WebKit for offscreen web rendering.
# WPE WebKit is designed for embedded systems and provides excellent offscreen
# rendering performance through DMA-BUF buffer sharing.
#
# Dual API Support:
#   - WPEPlatform API (wpe-platform-2.0): NEW default API for WPE WebKit 2.40+
#   - WPEBackend-FDO (wpebackend-fdo-1.0): Legacy fallback for older systems
#
# Required packages:
#   - wpe-webkit-2.0 (or wpe-webkit-1.1 on older systems)
#   - wpe-platform-2.0 (preferred) OR wpebackend-fdo-1.0 (fallback)
#   - libwpe-1.0
#
# See README.md (then WPE_BACKEND.md) for installation instructions.

find_package(PkgConfig REQUIRED)

# Always require epoxy for OpenGL support
pkg_check_modules(EPOXY REQUIRED IMPORTED_TARGET epoxy)

# GTK is still needed for GDK (display access, event handling)
pkg_check_modules(GTK REQUIRED IMPORTED_TARGET gtk+-3.0)

message(STATUS "zikzak_inappwebview_linux: Using WPE WebKit backend")

# Try wpe-webkit-2.0 first (newer API), fall back to wpe-webkit-1.1, then wpe-webkit-1.0
pkg_check_modules(WPE_WEBKIT QUIET IMPORTED_TARGET wpe-webkit-2.0)
if(NOT WPE_WEBKIT_FOUND)
  pkg_check_modules(WPE_WEBKIT QUIET IMPORTED_TARGET wpe-webkit-1.1)
  if(WPE_WEBKIT_FOUND)
    message(STATUS "zikzak_inappwebview_linux: Found wpe-webkit-1.1 (${WPE_WEBKIT_VERSION})")
  else()
    pkg_check_modules(WPE_WEBKIT QUIET IMPORTED_TARGET wpe-webkit-1.0)
    if(WPE_WEBKIT_FOUND)
      message(STATUS "zikzak_inappwebview_linux: Found wpe-webkit-1.0 (${WPE_WEBKIT_VERSION})")
    endif()
  endif()
else()
  message(STATUS "zikzak_inappwebview_linux: Found wpe-webkit-2.0 (${WPE_WEBKIT_VERSION})")
endif()

if(NOT WPE_WEBKIT_FOUND)
  message(FATAL_ERROR "WPE WebKit not found. Please install libwpewebkit-1.0-dev (Ubuntu/Debian) or wpe-webkit package.\n"
                      "See the package README (zikzak_inappwebview_linux/README.md), then WPE_BACKEND.md or https://wpewebkit.org/about/get-wpe.html")
endif()

# === WPE Platform API Detection (NEW - default) ===
# Check for WPEPlatform API first (wpe-platform-2.0) - this is the modern API
# introduced in WPE WebKit 2.40+ and is the preferred approach.
pkg_check_modules(WPE_PLATFORM QUIET IMPORTED_TARGET wpe-platform-2.0)
pkg_check_modules(WPE_PLATFORM_HEADLESS QUIET IMPORTED_TARGET wpe-platform-headless-2.0)

if(WPE_PLATFORM_FOUND AND WPE_PLATFORM_HEADLESS_FOUND)
  # Additional check: verify that WebKit was actually built WITH WPEPlatform support
  # The pkg-config file may exist but WebKit headers may not have the required functions
  # This happens when WPE WebKit is rebuilt without WPEPlatform support
  include(CheckCXXSourceCompiles)
  set(CMAKE_REQUIRED_INCLUDES ${WPE_WEBKIT_INCLUDE_DIRS} ${WPE_PLATFORM_INCLUDE_DIRS})
  # Full library paths, so the check also links when WPE is installed in a
  # prefix the linker does not search by default (e.g. ~/.local/opt/wpe).
  set(CMAKE_REQUIRED_LIBRARIES ${WPE_WEBKIT_LINK_LIBRARIES} ${WPE_PLATFORM_LINK_LIBRARIES})
  check_cxx_source_compiles("
    #include <wpe/webkit.h>
    int main() {
      WebKitWebView* view = nullptr;
      webkit_web_view_get_wpe_view(view);
      return 0;
    }
  " WEBKIT_HAS_WPE_PLATFORM_API)
  
  if(WEBKIT_HAS_WPE_PLATFORM_API)
    message(STATUS "zikzak_inappwebview_linux: Found wpe-platform-2.0 (WPEPlatform API - DEFAULT)")
    message(STATUS "zikzak_inappwebview_linux: Found wpe-platform-headless-2.0")
    message(STATUS "zikzak_inappwebview_linux: WebKit has WPEPlatform API support (webkit_web_view_get_wpe_view)")
    set(HAVE_WPE_PLATFORM ON)
    add_compile_definitions(HAVE_WPE_PLATFORM=1)
  else()
    message(STATUS "zikzak_inappwebview_linux: wpe-platform-2.0 pkg-config found, but WebKit lacks WPEPlatform API")
    message(STATUS "zikzak_inappwebview_linux: WebKit was likely built without WPEPlatform support, falling back to legacy FDO")
  endif()
endif()

# === WPE Backend FDO Detection (Legacy - fallback) ===
# Check for WPEBackend-FDO as fallback ONLY if WPEPlatform is NOT available
# WPEPlatform and WPEBackend-FDO are mutually exclusive at compile time
pkg_check_modules(WPE_FDO QUIET IMPORTED_TARGET wpebackend-fdo-1.0)
if(WPE_FDO_FOUND AND NOT HAVE_WPE_PLATFORM)
  message(STATUS "zikzak_inappwebview_linux: Found wpebackend-fdo-1.0 (Legacy FDO API)")
  set(HAVE_WPE_FDO ON)
  add_compile_definitions(HAVE_WPE_BACKEND_LEGACY=1)
elseif(WPE_FDO_FOUND AND HAVE_WPE_PLATFORM)
  message(STATUS "zikzak_inappwebview_linux: wpebackend-fdo-1.0 available but not used (WPEPlatform preferred)")
endif()

# Require at least one backend
if(NOT HAVE_WPE_PLATFORM AND NOT HAVE_WPE_FDO)
  message(FATAL_ERROR "Neither WPEPlatform (wpe-platform-2.0) nor WPEBackend-FDO (wpebackend-fdo-1.0) found.\n"
                      "Please install one of:\n"
                      "  - WPE WebKit 2.40+ with WPEPlatform support (recommended)\n"
                      "  - wpebackend-fdo-1.0-dev (legacy fallback)\n"
                      "See the package README (zikzak_inappwebview_linux/README.md), then WPE_BACKEND.md.")
endif()

# Check for libwpe
pkg_check_modules(LIBWPE QUIET IMPORTED_TARGET wpe-1.0)
if(NOT LIBWPE_FOUND)
  message(FATAL_ERROR "libwpe (wpe-1.0) not found. Please install libwpe-1.0-dev.")
endif()

# Check for libsecret for secure credential storage
pkg_check_modules(LIBSECRET REQUIRED IMPORTED_TARGET libsecret-1)
message(STATUS "zikzak_inappwebview_linux: Found libsecret-1 (${LIBSECRET_VERSION})")

# Find wayland-server for SHM buffer handling
pkg_check_modules(WAYLAND_SERVER REQUIRED IMPORTED_TARGET wayland-server)

# Enable SIMD optimizations for color conversion
# These flags enable NEON on ARM64 and SSE/SSSE3 on x86_64
include(CheckCXXCompilerFlag)
if(CMAKE_SYSTEM_PROCESSOR MATCHES "aarch64|arm64|ARM64")
  # ARM64: NEON is always available
  message(STATUS "zikzak_inappwebview_linux: ARM64 detected, NEON enabled")
elseif(CMAKE_SYSTEM_PROCESSOR MATCHES "x86_64|AMD64|amd64")
  # x86_64: Check for SSSE3 support
  check_cxx_compiler_flag("-mssse3" COMPILER_SUPPORTS_SSSE3)
  if(COMPILER_SUPPORTS_SSSE3)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -mssse3")
    message(STATUS "zikzak_inappwebview_linux: x86_64 with SSSE3 enabled")
  else()
    check_cxx_compiler_flag("-msse2" COMPILER_SUPPORTS_SSE2)
    if(COMPILER_SUPPORTS_SSE2)
      set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -msse2")
      message(STATUS "zikzak_inappwebview_linux: x86_64 with SSE2 enabled")
    endif()
  endif()
endif()

# === nlohmann/json dependency for JSON parsing ===
include(FetchContent)
FetchContent_Declare(
  nlohmann_json
  URL https://github.com/nlohmann/json/releases/download/v${NLOHMANN_JSON_VERSION}/json.tar.xz
  DOWNLOAD_EXTRACT_TIMESTAMP TRUE
)
# Don't build tests/examples
set(JSON_BuildTests OFF CACHE INTERNAL "")
FetchContent_MakeAvailable(nlohmann_json)
# Suppress deprecated literal operator warnings from nlohmann_json
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-deprecated-literal-operator")
message(STATUS "zikzak_inappwebview_linux: nlohmann/json ${NLOHMANN_JSON_VERSION} configured")

# Plugin source files
list(APPEND PLUGIN_SOURCES
  "zikzak_inappwebview_linux_plugin.cc"
  "plugin_instance.cc"
  "cookie_manager.cc"
  "credential_database.cc"
  "proxy_manager.cc"
  "utils/software_rendering.cc"
  "web_storage_manager.cc"
  "webview_environment.cc"
  "content_blocker/content_blocker_handler.cc"
  "find_interaction/find_interaction_controller.cc"
  "find_interaction/find_interaction_channel_delegate.cc"
  "headless_in_app_webview/headless_in_app_webview.cc"
  "headless_in_app_webview/headless_in_app_webview_manager.cc"
  "headless_in_app_webview/headless_webview_channel_delegate.cc"
  "in_app_browser/in_app_browser.cc"
  "in_app_browser/in_app_browser_channel_delegate.cc"
  "in_app_browser/in_app_browser_manager.cc"
  "in_app_browser/in_app_browser_settings.cc"
  "in_app_webview/in_app_webview_manager.cc"
  "in_app_webview/custom_platform_view.cc"
  "in_app_webview/inappwebview_texture.cc"
  "in_app_webview/inappwebview_egl_texture.cc"
  "in_app_webview/in_app_webview.cc"
  "in_app_webview/in_app_webview_settings.cc"
  "in_app_webview/user_content_controller.cc"
  "in_app_webview/webview_channel_delegate.cc"
  "types/channel_delegate.cc"
  "types/client_cert_challenge.cc"
  "types/client_cert_response.cc"
  "types/content_world.cc"
  "types/context_menu_popup.cc"
  "types/create_window_action.cc"
  "types/custom_scheme_response.cc"
  "types/download_start_request.cc"
  "types/download_start_response.cc"
  "types/find_session.cc"
  "types/http_auth_response.cc"
  "types/http_authentication_challenge.cc"
  "types/javascript_handler_function_data.cc"
  "types/js_alert_request.cc"
  "types/js_alert_response.cc"
  "types/js_before_unload_response.cc"
  "types/js_confirm_request.cc"
  "types/js_confirm_response.cc"
  "types/js_prompt_request.cc"
  "types/js_prompt_response.cc"
  "types/hit_test_result.cc"
  "types/navigation_action.cc"
  "types/option_menu_popup.cc"
  "types/permission_request.cc"
  "types/permission_response.cc"
  "types/plugin_script.cc"
  "types/server_trust_auth_response.cc"
  "types/server_trust_challenge.cc"
  "types/show_file_chooser_response.cc"
  "types/ssl_certificate.cc"
  "types/url_credential.cc"
  "types/url_protection_space.cc"
  "types/url_request.cc"
  "types/user_script.cc"
  "types/web_resource_error.cc"
  "types/web_resource_request.cc"
  "types/web_resource_response.cc"
  "types/web_view_transport.cc"
  "web_message/web_message_channel.cc"
  "web_message/web_message_listener.cc"
  "web_message/web_message_listener_channel_delegate.cc"
)

# Define the plugin library target. Its name must not be changed (see comment
# on PLUGIN_NAME above).
add_library(${PLUGIN_NAME} SHARED
  ${PLUGIN_SOURCES}
)

# Apply a standard set of build settings that are configured in the
# application-level CMakeLists.txt. This can be removed for plugins that want
# full control over build settings.
apply_standard_settings(${PLUGIN_NAME})

# Symbols are hidden by default to reduce the chance of accidental conflicts
# between plugins. This should not be removed; any symbols that should be
# exported should be explicitly exported with the FLUTTER_PLUGIN_EXPORT macro.
set_target_properties(${PLUGIN_NAME} PROPERTIES
  CXX_VISIBILITY_PRESET hidden)
target_compile_definitions(${PLUGIN_NAME} PRIVATE FLUTTER_PLUGIN_IMPL)

# RUNPATH: $ORIGIN (the plugin's own directory) plus the WPE prefix lib dir
# (appended below), so no LD_LIBRARY_PATH or launcher script is needed.
set_target_properties(${PLUGIN_NAME} PROPERTIES
  INSTALL_RPATH "$ORIGIN"
  BUILD_RPATH "$ORIGIN"
  BUILD_WITH_INSTALL_RPATH TRUE)

# Source include directories and library dependencies
target_include_directories(${PLUGIN_NAME} INTERFACE
  "${CMAKE_CURRENT_SOURCE_DIR}/include")
target_include_directories(${PLUGIN_NAME} PRIVATE
  "${CMAKE_CURRENT_SOURCE_DIR}"
  ${EPOXY_INCLUDE_DIRS}
  ${WPE_WEBKIT_INCLUDE_DIRS})

target_link_libraries(${PLUGIN_NAME} PRIVATE flutter)
target_link_libraries(${PLUGIN_NAME} PRIVATE PkgConfig::GTK)
target_link_libraries(${PLUGIN_NAME} PRIVATE PkgConfig::EPOXY)
target_link_libraries(${PLUGIN_NAME} PRIVATE nlohmann_json::nlohmann_json)
target_link_libraries(${PLUGIN_NAME} PRIVATE PkgConfig::WPE_WEBKIT)

# When WPE comes from a non-system prefix, add its library directory to the
# plugin's runtime path, so the bundle runs without LD_LIBRARY_PATH, and pass
# it to the app's link as -rpath-link, so that link finds WPE's libraries.
pkg_get_variable(WPE_WEBKIT_LIBDIR wpe-webkit-2.0 libdir)
if(WPE_WEBKIT_LIBDIR AND NOT WPE_WEBKIT_LIBDIR MATCHES "^/usr/lib")
  set_property(TARGET ${PLUGIN_NAME} APPEND PROPERTY BUILD_RPATH "${WPE_WEBKIT_LIBDIR}")
  set_property(TARGET ${PLUGIN_NAME} APPEND PROPERTY INSTALL_RPATH "${WPE_WEBKIT_LIBDIR}")
  target_link_options(${PLUGIN_NAME} INTERFACE "LINKER:-rpath-link,${WPE_WEBKIT_LIBDIR}")
endif()
target_link_libraries(${PLUGIN_NAME} PRIVATE PkgConfig::LIBWPE)
target_link_libraries(${PLUGIN_NAME} PRIVATE PkgConfig::WAYLAND_SERVER)
target_link_libraries(${PLUGIN_NAME} PRIVATE PkgConfig::LIBSECRET)

# Link WPEPlatform if available (new API - default)
if(HAVE_WPE_PLATFORM)
  target_link_libraries(${PLUGIN_NAME} PRIVATE PkgConfig::WPE_PLATFORM)
  target_link_libraries(${PLUGIN_NAME} PRIVATE PkgConfig::WPE_PLATFORM_HEADLESS)
endif()

# Link WPEBackend-FDO if available (legacy fallback)
if(HAVE_WPE_FDO)
  target_link_libraries(${PLUGIN_NAME} PRIVATE PkgConfig::WPE_FDO)
endif()

# === Library Bundling ===
# WPE WebKit is deliberately not bundled: the plugin links against the WPE
# install (see the RUNPATH above) and WPE's helper processes load from there
# too. Shipping WPE with an app is out of scope (spec 017).
set(zikzak_inappwebview_linux_bundled_libraries
  ""
  PARENT_SCOPE
)

# === Tests ===
# These unit tests can be run from a terminal after building the example.

# Only enable test builds when building the example (which sets this variable)
# so that plugin clients aren't building the tests.
if (${include_${PROJECT_NAME}_tests})
if(${CMAKE_VERSION} VERSION_LESS "3.11.0")
message("Unit tests require CMake 3.11.0 or later")
else()
set(TEST_RUNNER "${PROJECT_NAME}_test")
enable_testing()

# Add the Google Test dependency.
include(FetchContent)
FetchContent_Declare(
  googletest
  URL https://github.com/google/googletest/archive/release-1.11.0.zip
  DOWNLOAD_EXTRACT_TIMESTAMP TRUE
)
# Prevent overriding the parent project's compiler/linker settings
set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
# Disable install commands for gtest so it doesn't end up in the bundle.
set(INSTALL_GTEST OFF CACHE BOOL "Disable installation of googletest" FORCE)

FetchContent_MakeAvailable(googletest)

# The plugin's exported API is not very useful for unit testing, so build the
# sources directly into the test binary rather than using the shared library.
add_executable(${TEST_RUNNER}
  test/zikzak_inappwebview_linux_plugin_test.cc
  test/log_test.cc
  ${PLUGIN_SOURCES}
)
apply_standard_settings(${TEST_RUNNER})
target_include_directories(${TEST_RUNNER} PRIVATE 
  "${CMAKE_CURRENT_SOURCE_DIR}" 
  ${EPOXY_INCLUDE_DIRS}
  ${WPE_WEBKIT_INCLUDE_DIRS})
target_link_libraries(${TEST_RUNNER} PRIVATE flutter)
target_link_libraries(${TEST_RUNNER} PRIVATE PkgConfig::GTK)
target_link_libraries(${TEST_RUNNER} PRIVATE PkgConfig::EPOXY)
target_link_libraries(${TEST_RUNNER} PRIVATE nlohmann_json::nlohmann_json)
target_link_libraries(${TEST_RUNNER} PRIVATE PkgConfig::WPE_WEBKIT)
target_link_libraries(${TEST_RUNNER} PRIVATE PkgConfig::LIBWPE)
target_link_libraries(${TEST_RUNNER} PRIVATE PkgConfig::WAYLAND_SERVER)
target_link_libraries(${TEST_RUNNER} PRIVATE PkgConfig::LIBSECRET)
if(HAVE_WPE_PLATFORM)
  target_link_libraries(${TEST_RUNNER} PRIVATE PkgConfig::WPE_PLATFORM)
  target_link_libraries(${TEST_RUNNER} PRIVATE PkgConfig::WPE_PLATFORM_HEADLESS)
endif()
if(HAVE_WPE_FDO)
  target_link_libraries(${TEST_RUNNER} PRIVATE PkgConfig::WPE_FDO)
endif()
target_link_libraries(${TEST_RUNNER} PRIVATE gtest_main gmock)

# Enable automatic test discovery.
include(GoogleTest)
gtest_discover_tests(${TEST_RUNNER})

endif()  # CMake version check
endif()  # include_${PROJECT_NAME}_tests
