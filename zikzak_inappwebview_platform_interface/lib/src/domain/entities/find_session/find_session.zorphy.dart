// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'find_session.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class FindSession {
  FindSession({
    required int this.resultCount,
    required int this.highlightedResultIndex,
    required SearchResultDisplayStyle this.searchResultDisplayStyle,
  });

  factory FindSession.fromJson(Map<String, dynamic> json) =>
      _$FindSessionFromJson(json);

  final int resultCount;

  final int highlightedResultIndex;

  final SearchResultDisplayStyle searchResultDisplayStyle;

  FindSession copyWith({
    int? resultCount,
    int? highlightedResultIndex,
    SearchResultDisplayStyle? searchResultDisplayStyle,
  }) {
    return FindSession(
      resultCount: resultCount ?? this.resultCount,
      highlightedResultIndex:
          highlightedResultIndex ?? this.highlightedResultIndex,
      searchResultDisplayStyle:
          searchResultDisplayStyle ?? this.searchResultDisplayStyle,
    );
  }

  FindSession copyWithFindSession({
    int? resultCount,
    int? highlightedResultIndex,
    SearchResultDisplayStyle? searchResultDisplayStyle,
  }) {
    return copyWith(
      resultCount: resultCount,
      highlightedResultIndex: highlightedResultIndex,
      searchResultDisplayStyle: searchResultDisplayStyle,
    );
  }

  FindSession patchWithFindSession([FindSessionPatch? patchInput]) {
    final _patcher = patchInput ?? FindSessionPatch();
    final _patchMap = _patcher.patchMap;
    return FindSession(
      resultCount: _patchMap.containsKey(FindSession$.resultCount)
          ? ((_patchMap[FindSession$.resultCount] is Function)
                    ? _patchMap[FindSession$.resultCount](this.resultCount)
                    : (_patchMap[FindSession$.resultCount] is Patch)
                    ? _patchMap[FindSession$.resultCount].applyTo(
                        this.resultCount,
                      )
                    : _patchMap[FindSession$.resultCount])
                as int
          : this.resultCount,
      highlightedResultIndex:
          _patchMap.containsKey(FindSession$.highlightedResultIndex)
          ? ((_patchMap[FindSession$.highlightedResultIndex] is Function)
                    ? _patchMap[FindSession$.highlightedResultIndex](
                        this.highlightedResultIndex,
                      )
                    : (_patchMap[FindSession$.highlightedResultIndex] is Patch)
                    ? _patchMap[FindSession$.highlightedResultIndex].applyTo(
                        this.highlightedResultIndex,
                      )
                    : _patchMap[FindSession$.highlightedResultIndex])
                as int
          : this.highlightedResultIndex,
      searchResultDisplayStyle:
          _patchMap.containsKey(FindSession$.searchResultDisplayStyle)
          ? ((_patchMap[FindSession$.searchResultDisplayStyle] is Function)
                    ? _patchMap[FindSession$.searchResultDisplayStyle](
                        this.searchResultDisplayStyle,
                      )
                    : (_patchMap[FindSession$.searchResultDisplayStyle]
                          is Patch)
                    ? _patchMap[FindSession$.searchResultDisplayStyle].applyTo(
                        this.searchResultDisplayStyle,
                      )
                    : _patchMap[FindSession$.searchResultDisplayStyle])
                as SearchResultDisplayStyle
          : this.searchResultDisplayStyle,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FindSession &&
        resultCount == other.resultCount &&
        highlightedResultIndex == other.highlightedResultIndex &&
        searchResultDisplayStyle == other.searchResultDisplayStyle;
  }

  @override
  int get hashCode {
    return Object.hash(
      this.resultCount,
      this.highlightedResultIndex,
      this.searchResultDisplayStyle,
    );
  }

  @override
  String toString() {
    return 'FindSession(' +
        'resultCount: ${resultCount}' +
        ', ' +
        'highlightedResultIndex: ${highlightedResultIndex}' +
        ', ' +
        'searchResultDisplayStyle: ${searchResultDisplayStyle})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$FindSessionToJson(this);
    _sanitizeJson(data);
    return data;
  }

  dynamic _sanitizeJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      json.remove('__typename');
      return json..forEach((key, value) {
        json[key] = _sanitizeJson(value);
      });
    } else if (json is List) {
      return json.map((e) => _sanitizeJson(e)).toList();
    }
    return json;
  }
}

extension FindSessionPropertyHelpers on FindSession {
  bool get isSearchResultDisplayStyleCURRENT_AND_TOTAL {
    return this.searchResultDisplayStyle ==
        SearchResultDisplayStyle.CURRENT_AND_TOTAL;
  }

  bool get isSearchResultDisplayStyleTOTAL {
    return this.searchResultDisplayStyle == SearchResultDisplayStyle.TOTAL;
  }

  bool get isSearchResultDisplayStyleNONE {
    return this.searchResultDisplayStyle == SearchResultDisplayStyle.NONE;
  }
}

extension FindSessionSerialization on FindSession {
  Map<String, dynamic> toJson() {
    return _$FindSessionToJson(this);
  }
}

enum FindSession$ {
  resultCount,
  highlightedResultIndex,
  searchResultDisplayStyle,
}

class FindSessionPatch extends PatchBase<FindSession, FindSession$> {
  FindSession applyTo(FindSession entity) {
    return entity.patchWithFindSession(this);
  }

  FindSessionPatch withResultCount(int? value) {
    patchMap[FindSession$.resultCount] = value;
    return this;
  }

  FindSessionPatch withHighlightedResultIndex(int? value) {
    patchMap[FindSession$.highlightedResultIndex] = value;
    return this;
  }

  FindSessionPatch withSearchResultDisplayStyle(
    SearchResultDisplayStyle? value,
  ) {
    patchMap[FindSession$.searchResultDisplayStyle] = value;
    return this;
  }
}

/// Field descriptors for [FindSession] query construction
abstract final class FindSessionFields {
  static const resultCount = Field<FindSession, int>(
    'resultCount',
    _$resultCount,
  );

  static const highlightedResultIndex = Field<FindSession, int>(
    'highlightedResultIndex',
    _$highlightedResultIndex,
  );

  static const searchResultDisplayStyle =
      Field<FindSession, SearchResultDisplayStyle>(
        'searchResultDisplayStyle',
        _$searchResultDisplayStyle,
      );

  static int _$resultCount(FindSession e) {
    return e.resultCount;
  }

  static int _$highlightedResultIndex(FindSession e) {
    return e.highlightedResultIndex;
  }

  static SearchResultDisplayStyle _$searchResultDisplayStyle(FindSession e) {
    return e.searchResultDisplayStyle;
  }
}

extension FindSessionCompareE on FindSession {
  Map<String, dynamic> compareToFindSession(FindSession other) {
    final Map<String, dynamic> diff = {};

    if (resultCount != other.resultCount) {
      diff['resultCount'] = () => other.resultCount;
    }

    if (highlightedResultIndex != other.highlightedResultIndex) {
      diff['highlightedResultIndex'] = () => other.highlightedResultIndex;
    }

    if (searchResultDisplayStyle != other.searchResultDisplayStyle) {
      diff['searchResultDisplayStyle'] = () => other.searchResultDisplayStyle;
    }
    return diff;
  }
}
