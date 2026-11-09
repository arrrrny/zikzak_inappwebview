#ifndef ZIKZAK_INAPPWEBVIEW_PLUGIN_JS_ALERT_REQUEST_H_
#define ZIKZAK_INAPPWEBVIEW_PLUGIN_JS_ALERT_REQUEST_H_

#include <flutter_linux/flutter_linux.h>

#include <optional>
#include <string>

namespace zikzak_inappwebview {

/**
 * Represents a JavaScript alert() dialog request.
 */
class JsAlertRequest {
 public:
  std::optional<std::string> url;
  std::string message;
  bool isMainFrame;

  JsAlertRequest(const std::optional<std::string>& url, const std::string& message,
                 bool isMainFrame);
  ~JsAlertRequest() = default;

  FlValue* toFlValue() const;
};

}  // namespace zikzak_inappwebview

#endif  // ZIKZAK_INAPPWEBVIEW_PLUGIN_JS_ALERT_REQUEST_H_
