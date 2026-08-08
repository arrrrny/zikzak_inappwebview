// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'js_alert_request.dart';

// **************************************************************************
// ExchangeableObjectGenerator
// **************************************************************************

///Class that represents the request of the [PlatformWebViewCreationParams.onJsAlert] event.
class JsAlertRequest {
  ///Indicates whether the request was made for the main frame.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- iOS
  ///- MacOS
  bool? isMainFrame;

  ///Message to be displayed in the window.
  String? message;

  ///The url of the page requesting the dialog.
  WebUri? url;
  JsAlertRequest({this.isMainFrame, this.message, this.url});

  ///Gets a possible [JsAlertRequest] instance from a [Map] value.
  static JsAlertRequest? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = JsAlertRequest(
      isMainFrame: map['isMainFrame'],
      message: map['message'],
      url: map['url'] != null ? WebUri(map['url']) : null,
    );
    return instance;
  }

  ///Converts instance to a map.
  Map<String, dynamic> toMap() {
    return {
      "isMainFrame": isMainFrame,
      "message": message,
      "url": url?.toString(),
    };
  }

  ///Converts instance to a map.
  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'JsAlertRequest{isMainFrame: $isMainFrame, message: $message, url: $url}';
  }
}
