#ifndef ZIKZAK_INAPPWEBVIEW_PLUGIN_PERMISSION_RESPONSE_H_
#define ZIKZAK_INAPPWEBVIEW_PLUGIN_PERMISSION_RESPONSE_H_

#include <flutter_linux/flutter_linux.h>

#include <cstdint>
#include <vector>

namespace zikzak_inappwebview {

/**
 * Permission response actions.
 */
enum class PermissionResponseAction {
  DENY = 0,
  GRANT = 1,
  PROMPT = 2  // Not used on Linux - will default to deny
};

/**
 * Response to a permission request.
 */
class PermissionResponse {
 public:
  std::vector<int64_t> resources;
  PermissionResponseAction action;

  PermissionResponse();
  PermissionResponse(FlValue* map);
  ~PermissionResponse() = default;
};

}  // namespace zikzak_inappwebview

#endif  // ZIKZAK_INAPPWEBVIEW_PLUGIN_PERMISSION_RESPONSE_H_
