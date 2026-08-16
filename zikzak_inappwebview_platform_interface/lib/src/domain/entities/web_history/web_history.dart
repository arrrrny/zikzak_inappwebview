import 'package:zorphy_annotation/zorphy_annotation.dart';

import '../web_history_item/web_history_item.dart';

part 'web_history.zorphy.dart';
part 'web_history.g.dart';

///This class contains a snapshot of the current back/forward list for a `WebView`.
@Zorphy(
  kind: ZorphyKind.valueObject,
  generateJson: true,
  generateCompareTo: true,
)
abstract class $WebHistory {
  ///List of all [WebHistoryItem]s.
  List<WebHistoryItem>? get list;
  ///Index of the current [WebHistoryItem].
  int? get currentIndex;
}
