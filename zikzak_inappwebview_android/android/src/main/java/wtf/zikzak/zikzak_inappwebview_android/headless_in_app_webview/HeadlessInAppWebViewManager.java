/*
 *
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 *
 */

package wtf.zikzak.zikzak_inappwebview_android.headless_in_app_webview;

import android.content.Context;

import androidx.annotation.Nullable;
import androidx.annotation.NonNull;

import wtf.zikzak.zikzak_inappwebview_android.InAppWebViewFlutterPlugin;
import wtf.zikzak.zikzak_inappwebview_android.types.ChannelDelegateImpl;
import wtf.zikzak.zikzak_inappwebview_android.webview.in_app_webview.FlutterWebView;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.Result;

public class HeadlessInAppWebViewManager extends ChannelDelegateImpl {
  protected static final String LOG_TAG = "HeadlessInAppWebViewManager";
  public static final String METHOD_CHANNEL_NAME = "wtf.zikzak/flutter_headless_inappwebview";

  /**
   * Hard ceiling on live headless WebViews (issue #371 R4).
   *
   * <p>Every headless WebView owns a renderer and its own navigation queue, so a
   * per-domain scraper that creates one per host used to grow without bound.
   * Creating beyond the cap fails loudly instead of silently growing; the
   * Dart-side HeadlessWebViewRegistry uses the same platform cap and can evict
   * an idle instance before the ceiling is ever reached.
   */
  public static final int maxLiveWebViews = 3;

  public final Map<String, HeadlessInAppWebView> webViews = new HashMap<>();

  /** Live ids, oldest registration first — the cap's ordering. */
  private final List<String> liveIds = new ArrayList<>();

  @Nullable private HeadlessWebViewContainer container;

  @Nullable
  public InAppWebViewFlutterPlugin plugin;

  public HeadlessInAppWebViewManager(final InAppWebViewFlutterPlugin plugin) {
    super(new MethodChannel(plugin.messenger, METHOD_CHANNEL_NAME));
    this.plugin = plugin;
  }

  @Override
  public void onMethodCall(final MethodCall call, @NonNull final Result result) {
    final Object idArgument = call.argument("id");
    // Read the id defensively: an unchecked cast turned a missing argument into
    // a RuntimeException instead of a Flutter error (issue #371 R2).
    final String id = idArgument instanceof String ? (String) idArgument : null;

    switch (call.method) {
      case "run":
        {
          if (id == null) {
            result.error("headless_invalid_arguments", "id is null", null);
            return;
          }
          final Object paramsArgument = call.argument("params");
          if (!(paramsArgument instanceof Map)) {
            result.error("headless_invalid_arguments", "params is null", null);
            return;
          }
          pruneLiveIds();
          if (instance(id) == null && liveIds.size() >= maxLiveWebViews) {
            result.error(
                "headless_cap_exceeded",
                "headless WebView cap reached",
                maxLiveWebViews);
            return;
          }
          final HashMap<String, Object> params = (HashMap<String, Object>) paramsArgument;
          run(id, params, () -> result.success(true));
        }
        break;
      case "dispose":
        // The shared manager channel is the one dispose path (issue #371 R1):
        // it releases the instance, not only its map entry.
        if (id == null) {
          result.error("headless_invalid_arguments", "id is null", null);
          return;
        }
        dispose(id);
        result.success(true);
        break;
      default:
        result.notImplemented();
    }
  }

  public void run(String id, HashMap<String, Object> params, Runnable completion) {
    if (plugin == null || (plugin.activity == null && plugin.applicationContext == null)) {
      completion.run();
      return;
    }
    Context context = plugin.activity;
    if (context == null) {
      context = plugin.applicationContext;
    }
    FlutterWebView flutterWebView = new FlutterWebView(plugin, context, id, params);
    HeadlessInAppWebView headlessInAppWebView = new HeadlessInAppWebView(plugin, id, flutterWebView);
    webViews.put(id, headlessInAppWebView);
    track(id);

    headlessInAppWebView.prepare(params);
    headlessInAppWebView.onWebViewCreated();

    // Readiness gate: completes run() only after the initial navigation
    // reaches a terminal state (onPageFinished or a main-frame error). This
    // guarantees the webview / renderer is up before a consumer issues its
    // first real loadUrl. Signal-driven on purpose: no timeout constant — a
    // missing terminal event is a wiring bug that must surface loudly, not be
    // masked by a magic number.
    if (flutterWebView.webView == null) {
      completion.run();
      return;
    }
    // Nothing to wait for if no initial load was requested.
    if (params.get("initialUrlRequest") == null
        && params.get("initialFile") == null
        && params.get("initialData") == null) {
      completion.run();
      return;
    }
    final boolean[] gateFired = {false};
    flutterWebView.webView.firstNavigationCompleted = () -> {
      if (gateFired[0]) return;
      gateFired[0] = true;
      flutterWebView.webView.firstNavigationCompleted = null;
      completion.run();
    };

    flutterWebView.makeInitialLoad(params);
  }

  /** Releases one headless WebView: the instance is torn down and removed. */
  public void dispose(@NonNull final String id) {
    final HeadlessInAppWebView headlessInAppWebView = webViews.remove(id);
    liveIds.remove(id);
    if (headlessInAppWebView != null) {
      headlessInAppWebView.dispose();
    }
  }

  /**
   * The container headless views are hosted in, created on first use.
   *
   * @param context an activity context when one is bound — the container needs a
   *     window token to add its own window.
   */
  @Nullable
  public HeadlessWebViewContainer container(@Nullable final Context context) {
    if (container == null && context != null) {
      container = new HeadlessWebViewContainer(context);
    }
    return container;
  }

  @Override
  public void dispose() {
    super.dispose();
    Collection<HeadlessInAppWebView> headlessInAppWebViews = webViews.values();
    for (HeadlessInAppWebView headlessInAppWebView : headlessInAppWebViews) {
      if (headlessInAppWebView != null) {
        headlessInAppWebView.dispose();
      }
    }
    webViews.clear();
    liveIds.clear();
    if (container != null) {
      container.dispose();
      container = null;
    }
    plugin = null;
  }

  @Nullable
  private HeadlessInAppWebView instance(@NonNull final String id) {
    return webViews.get(id);
  }

  private void track(@NonNull final String id) {
    liveIds.remove(id);
    liveIds.add(id);
  }

  /**
   * Drops ids whose instance disposed itself through the per-instance channel,
   * so the cap counts live WebViews rather than dead entries.
   */
  private void pruneLiveIds() {
    liveIds.removeIf(id -> instance(id) == null);
  }
}
