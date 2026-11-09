#ifndef ZIKZAK_INAPPWEBVIEW_PLUGIN_HEADLESS_WEBVIEW_CHANNEL_DELEGATE_H_
#define ZIKZAK_INAPPWEBVIEW_PLUGIN_HEADLESS_WEBVIEW_CHANNEL_DELEGATE_H_

#include <flutter_linux/flutter_linux.h>

#include <memory>
#include <string>

#include "../types/channel_delegate.h"

namespace zikzak_inappwebview {

class HeadlessInAppWebView;

/**
 * Channel delegate for HeadlessInAppWebView.
 * Handles method calls specific to headless webview operations (dispose, setSize, getSize).
 * This mirrors the iOS HeadlessWebViewChannelDelegate pattern.
 */
class HeadlessWebViewChannelDelegate : public ChannelDelegate {
 public:
  static constexpr const char* METHOD_CHANNEL_NAME_PREFIX =
      "wtf.zikzak/flutter_headless_inappwebview_";

  HeadlessWebViewChannelDelegate(HeadlessInAppWebView* headlessWebView,
                                  FlBinaryMessenger* messenger,
                                  const std::string& id);
  ~HeadlessWebViewChannelDelegate() override;

  void HandleMethodCall(FlMethodCall* method_call) override;

  // === Events to send to Dart ===

  /**
   * Notify Dart that the headless webview has been created.
   */
  void onWebViewCreated() const;

 private:
  HeadlessInAppWebView* headlessWebView_ = nullptr;
};

}  // namespace zikzak_inappwebview

#endif  // ZIKZAK_INAPPWEBVIEW_PLUGIN_HEADLESS_WEBVIEW_CHANNEL_DELEGATE_H_
