#ifndef ZIKZAK_INAPPWEBVIEW_PLUGIN_JS_BEFORE_UNLOAD_RESPONSE_H_
#define ZIKZAK_INAPPWEBVIEW_PLUGIN_JS_BEFORE_UNLOAD_RESPONSE_H_

#include <flutter_linux/flutter_linux.h>

#include <optional>
#include <string>

namespace zikzak_inappwebview {

/**
 * Response for beforeunload dialogs.
 */
class JsBeforeUnloadResponse {
 public:
  bool handledByClient;
  bool shouldAllowNavigation;
  std::optional<std::string> message;

  JsBeforeUnloadResponse();
  JsBeforeUnloadResponse(FlValue* map);
  ~JsBeforeUnloadResponse() = default;
};

}  // namespace zikzak_inappwebview

#endif  // ZIKZAK_INAPPWEBVIEW_PLUGIN_JS_BEFORE_UNLOAD_RESPONSE_H_
