import 'package:zorphy_annotation/zorphy_annotation.dart';

import '../../../types/content_world.dart';
import '../enums/user_script_injection_time.dart';
import '../platform_webview_feature/platform_webview_feature.dart';

part 'user_script.zorphy.dart';
part 'user_script.g.dart';

///Class that represents a script that the `WebView` injects into the web page.
@Zorphy(
  kind: ZorphyKind.valueObject,
  generateJson: true,
  generateCompareTo: true,
)
abstract class $UserScript {
  ///A set of matching rules for the allowed origins.
  ///
  ///**NOTE**: available only on Android and only if [WebViewFeature.DOCUMENT_START_SCRIPT] feature is supported.
  @JsonKey(defaultValue: {'*'})
  Set<String> get allowedOriginRules;

  ///A scope of execution in which to evaluate the script to prevent conflicts between different scripts.
  ///For more information about content worlds, see [ContentWorld].
  @JsonKey(fromJson: _contentWorldFromJson, toJson: _contentWorldToJson)
  ContentWorld? get contentWorld;

  ///A Boolean value that indicates whether to inject the script into the main frame.
  ///Specify true to inject the script only into the main frame, or false to inject it into all frames.
  ///The default value is `true`.
  ///
  ///**NOTE**: available only on iOS and MacOS.
  @JsonKey(defaultValue: true)
  bool get forMainFrameOnly;

  ///The script’s group name.
  String? get groupName;

  ///The time at which to inject the script into the `WebView`.
  @JsonKey(fromJson: _injectionTimeFromJson, toJson: _injectionTimeToJson)
  UserScriptInjectionTime get injectionTime;

  ///The script’s source code.
  String get source;
}

ContentWorld? _contentWorldFromJson(Object? value) => value == null
    ? ContentWorld.PAGE
    : ContentWorld.world(name: (value as Map)['name'] as String);

Object? _contentWorldToJson(ContentWorld? value) => value?.toMap();

UserScriptInjectionTime _injectionTimeFromJson(Object? value) =>
    UserScriptInjectionTime.values[value as int];

Object? _injectionTimeToJson(UserScriptInjectionTime value) => value.index;
