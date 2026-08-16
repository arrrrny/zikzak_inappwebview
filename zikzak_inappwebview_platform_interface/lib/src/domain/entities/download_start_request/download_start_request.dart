import 'package:zorphy_annotation/zorphy_annotation.dart';

import '../../../web_uri.dart';

part 'download_start_request.zorphy.dart';
part 'download_start_request.g.dart';

///Class representing a download request of the WebView used by the event [PlatformWebViewCreationParams.onDownloadStartRequest].
@Zorphy(
  kind: ZorphyKind.valueObject,
  generateJson: true,
  generateCompareTo: true,
)
abstract class $DownloadStartRequest {
  ///The full url to the content that should be downloaded.
  @JsonKey(fromJson: _urlFromJson, toJson: _urlToJson)
  WebUri get url;
  ///the user agent to be used for the download.
  String? get userAgent;
  ///Content-disposition http header, if present.
  String? get contentDisposition;
  ///The mimetype of the content reported by the server.
  String? get mimeType;
  ///The file size reported by the server.
  int get contentLength;
  ///A suggested filename to use if saving the resource to disk.
  String? get suggestedFilename;
  ///The name of the text encoding of the receiver, or `null` if no text encoding was specified.
  String? get textEncodingName;
}
WebUri _urlFromJson(Object? value) => WebUri(value as String);

Object? _urlToJson(WebUri value) => value.toString();
