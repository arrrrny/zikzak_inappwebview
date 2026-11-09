#ifndef ZIKZAK_INAPPWEBVIEW_PLUGIN_JS_PROMPT_REQUEST_H_
#define ZIKZAK_INAPPWEBVIEW_PLUGIN_JS_PROMPT_REQUEST_H_

#include <flutter_linux/flutter_linux.h>

#include <optional>
#include <string>

namespace zikzak_inappwebview {

/**
 * Represents a JavaScript prompt() dialog request.
 */
class JsPromptRequest {
 public:
  std::optional<std::string> url;
  std::string message;
  std::optional<std::string> defaultValue;
  bool isMainFrame;

  JsPromptRequest(const std::optional<std::string>& url, const std::string& message,
                  const std::optional<std::string>& defaultValue, bool isMainFrame);
  ~JsPromptRequest() = default;

  FlValue* toFlValue() const;
};

}  // namespace zikzak_inappwebview

#endif  // ZIKZAK_INAPPWEBVIEW_PLUGIN_JS_PROMPT_REQUEST_H_
