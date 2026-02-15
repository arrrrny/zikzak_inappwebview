import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

///{@macro zikzak_inappwebview_platform_interface.PlatformChromeSafariBrowser}
class ChromeSafariBrowser implements PlatformChromeSafariBrowserEvents {
  /// Constructs a [ChromeSafariBrowser].
  ///
  /// {@macro zikzak_inappwebview_platform_interface.PlatformChromeSafariBrowser}
  ChromeSafariBrowser()
      : this.fromPlatformCreationParams(
          PlatformChromeSafariBrowserCreationParams(),
        );

  /// Constructs a [ChromeSafariBrowser] from creation params for a specific
  /// platform.
  ChromeSafariBrowser.fromPlatformCreationParams(
    PlatformChromeSafariBrowserCreationParams params,
  ) : this.fromPlatform(PlatformChromeSafariBrowser(params));

  /// Constructs a [ChromeSafariBrowser] from a specific platform
  /// implementation.
  ChromeSafariBrowser.fromPlatform(this.platform) {
    this.platform.eventHandler = this;
  }

  /// Implementation of [PlatformChromeSafariBrowser] for the current platform.
  final PlatformChromeSafariBrowser platform;

  ///{@macro zikzak_inappwebview_platform_interface.PlatformChromeSafariBrowser.id}
  String get id => platform.id;

  ///{@macro zikzak_inappwebview_platform_interface.PlatformChromeSafariBrowser.open}
  Future<void> open(
      {WebUri? url,
      Map<String, String>? headers,
      List<WebUri>? otherLikelyURLs,
      WebUri? referrer,
      ChromeSafariBrowserSettings? settings}) {
    this.platform.eventHandler = this;
    return platform.open(
        url: url,
        headers: headers,
        otherLikelyURLs: otherLikelyURLs,
        settings: settings);
  }

  ///{@macro zikzak_inappwebview_platform_interface.PlatformChromeSafariBrowser.launchUrl}
  Future<void> launchUrl({
    required WebUri url,
    Map<String, String>? headers,
    List<WebUri>? otherLikelyURLs,
    WebUri? referrer,
  }) =>
      platform.launchUrl(
          url: url,
          headers: headers,
          otherLikelyURLs: otherLikelyURLs,
          referrer: referrer);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformChromeSafariBrowser.mayLaunchUrl}
  Future<bool> mayLaunchUrl({WebUri? url, List<WebUri>? otherLikelyURLs}) =>
      platform.mayLaunchUrl(url: url, otherLikelyURLs: otherLikelyURLs);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformChromeSafariBrowser.validateRelationship}
  Future<bool> validateRelationship(
          {required CustomTabsRelationType relation, required WebUri origin}) =>
      platform.validateRelationship(relation: relation, origin: origin);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformChromeSafariBrowser.close}
  Future<void> close() => platform.close();

  ///{@macro zikzak_inappwebview_platform_interface.PlatformChromeSafariBrowser.isOpened}
  bool isOpened() => platform.isOpened();

  ///{@macro zikzak_inappwebview_platform_interface.PlatformChromeSafariBrowser.setActionButton}
  void setActionButton(ChromeSafariBrowserActionButton actionButton) =>
      platform.setActionButton(actionButton);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformChromeSafariBrowser.updateActionButton}
  Future<void> updateActionButton(
          {required Uint8List icon, required String description}) =>
      platform.updateActionButton(icon: icon, description: description);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformChromeSafariBrowser.setSecondaryToolbar}
  void setSecondaryToolbar(
          ChromeSafariBrowserSecondaryToolbar secondaryToolbar) =>
      platform.setSecondaryToolbar(secondaryToolbar);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformChromeSafariBrowser.updateSecondaryToolbar}
  Future<void> updateSecondaryToolbar(
          ChromeSafariBrowserSecondaryToolbar secondaryToolbar) =>
      platform.updateSecondaryToolbar(secondaryToolbar);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformChromeSafariBrowser.addMenuItem}
  void addMenuItem(ChromeSafariBrowserMenuItem menuItem) =>
      platform.addMenuItem(menuItem);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformChromeSafariBrowser.addMenuItems}
  void addMenuItems(List<ChromeSafariBrowserMenuItem> menuItems) =>
      platform.addMenuItems(menuItems);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformChromeSafariBrowser.requestPostMessageChannel}
  Future<bool> requestPostMessageChannel(
          {required WebUri sourceOrigin, WebUri? targetOrigin}) =>
      platform.requestPostMessageChannel(
          sourceOrigin: sourceOrigin, targetOrigin: targetOrigin);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformChromeSafariBrowser.postMessage}
  Future<CustomTabsPostMessageResultType> postMessage(String message) =>
      platform.postMessage(message);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformChromeSafariBrowser.isEngagementSignalsApiAvailable}
  Future<bool> isEngagementSignalsApiAvailable() =>
      platform.isEngagementSignalsApiAvailable();

  ///{@macro zikzak_inappwebview_platform_interface.PlatformChromeSafariBrowser.isAvailable}
  static Future<bool> isAvailable() =>
      PlatformChromeSafariBrowser.static().isAvailable();

  ///{@macro zikzak_inappwebview_platform_interface.PlatformChromeSafariBrowser.getMaxToolbarItems}
  static Future<int> getMaxToolbarItems() =>
      PlatformChromeSafariBrowser.static().getMaxToolbarItems();

  ///{@macro zikzak_inappwebview_platform_interface.PlatformChromeSafariBrowser.getPackageName}
  static Future<String?> getPackageName(
          {List<String>? packages, bool ignoreDefault = false}) =>
      PlatformChromeSafariBrowser.static()
          .getPackageName(packages: packages, ignoreDefault: ignoreDefault);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformChromeSafariBrowser.clearWebsiteData}
  static Future<void> clearWebsiteData() =>
      PlatformChromeSafariBrowser.static().clearWebsiteData();

  ///{@macro zikzak_inappwebview_platform_interface.PlatformChromeSafariBrowser.prewarmConnections}
  static Future<PrewarmingToken?> prewarmConnections(List<WebUri> URLs) =>
      PlatformChromeSafariBrowser.static().prewarmConnections(URLs);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformChromeSafariBrowser.invalidatePrewarmingToken}
  static Future<void> invalidatePrewarmingToken(
          PrewarmingToken prewarmingToken) =>
      PlatformChromeSafariBrowser.static()
          .invalidatePrewarmingToken(prewarmingToken);

  ///{@macro zikzak_inappwebview_platform_interface.PlatformChromeSafariBrowser.dispose}
  @mustCallSuper
  void dispose() => platform.dispose();

  @override
  void onClosed() {}

  @override
  void onCompletedInitialLoad(bool? didLoadSuccessfully) {}

  @override
  void onGreatestScrollPercentageIncreased(int scrollPercentage) {}

  @override
  void onInitialLoadDidRedirect(WebUri? url) {}

  @override
  void onMessageChannelReady() {}

  @override
  void onNavigationEvent(CustomTabsNavigationEventType? navigationEvent) {}

  @override
  void onOpened() {}

  @override
  void onPostMessage(String message) {}

  @override
  void onRelationshipValidationResult(
      CustomTabsRelationType? relation, WebUri? requestedOrigin, bool result) {}

  @override
  void onServiceConnected() {}

  @override
  void onSessionEnded(bool didUserInteract) {}

  @override
  void onVerticalScrollEvent(bool isDirectionUp) {}

  @override
  void onWillOpenInBrowser() {}
}
