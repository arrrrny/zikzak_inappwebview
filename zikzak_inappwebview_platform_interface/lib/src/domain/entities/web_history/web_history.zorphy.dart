// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'web_history.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class WebHistory {
  WebHistory({List<WebHistoryItem>? this.list, int? this.currentIndex});

  factory WebHistory.fromJson(Map<String, dynamic> json) =>
      _$WebHistoryFromJson(json);

  final List<WebHistoryItem>? list;

  final int? currentIndex;

  WebHistory copyWith({List<WebHistoryItem>? list, int? currentIndex}) {
    return WebHistory(
      list: list ?? this.list,
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }

  WebHistory copyWithWebHistory({
    List<WebHistoryItem>? list,
    int? currentIndex,
  }) {
    return copyWith(list: list, currentIndex: currentIndex);
  }

  WebHistory patchWithWebHistory([WebHistoryPatch? patchInput]) {
    final _patcher = patchInput ?? WebHistoryPatch();
    final _patchMap = _patcher.patchMap;
    return WebHistory(
      list: _patchMap.containsKey(WebHistory$.list)
          ? ((_patchMap[WebHistory$.list] is Function)
                    ? _patchMap[WebHistory$.list](this.list)
                    : (_patchMap[WebHistory$.list] is Patch)
                    ? _patchMap[WebHistory$.list].applyTo(this.list)
                    : _patchMap[WebHistory$.list])
                as List<WebHistoryItem>?
          : this.list,
      currentIndex: _patchMap.containsKey(WebHistory$.currentIndex)
          ? ((_patchMap[WebHistory$.currentIndex] is Function)
                    ? _patchMap[WebHistory$.currentIndex](this.currentIndex)
                    : (_patchMap[WebHistory$.currentIndex] is Patch)
                    ? _patchMap[WebHistory$.currentIndex].applyTo(
                        this.currentIndex,
                      )
                    : _patchMap[WebHistory$.currentIndex])
                as int?
          : this.currentIndex,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WebHistory &&
        list == other.list &&
        currentIndex == other.currentIndex;
  }

  @override
  int get hashCode {
    return Object.hash(this.list, this.currentIndex);
  }

  @override
  String toString() {
    return 'WebHistory(' +
        'list: ${list}' +
        ', ' +
        'currentIndex: ${currentIndex})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$WebHistoryToJson(this);
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

extension WebHistoryPropertyHelpers on WebHistory {
  List<WebHistoryItem> get listRequired {
    return this.list ?? (throw StateError('list is required but was null'));
  }

  bool get hasList {
    return this.list?.isNotEmpty ?? false;
  }

  bool get noList {
    return this.list?.isEmpty ?? true;
  }

  bool get hasCurrentIndex {
    return this.currentIndex != null;
  }

  bool get noCurrentIndex {
    return this.currentIndex == null;
  }

  int get currentIndexRequired {
    return this.currentIndex ??
        (throw StateError('currentIndex is required but was null'));
  }
}

extension WebHistorySerialization on WebHistory {
  Map<String, dynamic> toJson() {
    return _$WebHistoryToJson(this);
  }
}

enum WebHistory$ { list, currentIndex }

class WebHistoryPatch extends PatchBase<WebHistory, WebHistory$> {
  WebHistory applyTo(WebHistory entity) {
    return entity.patchWithWebHistory(this);
  }

  WebHistoryPatch withList(List<WebHistoryItem>? value) {
    patchMap[WebHistory$.list] = value;
    return this;
  }

  WebHistoryPatch updateListAt(
    int index,
    WebHistoryItemPatch Function(WebHistoryItemPatch) patch,
  ) {
    patchMap[WebHistory$.list] = (List<dynamic> list) {
      var updatedList = List<WebHistoryItem>.from(list);
      if (index >= 0 && index < updatedList.length) {
        updatedList[index] = patch(
          WebHistoryItemPatch(),
        ).applyTo(updatedList[index] as WebHistoryItem);
      }
      return updatedList;
    };
    return this;
  }

  WebHistoryPatch withCurrentIndex(int? value) {
    patchMap[WebHistory$.currentIndex] = value;
    return this;
  }
}

/// Field descriptors for [WebHistory] query construction
abstract final class WebHistoryFields {
  static const list = Field<WebHistory, List<WebHistoryItem>?>('list', _$list);

  static const currentIndex = Field<WebHistory, int?>(
    'currentIndex',
    _$currentIndex,
  );

  static List<WebHistoryItem>? _$list(WebHistory e) {
    return e.list;
  }

  static int? _$currentIndex(WebHistory e) {
    return e.currentIndex;
  }
}

extension WebHistoryCompareE on WebHistory {
  Map<String, dynamic> compareToWebHistory(WebHistory other) {
    final Map<String, dynamic> diff = {};

    if (list != other.list) {
      diff['list'] = () => other.list;
    }

    if (currentIndex != other.currentIndex) {
      diff['currentIndex'] = () => other.currentIndex;
    }
    return diff;
  }
}
