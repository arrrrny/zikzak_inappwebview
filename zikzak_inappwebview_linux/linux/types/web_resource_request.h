#ifndef ZIKZAK_INAPPWEBVIEW_PLUGIN_WEB_RESOURCE_REQUEST_H_
#define ZIKZAK_INAPPWEBVIEW_PLUGIN_WEB_RESOURCE_REQUEST_H_

#include <flutter_linux/flutter_linux.h>

#include <map>
#include <optional>
#include <string>

namespace zikzak_inappwebview {

class WebResourceRequest {
 public:
  std::optional<std::string> url;
  std::optional<std::string> method;
  std::optional<std::map<std::string, std::string>> headers;
  std::optional<bool> isForMainFrame;

  WebResourceRequest(const std::optional<std::string>& url,
                     const std::optional<std::string>& method,
                     const std::optional<std::map<std::string, std::string>>& headers,
                     const std::optional<bool>& isForMainFrame);
  WebResourceRequest(FlValue* map);
  ~WebResourceRequest() = default;

  FlValue* toFlValue() const;
};

}  // namespace zikzak_inappwebview

#endif  // ZIKZAK_INAPPWEBVIEW_PLUGIN_WEB_RESOURCE_REQUEST_H_
