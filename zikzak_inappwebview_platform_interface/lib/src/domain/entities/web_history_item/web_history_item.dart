import 'package:zorphy_annotation/zorphy_annotation.dart';

import '../../../web_uri.dart';
import '../web_history/web_history.dart';

part 'web_history_item.zorphy.dart';
part 'web_history_item.g.dart';

///A convenience class for accessing fields in an entry in the back/forward list of a `WebView`.
///Each [WebHistoryItem] is a snapshot of the requested history item.
@Zorphy(
  kind: ZorphyKind.valueObject,
  generateJson: true,
  generateCompareTo: true,
)
abstract class $WebHistoryItem {
  ///Original url of this history item.
  @JsonKey(fromJson: _originalUrlFromJson, toJson: _originalUrlToJson)
  WebUri? get originalUrl;
  ///Document title of this history item.
  String? get title;
  ///Url of this history item.
  @JsonKey(fromJson: _urlFromJson, toJson: _urlToJson)
  WebUri? get url;
  ///0-based position index in the back-forward [WebHistory.list].
  int? get index;
  ///Position offset respect to the currentIndex of the back-forward [WebHistory.list].
  int? get offset;
  ///Unique id of the navigation history entry.
  int? get entryId;
}
WebUri? _originalUrlFromJson(Object? value) =>
    value == null ? null : WebUri(value as String);

Object? _originalUrlToJson(WebUri? value) => value?.toString();
WebUri? _urlFromJson(Object? value) =>
    value == null ? null : WebUri(value as String);

Object? _urlToJson(WebUri? value) => value?.toString();
