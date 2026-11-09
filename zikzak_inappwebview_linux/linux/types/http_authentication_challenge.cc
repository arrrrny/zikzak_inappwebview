#include "http_authentication_challenge.h"

#include "../utils/flutter.h"

namespace zikzak_inappwebview {

HttpAuthenticationChallenge::HttpAuthenticationChallenge(const URLProtectionSpace& protectionSpace,
                                                         bool isRetry)
    : protectionSpace(protectionSpace), isRetry(isRetry) {}

FlValue* HttpAuthenticationChallenge::toFlValue() const {
  return to_fl_map({
      {"protectionSpace", protectionSpace.toFlValue()},
      {"previousFailureCount", make_fl_value(previousFailureCount)},
      {"proposedCredential", make_fl_value()},
      {"failureResponse", make_fl_value()},
      {"error", make_fl_value()},
  });
}

}  // namespace zikzak_inappwebview
