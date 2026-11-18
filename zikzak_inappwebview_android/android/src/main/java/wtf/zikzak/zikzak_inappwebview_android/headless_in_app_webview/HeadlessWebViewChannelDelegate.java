package wtf.zikzak.zikzak_inappwebview_android.headless_in_app_webview;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import wtf.zikzak.zikzak_inappwebview_android.types.ChannelDelegateImpl;
import wtf.zikzak.zikzak_inappwebview_android.types.Size2D;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class HeadlessWebViewChannelDelegate extends ChannelDelegateImpl {
  @Nullable
  private HeadlessInAppWebView headlessWebView;

  public HeadlessWebViewChannelDelegate(@NonNull HeadlessInAppWebView headlessWebView, @NonNull MethodChannel channel) {
    super(channel);
    this.headlessWebView = headlessWebView;
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
    // Touch the LRU clock: this instance just received a per-instance call,
    // so a later eviction recycles the least-recently-used id rather than the
    // longest-lived one (issue #371 review).
    if (headlessWebView != null && headlessWebView.plugin != null
        && headlessWebView.plugin.headlessInAppWebViewManager != null) {
      headlessWebView.plugin.headlessInAppWebViewManager.touch(headlessWebView.id);
    }
    switch (call.method) {
      case "dispose":
        if (headlessWebView != null) {
          headlessWebView.dispose();
          result.success(true);
        } else {
          result.success(false);
        }
        break;
      case "setSize":
        if (headlessWebView != null) {
          Map<String, Object> sizeMap = (Map<String, Object>) call.argument("size");
          Size2D size = Size2D.fromMap(sizeMap);
          if (size != null)
            headlessWebView.setSize(size);
          result.success(true);
        } else {
          result.success(false);
        }
      break;
      case "getSize":
        if (headlessWebView != null) {
          Size2D size = headlessWebView.getSize();
          result.success(size != null ? size.toMap() : null);
        } else {
          result.success(null);
        }
      break;
      default:
        result.notImplemented();
    }
  }

  public void onWebViewCreated() {
    MethodChannel channel = getChannel();
    if (channel == null) return;
    Map<String, Object> obj = new HashMap<>();
    channel.invokeMethod("onWebViewCreated", obj);
  }

  /**
   * Notifies the Dart owner that the native manager evicted this instance to
   * stay under the live-instance cap (issue #371). Invoked BEFORE the handler
   * is cleared so the per-instance channel is still routed.
   */
  public void onEvicted() {
    MethodChannel channel = getChannel();
    if (channel == null) return;
    Map<String, Object> obj = new HashMap<>();
    channel.invokeMethod("onEvicted", obj);
  }

  @Override
  public void dispose() {
    super.dispose();
    headlessWebView = null;
  }
}
