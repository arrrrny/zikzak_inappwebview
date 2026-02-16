import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

///{@macro zikzak_inappwebview_platform_interface.PlatformPullToRefreshController}
class PullToRefreshController {
  ///{@macro zikzak_inappwebview_platform_interface.PlatformPullToRefreshController}
  PullToRefreshController({
    void Function()? onRefresh,
    PullToRefreshSettings? settings,
  }) : this.fromPlatformCreationParams(
         params: PlatformPullToRefreshControllerCreationParams(
           onRefresh: onRefresh,
           settings: settings,
         ),
       );

  /// Constructs a [PullToRefreshController].
  ///
  /// See [PullToRefreshController.fromPlatformCreationParams] for setting parameters for
  /// a specific platform.
  PullToRefreshController.fromPlatformCreationParams({
    required PlatformPullToRefreshControllerCreationParams params,
  }) : this.fromPlatform(platform: PlatformPullToRefreshController(params));

  /// Constructs a [PullToRefreshController] from a specific platform implementation.
  PullToRefreshController.fromPlatform({required this.platform});

  /// Implementation of [PlatformPullToRefreshController] for the current platform.
  final PlatformPullToRefreshController platform;

  ///{@macro zikzak_inappwebview_platform_interface.PlatformPullToRefreshController.settings}
  PullToRefreshSettings? get settings => platform.settings;

  ///{@macro zikzak_inappwebview_platform_interface.PlatformPullToRefreshController.onRefresh}
  void Function()? get onRefresh => platform.onRefresh;

  ///{@macro zikzak_inappwebview_platform_interface.PlatformPullToRefreshController.setEnabled}
  Future<void> setEnabled(bool enabled) => platform.setEnabled(enabled);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformPullToRefreshController.isEnabled}
  Future<bool> isEnabled() => platform.isEnabled();

  ///{@macro zikzak_inappwebview_platform_interface.PlatformPullToRefreshController.beginRefreshing}
  Future<void> beginRefreshing() => platform.beginRefreshing();

  ///{@macro zikzak_inappwebview_platform_interface.PlatformPullToRefreshController.endRefreshing}
  Future<void> endRefreshing() => platform.endRefreshing();

  ///{@macro zikzak_inappwebview_platform_interface.PlatformPullToRefreshController.isRefreshing}
  Future<bool> isRefreshing() => platform.isRefreshing();

  ///{@macro zikzak_inappwebview_platform_interface.PlatformPullToRefreshController.setColor}
  Future<void> setColor(Color color) => platform.setColor(color);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformPullToRefreshController.setBackgroundColor}
  Future<void> setBackgroundColor(Color color) =>
      platform.setBackgroundColor(color);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformPullToRefreshController.setDistanceToTriggerSync}
  Future<void> setDistanceToTriggerSync(int distanceToTriggerSync) =>
      platform.setDistanceToTriggerSync(distanceToTriggerSync);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformPullToRefreshController.setSlingshotDistance}
  Future<void> setSlingshotDistance(int slingshotDistance) =>
      platform.setSlingshotDistance(slingshotDistance);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformPullToRefreshController.getDefaultSlingshotDistance}
  Future<int> getDefaultSlingshotDistance() =>
      platform.getDefaultSlingshotDistance();

  ///{@macro zikzak_inappwebview_platform_interface.PlatformPullToRefreshController.setIndicatorSize}
  Future<void> setIndicatorSize(PullToRefreshSize size) =>
      platform.setIndicatorSize(size);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformPullToRefreshController.setStyledTitle}
  Future<void> setStyledTitle(AttributedString attributedTitle) =>
      platform.setStyledTitle(attributedTitle);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformPullToRefreshController.dispose}
  void dispose({bool isKeepAlive = false}) =>
      platform.dispose(isKeepAlive: isKeepAlive);
}
