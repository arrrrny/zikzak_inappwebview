#include <flutter_linux/flutter_linux.h>
#include <gtest/gtest.h>

#include <string>
#include <vector>

#include "utils/flutter.h"
#include "utils/log.h"

namespace zikzak_inappwebview {
namespace test {

namespace {

struct CapturedLog {
  GLogLevelFlags level;
  std::string message;
};

// Captures everything logged through g_message/g_warning (default domain)
// for the lifetime of the object.
class LogCapture {
 public:
  LogCapture() {
    handler_id_ = g_log_set_handler(nullptr,
                                    static_cast<GLogLevelFlags>(G_LOG_LEVEL_MASK | G_LOG_FLAG_FATAL |
                                                                G_LOG_FLAG_RECURSION),
                                    &LogCapture::Handler, this);
  }
  ~LogCapture() { g_log_remove_handler(nullptr, handler_id_); }

  const std::vector<CapturedLog>& logs() const { return logs_; }

 private:
  static void Handler(const gchar*, GLogLevelFlags level, const gchar* message, gpointer data) {
    static_cast<LogCapture*>(data)->logs_.push_back({level, message});
  }

  guint handler_id_ = 0;
  std::vector<CapturedLog> logs_;
};

// Restores the process-wide flag after each test.
class DebugLoggingTest : public ::testing::Test {
 protected:
  void SetUp() override { saved_ = isDebugLoggingEnabled(); }
  void TearDown() override { setDebugLoggingEnabled(saved_); }

 private:
  bool saved_ = false;
};

}  // namespace

TEST_F(DebugLoggingTest, InfoLogsAreSuppressedWhenDisabled) {
  setDebugLoggingEnabled(false);
  LogCapture capture;
  debugLog("info message");
  EXPECT_TRUE(capture.logs().empty());
}

TEST_F(DebugLoggingTest, InfoLogsArePrintedWhenEnabled) {
  setDebugLoggingEnabled(true);
  LogCapture capture;
  debugLog("info message");
  ASSERT_EQ(capture.logs().size(), 1u);
  EXPECT_EQ(capture.logs()[0].level & G_LOG_LEVEL_MASK, G_LOG_LEVEL_MESSAGE);
  // debugLog is a macro that inserts "file(line): " after the prefix.
  const std::string& message = capture.logs()[0].message;
  EXPECT_EQ(message.rfind("[zikzak_inappwebview] ", 0), 0u) << message;
  EXPECT_NE(message.find("info message"), std::string::npos) << message;
}

TEST_F(DebugLoggingTest, ErrorsArePrintedRegardlessOfTheFlag) {
  for (bool enabled : {false, true}) {
    setDebugLoggingEnabled(enabled);
    LogCapture capture;
    errorLog("error message");
    ASSERT_EQ(capture.logs().size(), 1u) << "enabled=" << enabled;
    EXPECT_EQ(capture.logs()[0].level & G_LOG_LEVEL_MASK, G_LOG_LEVEL_WARNING);
    EXPECT_NE(capture.logs()[0].message.find("error message"), std::string::npos);
  }
}

TEST_F(DebugLoggingTest, GErrorsArePrintedWhenDisabled) {
  setDebugLoggingEnabled(false);
  LogCapture capture;
  GError* error = g_error_new_literal(g_quark_from_static_string("test"), 7, "boom");
  EXPECT_TRUE(failedAndLog(&error));
  EXPECT_EQ(error, nullptr);
  ASSERT_EQ(capture.logs().size(), 1u);
  EXPECT_NE(capture.logs()[0].message.find("boom"), std::string::npos);
}

TEST_F(DebugLoggingTest, CreationArgumentsSetTheFlag) {
  for (bool enabled : {false, true}) {
    setDebugLoggingEnabled(!enabled);
    g_autoptr(FlValue) args = fl_value_new_map();
    fl_value_set_string_take(args, "debugLoggingEnabled", fl_value_new_bool(enabled));
    applyDebugLoggingSetting(args);
    EXPECT_EQ(isDebugLoggingEnabled(), enabled);
  }
}

TEST_F(DebugLoggingTest, CreationArgumentsWithoutTheKeyKeepTheFlag) {
  for (bool enabled : {false, true}) {
    setDebugLoggingEnabled(enabled);
    g_autoptr(FlValue) args = fl_value_new_map();
    applyDebugLoggingSetting(args);
    applyDebugLoggingSetting(nullptr);
    EXPECT_EQ(isDebugLoggingEnabled(), enabled);
  }
}

}  // namespace test
}  // namespace zikzak_inappwebview
