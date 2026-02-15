import 'dart:ui';
import 'package:zikzak_inappwebview_internal_annotations/zikzak_inappwebview_internal_annotations.dart';

import '../types/attributed_string.dart';
import '../types/pull_to_refresh_size.dart';
import '../util.dart';
import '../types/main.dart';

part 'pull_to_refresh_settings.g.dart';

///Pull-To-Refresh Settings
@ExchangeableObject(copyMethod: true)
class PullToRefreshSettings_ {
  ///Sets whether the pull-to-refresh feature is enabled or not.
  ///The default value is `true`.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView
  ///- iOS
  bool? enabled;

  ///The color of the refresh control.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView
  ///- iOS
  Color_? color;

  ///The background color of the refresh control.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView
  ///- iOS
  Color_? backgroundColor;

  ///The distance to trigger a sync in dips.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView
  int? distanceToTriggerSync;

  ///The distance in pixels that the refresh indicator can be pulled beyond its resting position.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView
  int? slingshotDistance;

  ///The size of the refresh indicator.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView
  PullToRefreshSize_? size;

  ///The title text to display in the refresh control.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- iOS
  AttributedString_? attributedTitle;

  PullToRefreshSettings_(
      {this.enabled = true,
      this.color,
      this.backgroundColor,
      this.distanceToTriggerSync,
      this.slingshotDistance,
      this.size,
      this.attributedTitle});
}
