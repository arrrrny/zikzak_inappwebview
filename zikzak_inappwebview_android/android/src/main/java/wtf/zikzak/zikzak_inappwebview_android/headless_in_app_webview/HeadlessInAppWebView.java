package wtf.zikzak.zikzak_inappwebview_android.headless_in_app_webview;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import wtf.zikzak.zikzak_inappwebview_android.InAppWebViewFlutterPlugin;
import wtf.zikzak.zikzak_inappwebview_android.Util;
import wtf.zikzak.zikzak_inappwebview_android.types.Disposable;
import wtf.zikzak.zikzak_inappwebview_android.types.Size2D;
import wtf.zikzak.zikzak_inappwebview_android.webview.in_app_webview.FlutterWebView;

import java.util.Map;

import io.flutter.plugin.common.MethodChannel;

public class HeadlessInAppWebView implements Disposable {
  protected static final String LOG_TAG = "HeadlessInAppWebView";
  public static final String METHOD_CHANNEL_NAME_PREFIX = "wtf.zikzak/flutter_headless_inappwebview_";

  @NonNull
  public final String id;
  @Nullable
  public HeadlessWebViewChannelDelegate channelDelegate;
  @Nullable
  public FlutterWebView flutterWebView;
  @Nullable
  public InAppWebViewFlutterPlugin plugin;

  public HeadlessInAppWebView(@NonNull final InAppWebViewFlutterPlugin plugin, @NonNull String id, @NonNull FlutterWebView flutterWebView) {
    this.id = id;
    this.plugin = plugin;
    this.flutterWebView = flutterWebView;
    final MethodChannel channel = new MethodChannel(plugin.messenger, METHOD_CHANNEL_NAME_PREFIX + id);
    this.channelDelegate = new HeadlessWebViewChannelDelegate(this, channel);
  }

  public void onWebViewCreated() {
    if (channelDelegate != null) {
      channelDelegate.onWebViewCreated();
    }
  }

  public void prepare(Map<String, Object> params) {
    if (flutterWebView != null) {
      View view = flutterWebView.getView();
      if (view != null) {
        final Map<String, Object> initialSize = (Map<String, Object>) params.get("initialSize");
        Size2D size = Size2D.fromMap(initialSize);
        if (size == null) {
          size = new Size2D(-1, -1);
        }
        setSize(size);
        view.setVisibility(View.VISIBLE);
      }
    }
    if (plugin != null && plugin.headlessInAppWebViewManager != null) {
      // Host the headless WebView in the dedicated off-screen container
      // (issue #371 R3). It used to be added at index 0 of the activity's
      // content view — a child of the app's own Flutter hierarchy — so every
      // live headless instance rendered inside the app and competed for the
      // same navigation queue.
      Context context = plugin.activity != null ? plugin.activity : plugin.applicationContext;
      View view = flutterWebView != null ? flutterWebView.getView() : null;
      HeadlessWebViewContainer container = plugin.headlessInAppWebViewManager.container(context);
      if (container != null && view != null) {
        container.attach(view, view.getContext());
      }
    }
  }

  public void setSize(@NonNull Size2D size) {
    if (flutterWebView != null && flutterWebView.webView != null) {
      View view = flutterWebView.getView();
      if (view != null) {
        float scale = Util.getPixelDensity(view.getContext());
        Size2D fullscreenSize = Util.getFullscreenSize(view.getContext());
        int width = (int) (size.getWidth() == -1 ? fullscreenSize.getWidth() : (size.getWidth() * scale));
        int height = (int) (size.getWidth() == -1 ? fullscreenSize.getHeight() : (size.getHeight() * scale));
        view.setLayoutParams(new FrameLayout.LayoutParams(width, height));
      }
    }
  }

  @Nullable
  public Size2D getSize() {
    if (flutterWebView != null && flutterWebView.webView != null) {
      View view = flutterWebView.getView();
      if (view != null) {
        float scale = Util.getPixelDensity(view.getContext());
        Size2D fullscreenSize = Util.getFullscreenSize(view.getContext());
        ViewGroup.LayoutParams layoutParams = view.getLayoutParams();
        return new Size2D(
                fullscreenSize.getWidth() == layoutParams.width ? layoutParams.width : (layoutParams.width / scale),
                fullscreenSize.getHeight() == layoutParams.height ? layoutParams.height : (layoutParams.height / scale)
        );
      }
    }
    return null;
  }

  @Nullable
  public FlutterWebView disposeAndGetFlutterWebView() {
    FlutterWebView newFlutterWebView = flutterWebView;
    if (flutterWebView != null) {
      View view = flutterWebView.getView();
      if (view != null) {
        // restore WebView layout params and visibility
        view.setLayoutParams(new FrameLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT));
        view.setVisibility(View.VISIBLE);
        // remove from parent
        ViewGroup parent = (ViewGroup) view.getParent();
        if (parent != null) {
          parent.removeView(view);
        }
      }
      // set to null to avoid to be disposed before calling "dispose()"
      flutterWebView = null;
      dispose();
    }
    return newFlutterWebView;
  }

  public void dispose() {
    if (channelDelegate != null) {
      channelDelegate.dispose();
      channelDelegate = null;
    }
    if (plugin != null) {
      HeadlessInAppWebViewManager headlessInAppWebViewManager = plugin.headlessInAppWebViewManager;
      if (headlessInAppWebViewManager != null && headlessInAppWebViewManager.webViews.containsKey(id)) {
        headlessInAppWebViewManager.webViews.put(id, null);
      }
      // Detach from whichever container currently hosts the view (issue #371
      // R3: the dedicated off-screen container, never the activity content
      // view). Removing by parent keeps this correct for both paths.
      View view = flutterWebView != null ? flutterWebView.getView() : null;
      if (view != null && view.getParent() instanceof ViewGroup) {
        ((ViewGroup) view.getParent()).removeView(view);
      }
    }
    if (flutterWebView != null) {
      // Stop loading and remove user scripts before full dispose
      if (flutterWebView.webView != null) {
        flutterWebView.webView.stopLoading();
        flutterWebView.webView.getUserContentController().removeAllUserOnlyScripts();
        flutterWebView.webView.getUserContentController().removeAllPluginScripts();
      }
      flutterWebView.dispose();
    }
    flutterWebView = null;
    plugin = null;
  }
}
