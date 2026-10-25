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

import android.app.Activity;
import android.content.Context;
import android.graphics.PixelFormat;
import android.util.DisplayMetrics;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.FrameLayout;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

/**
 * Dedicated off-screen host for headless WebViews (issue #371 R3).
 *
 * <p>A headless WebView used to be inserted at index 0 of the activity's content
 * view — i.e. a child of the app's own Flutter hierarchy. That gave it a real
 * window (needed for rendering and JavaScript) at the cost of making every live
 * headless instance part of the visible UI: a per-domain scraper ended up with
 * several WebViews rendering inside the app, each holding a renderer, and the
 * transport's own navigations stopped committing.
 *
 * <p>The container keeps the "real window" property and drops the "app window"
 * one: a {@link FrameLayout} of our own, added through the {@link WindowManager}
 * as a non-focusable, non-touchable window parked off-screen. This mirrors the
 * macOS implementation, which already hosts headless views in a dedicated
 * off-screen {@code NSWindow}.
 */
public class HeadlessWebViewContainer {
  private static final String LOG_TAG = "HeadlessWebViewContainer";

  @Nullable private final ViewGroup container;
  // Not final: the window binding is late (see attach). A container built from
  // `plugin.applicationContext` before an Activity is bound must be able to
  // pick up a WindowManager later, instead of freezing itself windowless for
  // the life of the process (issue #371 review).
  @Nullable private WindowManager windowManager;
  private int offscreenOffset;
  private boolean attached = false;

  public HeadlessWebViewContainer(@NonNull final Context context) {
    this.container = new FrameLayout(context);
    this.container.setVisibility(View.VISIBLE);

    if (context instanceof Activity) {
      this.windowManager = (WindowManager) context.getSystemService(Context.WINDOW_SERVICE);
      this.offscreenOffset = -context.getResources().getDisplayMetrics().widthPixels;
    } else {
      // No activity window to attach to yet (a headless run before the activity
      // is bound). The first attach() that receives an Activity context binds
      // the window; never throw here — the WebView itself must still be
      // created.
      this.windowManager = null;
      this.offscreenOffset = 0;
    }
  }

  /** Ensures {@code view} is hosted by the container. */
  public boolean attach(@NonNull final View view, @NonNull final Context context) {
    if (container == null) {
      return false;
    }
    if (view.getParent() == container) {
      return true;
    }

    ViewGroup parent = view.getParent() instanceof ViewGroup ? (ViewGroup) view.getParent() : null;
    if (parent != null) {
      parent.removeView(view);
    }
    container.addView(view);

    if (attached) {
      return attached;
    }
    if (windowManager == null && context instanceof Activity) {
      // Late bind. `prepare()` passes `plugin.applicationContext` whenever the
      // plugin has no Activity yet, which used to freeze the cached container
      // windowless for the whole process: every later headless WebView got a
      // FrameLayout in no window and `attach()` returned false (issue #371
      // review). The WebView's own context is the Activity's for a WebView
      // created from one, so this binds on the next attach after the Activity
      // exists.
      windowManager = (WindowManager) context.getSystemService(Context.WINDOW_SERVICE);
      offscreenOffset = -context.getResources().getDisplayMetrics().widthPixels;
    }
    if (windowManager == null) {
      return false;
    }

    try {
      windowManager.addView(container, buildLayoutParams(context));
      attached = true;
    } catch (RuntimeException e) {
      // A headless WebView must not take the app down because a window could
      // not be added; fall back to the detached container and report it.
      android.util.Log.e(LOG_TAG, "could not attach the headless WebView container", e);
    }
    return attached;
  }

  /** Removes {@code view} from the container, if it is hosted there. */
  public void detach(@NonNull final View view) {
    if (view.getParent() == container && container != null) {
      container.removeView(view);
    }
  }

  /** Releases the container window. Called when the plugin detaches. */
  public void dispose() {
    if (container != null) {
      container.removeAllViews();
    }
    if (attached && windowManager != null) {
      try {
        windowManager.removeView(container);
      } catch (RuntimeException e) {
        android.util.Log.e(LOG_TAG, "could not remove the headless WebView container", e);
      }
      attached = false;
    }
  }

  private WindowManager.LayoutParams buildLayoutParams(@NonNull final Context context) {
    final DisplayMetrics metrics = context.getResources().getDisplayMetrics();
    final WindowManager.LayoutParams params =
        new WindowManager.LayoutParams(
            metrics.widthPixels,
            metrics.heightPixels,
            WindowManager.LayoutParams.TYPE_APPLICATION,
            WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE
                | WindowManager.LayoutParams.FLAG_NOT_TOUCHABLE
                | WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL
                | WindowManager.LayoutParams.FLAG_LAYOUT_NO_LIMITS
                | WindowManager.LayoutParams.FLAG_HARDWARE_ACCELERATED,
            PixelFormat.TRANSLUCENT);
    params.gravity = Gravity.TOP | Gravity.START;
    params.x = offscreenOffset;
    params.y = 0;
    params.setTitle("zikzak headless WebView container");
    return params;
  }
}
