#ifndef ZIKZAK_INAPPWEBVIEW_PLUGIN_WEB_RESOURCE_ERROR_H_
#define ZIKZAK_INAPPWEBVIEW_PLUGIN_WEB_RESOURCE_ERROR_H_

#include <flutter_linux/flutter_linux.h>

#include <cstdint>
#include <string>

namespace zikzak_inappwebview {

class WebResourceError {
 public:
  const std::string description;
  const int64_t type;

  WebResourceError(const std::string& description, int64_t type);
  WebResourceError(FlValue* map);
  ~WebResourceError() = default;

  FlValue* toFlValue() const;
};

}  // namespace zikzak_inappwebview

#endif  // ZIKZAK_INAPPWEBVIEW_PLUGIN_WEB_RESOURCE_ERROR_H_
