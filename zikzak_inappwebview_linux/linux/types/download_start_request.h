#ifndef ZIKZAK_INAPPWEBVIEW_PLUGIN_DOWNLOAD_START_REQUEST_H_
#define ZIKZAK_INAPPWEBVIEW_PLUGIN_DOWNLOAD_START_REQUEST_H_

#include <flutter_linux/flutter_linux.h>
#include <wpe/webkit.h>

#include <optional>
#include <string>

namespace zikzak_inappwebview {

class DownloadStartRequest {
 public:
  std::optional<std::string> url;
  std::optional<std::string> suggestedFilename;
  std::optional<std::string> mimeType;
  int64_t contentLength;
  std::optional<std::string> contentDisposition;
  std::optional<std::string> userAgent;

  DownloadStartRequest();
  DownloadStartRequest(WebKitDownload* download);
  ~DownloadStartRequest() = default;

  FlValue* toFlValue() const;
};

}  // namespace zikzak_inappwebview

#endif  // ZIKZAK_INAPPWEBVIEW_PLUGIN_DOWNLOAD_START_REQUEST_H_
