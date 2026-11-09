#ifndef ZIKZAK_INAPPWEBVIEW_PLUGIN_FIND_SESSION_H_
#define ZIKZAK_INAPPWEBVIEW_PLUGIN_FIND_SESSION_H_

#include <flutter_linux/flutter_linux.h>
#include <string>

namespace zikzak_inappwebview {

class FindSession {
 public:
  int resultCount;
  int highlightedResultIndex;

  FindSession(int resultCount, int highlightedResultIndex);
  explicit FindSession(FlValue* value);
  ~FindSession() = default;

  FlValue* toFlValue() const;
};

}  // namespace zikzak_inappwebview

#endif  // ZIKZAK_INAPPWEBVIEW_PLUGIN_FIND_SESSION_H_
