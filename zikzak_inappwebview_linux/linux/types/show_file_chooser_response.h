#ifndef ZIKZAK_INAPPWEBVIEW_PLUGIN_SHOW_FILE_CHOOSER_RESPONSE_H_
#define ZIKZAK_INAPPWEBVIEW_PLUGIN_SHOW_FILE_CHOOSER_RESPONSE_H_

#include <flutter_linux/flutter_linux.h>

#include <optional>
#include <string>
#include <vector>

namespace zikzak_inappwebview {

class ShowFileChooserResponse {
 public:
  bool handledByClient;
  std::optional<std::vector<std::string>> filePaths;

  ShowFileChooserResponse();
  ShowFileChooserResponse(bool handledByClient,
                          std::optional<std::vector<std::string>> filePaths);
  ~ShowFileChooserResponse() = default;

  static ShowFileChooserResponse fromFlValue(FlValue* value);

  FlValue* toFlValue() const;
};

}  // namespace zikzak_inappwebview

#endif  // ZIKZAK_INAPPWEBVIEW_PLUGIN_SHOW_FILE_CHOOSER_RESPONSE_H_
