import 'package:zorphy_annotation/zorphy_annotation.dart';

import '../../../web_uri.dart';

part 'in_app_webview_initial_data.zorphy.dart';
part 'in_app_webview_initial_data.g.dart';

///Initial [data] as a content for an `WebView` instance, using [baseUrl] as the base URL for it.
@Zorphy(
  kind: ZorphyKind.valueObject,
  generateJson: true,
  generateCompareTo: true,
)
abstract class $InAppWebViewInitialData {
  ///A String of data in the given encoding.
  String get data;

  ///The MIME type of the data, e.g. "text/html". The default value is `"text/html"`.
  @JsonKey(defaultValue: "text/html")
  String get mimeType;

  ///The encoding of the data. The default value is `"utf8"`.
  @JsonKey(defaultValue: "utf8")
  String get encoding;

  ///The URL to use as the page's base URL. If `null` defaults to `about:blank`.
  @JsonKey(fromJson: _baseUrlFromJson, toJson: _baseUrlToJson)
  WebUri? get baseUrl;

  ///The URL to use as the history entry. If `null` defaults to `about:blank`. If non-null, this must be a valid URL.
  @JsonKey(fromJson: _historyUrlFromJson, toJson: _historyUrlToJson)
  WebUri? get historyUrl;
}

WebUri? _baseUrlFromJson(Object? value) =>
    value == null ? null : WebUri(value as String);

Object? _baseUrlToJson(WebUri? value) => value?.toString();
WebUri? _historyUrlFromJson(Object? value) =>
    value == null ? null : WebUri(value as String);

Object? _historyUrlToJson(WebUri? value) => value?.toString();
