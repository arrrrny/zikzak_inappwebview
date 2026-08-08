// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'web_authenticate_session_settings.dart';

// **************************************************************************
// ExchangeableObjectGenerator
// **************************************************************************

///Class that represents the settings that can be used for a [PlatformWebAuthenticationSession].
class WebAuthenticationSessionSettings {
  ///A dictionary of additional HTTP headers to include in the authentication request.
  ///
  ///Set this property to include additional headers in all requests made by the authentication session.
  ///
  ///**NOTE for iOS**: Available only on iOS 17.4+.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- iOS
  Map<String, String>? additionalHeaderFields;

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
  ///- MacOS
  bool? prefersEphemeralWebBrowserSession;
  WebAuthenticationSessionSettings({
    this.additionalHeaderFields,
    this.prefersEphemeralWebBrowserSession = false,
  });

  ///Gets a possible [WebAuthenticationSessionSettings] instance from a [Map] value.
  static WebAuthenticationSessionSettings? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = WebAuthenticationSessionSettings(
      additionalHeaderFields: map['additionalHeaderFields']
          ?.cast<String, String>(),
    );
    instance.prefersEphemeralWebBrowserSession =
        map['prefersEphemeralWebBrowserSession'];
    return instance;
  }

  Map<String, dynamic> toMap() {
    return {
      "prefersEphemeralWebBrowserSession": prefersEphemeralWebBrowserSession,
      "additionalHeaderFields": additionalHeaderFields,
    };
  }

  ///Converts instance to a map.
  Map<String, dynamic> toJson() {
    return toMap();
  }

  ///Returns a copy of WebAuthenticationSessionSettings.
  WebAuthenticationSessionSettings copy() {
    return WebAuthenticationSessionSettings.fromMap(toMap()) ??
        WebAuthenticationSessionSettings();
  }

  @override
  String toString() {
    return 'WebAuthenticationSessionSettings{additionalHeaderFields: $additionalHeaderFields, prefersEphemeralWebBrowserSession: $prefersEphemeralWebBrowserSession}';
  }
}
