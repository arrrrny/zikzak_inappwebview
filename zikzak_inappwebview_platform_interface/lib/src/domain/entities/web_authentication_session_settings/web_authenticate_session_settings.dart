// Migrated from @ExchangeableObject codegen by zorphy_migrator — hand-written
// entity (the migrator flagged the hand-written toMap as manual): the custom
// toMap is replicated by the generated toJson; fork default preserved.

import 'package:zorphy_annotation/zorphy_annotation.dart';
import '../../../web_authentication_session/platform_web_authenticate_session.dart';

part 'web_authenticate_session_settings.zorphy.dart';
part 'web_authenticate_session_settings.g.dart';

///Class that contains the settings for a Web Authentication session.
@Zorphy(
  kind: ZorphyKind.valueObject,
  generateJson: true,
  generateCompareTo: true,
)
abstract class $WebAuthenticationSessionSettings {
  ///A Boolean value that indicates whether the session should ask the browser for a private authentication session.
  ///
  ///Set [prefersEphemeralWebBrowserSession] to `true` to request that the browser
  ///doesn’t share cookies or other browsing data between the authentication session and the user’s normal browser session.
  ///Whether the request is honored depends on the user’s default web browser.
  ///Safari always honors the request.
  ///
  ///The value of this property is `false` by default.
  ///
  ///Set this property before you call [PlatformWebAuthenticationSession.start]. Otherwise it has no effect.
  ///
  ///**NOTE for iOS**: Available only on iOS 13.0+.
  ///
  ///**NOTE for MacOS**: Available only on iOS 10.15+.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- iOS
  @JsonKey(defaultValue: false)
  bool? get prefersEphemeralWebBrowserSession;

  ///Additional header fields to send with the authentication request.
  @JsonKey(
    fromJson: _additionalHeaderFieldsFromJson,
    toJson: _additionalHeaderFieldsToJson,
  )
  Map<String, String>? get additionalHeaderFields;
}

Map<String, String>? _additionalHeaderFieldsFromJson(Object? value) =>
    value == null ? null : (value as Map).cast<String, String>();

Object? _additionalHeaderFieldsToJson(Map<String, String>? headerFields) =>
    headerFields;
