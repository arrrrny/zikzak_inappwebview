#ifndef ZIKZAK_INAPPWEBVIEW_PLUGIN_JS_PROMPT_RESPONSE_H_
#define ZIKZAK_INAPPWEBVIEW_PLUGIN_JS_PROMPT_RESPONSE_H_

#include <flutter_linux/flutter_linux.h>

#include <optional>
#include <string>

namespace zikzak_inappwebview {

/**
 * Response action for JS prompt dialogs.
 */
enum class JsPromptResponseAction { CANCEL = 0, CONFIRM = 1 };

/**
 * Response to a JavaScript prompt() dialog.
 */
class JsPromptResponse {
 public:
  bool handledByClient;
  JsPromptResponseAction action;
  std::optional<std::string> value;

  JsPromptResponse();
  JsPromptResponse(FlValue* map);
  ~JsPromptResponse() = default;
};

}  // namespace zikzak_inappwebview

#endif  // ZIKZAK_INAPPWEBVIEW_PLUGIN_JS_PROMPT_RESPONSE_H_
