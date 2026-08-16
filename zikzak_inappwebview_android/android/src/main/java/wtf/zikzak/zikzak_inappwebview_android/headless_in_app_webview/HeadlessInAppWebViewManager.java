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

import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.Result;

public class HeadlessInAppWebViewManager extends ChannelDelegateImpl {
  protected static final String LOG_TAG = "HeadlessInAppWebViewManager";
  public static final String METHOD_CHANNEL_NAME = "wtf.zikzak/flutter_headless_inappwebview";

  public final Map<String, HeadlessInAppWebView> webViews = new HashMap<>();
  @Nullable
  public InAppWebViewFlutterPlugin plugin;

  public HeadlessInAppWebViewManager(final InAppWebViewFlutterPlugin plugin) {
    super(new MethodChannel(plugin.messenger, METHOD_CHANNEL_NAME));
    this.plugin = plugin;
  }

  @Override
  public void onMethodCall(final MethodCall call, @NonNull final Result result) {
    final String id = (String) call.argument("id");

    switch (call.method) {
      case "run":
        {
          HashMap<String, Object> params = (HashMap<String, Object>) call.argument("params");
          run(id, params, () -> result.success(true));
        }
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
    plugin = null;
  }
}
