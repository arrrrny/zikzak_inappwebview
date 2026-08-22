import 'package:zorphy_annotation/zorphy_annotation.dart';

import '../enums/search_result_display_style.dart';

part 'find_session.zorphy.dart';
part 'find_session.g.dart';

@Zorphy(
  kind: ZorphyKind.valueObject,
  generateJson: true,
  generateCompareTo: true,
)
abstract class $FindSession {
  ///Returns the total number of results.
  int get resultCount;

  ///Returns the index of the currently highlighted result.
  ///If no result is currently highlighted.
  int get highlightedResultIndex;

  ///Defines how results are reported through the find panel's UI.
  SearchResultDisplayStyle get searchResultDisplayStyle;
}

SearchResultDisplayStyle _searchResultDisplayStyleFromJson(Object? value) =>
    searchResultDisplayStyleFromWire(value) ??
    SearchResultDisplayStyle.values.first;

Object? _searchResultDisplayStyleToJson(SearchResultDisplayStyle value) =>
    searchResultDisplayStyleToWire(value);
