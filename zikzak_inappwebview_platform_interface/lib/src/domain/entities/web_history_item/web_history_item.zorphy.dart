// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'web_history_item.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class WebHistoryItem {
  WebHistoryItem({
    WebUri? this.originalUrl,
    String? this.title,
    WebUri? this.url,
    int? this.index,
    int? this.offset,
    int? this.entryId,
  });

  factory WebHistoryItem.fromJson(Map<String, dynamic> json) =>
      _$WebHistoryItemFromJson(json);

  @JsonKey(toJson: _originalUrlToJson, fromJson: _originalUrlFromJson)
  final WebUri? originalUrl;

  final String? title;

  @JsonKey(toJson: _urlToJson, fromJson: _urlFromJson)
  final WebUri? url;

  final int? index;

  final int? offset;

  final int? entryId;

  WebHistoryItem copyWith({
    WebUri? originalUrl,
    String? title,
    WebUri? url,
    int? index,
    int? offset,
    int? entryId,
  }) {
    return WebHistoryItem(
      originalUrl: originalUrl ?? this.originalUrl,
      title: title ?? this.title,
      url: url ?? this.url,
      index: index ?? this.index,
      offset: offset ?? this.offset,
      entryId: entryId ?? this.entryId,
    );
  }

  WebHistoryItem copyWithWebHistoryItem({
    WebUri? originalUrl,
    String? title,
    WebUri? url,
    int? index,
    int? offset,
    int? entryId,
  }) {
    return copyWith(
      originalUrl: originalUrl,
      title: title,
      url: url,
      index: index,
      offset: offset,
      entryId: entryId,
    );
  }

  WebHistoryItem patchWithWebHistoryItem([WebHistoryItemPatch? patchInput]) {
    final _patcher = patchInput ?? WebHistoryItemPatch();
    final _patchMap = _patcher.patchMap;
    return WebHistoryItem(
      originalUrl: _patchMap.containsKey(WebHistoryItem$.originalUrl)
          ? ((_patchMap[WebHistoryItem$.originalUrl] is Function)
                    ? _patchMap[WebHistoryItem$.originalUrl](this.originalUrl)
                    : (_patchMap[WebHistoryItem$.originalUrl] is Patch)
                    ? _patchMap[WebHistoryItem$.originalUrl].applyTo(
                        this.originalUrl,
                      )
                    : _patchMap[WebHistoryItem$.originalUrl])
                as WebUri?
          : this.originalUrl,
      title: _patchMap.containsKey(WebHistoryItem$.title)
          ? ((_patchMap[WebHistoryItem$.title] is Function)
                    ? _patchMap[WebHistoryItem$.title](this.title)
                    : (_patchMap[WebHistoryItem$.title] is Patch)
                    ? _patchMap[WebHistoryItem$.title].applyTo(this.title)
                    : _patchMap[WebHistoryItem$.title])
                as String?
          : this.title,
      url: _patchMap.containsKey(WebHistoryItem$.url)
          ? ((_patchMap[WebHistoryItem$.url] is Function)
                    ? _patchMap[WebHistoryItem$.url](this.url)
                    : (_patchMap[WebHistoryItem$.url] is Patch)
                    ? _patchMap[WebHistoryItem$.url].applyTo(this.url)
                    : _patchMap[WebHistoryItem$.url])
                as WebUri?
          : this.url,
      index: _patchMap.containsKey(WebHistoryItem$.index_)
          ? ((_patchMap[WebHistoryItem$.index_] is Function)
                    ? _patchMap[WebHistoryItem$.index_](this.index)
                    : (_patchMap[WebHistoryItem$.index_] is Patch)
                    ? _patchMap[WebHistoryItem$.index_].applyTo(this.index)
                    : _patchMap[WebHistoryItem$.index_])
                as int?
          : this.index,
      offset: _patchMap.containsKey(WebHistoryItem$.offset)
          ? ((_patchMap[WebHistoryItem$.offset] is Function)
                    ? _patchMap[WebHistoryItem$.offset](this.offset)
                    : (_patchMap[WebHistoryItem$.offset] is Patch)
                    ? _patchMap[WebHistoryItem$.offset].applyTo(this.offset)
                    : _patchMap[WebHistoryItem$.offset])
                as int?
          : this.offset,
      entryId: _patchMap.containsKey(WebHistoryItem$.entryId)
          ? ((_patchMap[WebHistoryItem$.entryId] is Function)
                    ? _patchMap[WebHistoryItem$.entryId](this.entryId)
                    : (_patchMap[WebHistoryItem$.entryId] is Patch)
                    ? _patchMap[WebHistoryItem$.entryId].applyTo(this.entryId)
                    : _patchMap[WebHistoryItem$.entryId])
                as int?
          : this.entryId,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WebHistoryItem &&
        originalUrl == other.originalUrl &&
        title == other.title &&
        url == other.url &&
        index == other.index &&
        offset == other.offset &&
        entryId == other.entryId;
  }

  @override
  int get hashCode {
    return Object.hash(
      this.originalUrl,
      this.title,
      this.url,
      this.index,
      this.offset,
      this.entryId,
    );
  }

  @override
  String toString() {
    return 'WebHistoryItem(' +
        'originalUrl: ${originalUrl}' +
        ', ' +
        'title: ${title}' +
        ', ' +
        'url: ${url}' +
        ', ' +
        'index: ${index}' +
        ', ' +
        'offset: ${offset}' +
        ', ' +
        'entryId: ${entryId})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$WebHistoryItemToJson(this);
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

extension WebHistoryItemPropertyHelpers on WebHistoryItem {
  bool get hasOriginalUrl {
    return this.originalUrl != null;
  }

  bool get noOriginalUrl {
    return this.originalUrl == null;
  }

  WebUri get originalUrlRequired {
    return this.originalUrl ??
        (throw StateError('originalUrl is required but was null'));
  }

  bool get hasTitle {
    return this.title?.isNotEmpty == true;
  }

  bool get noTitle {
    return this.title?.isEmpty ?? true;
  }

  String get titleRequired {
    return this.title ?? (throw StateError('title is required but was null'));
  }

  bool get hasUrl {
    return this.url != null;
  }

  bool get noUrl {
    return this.url == null;
  }

  WebUri get urlRequired {
    return this.url ?? (throw StateError('url is required but was null'));
  }

  bool get hasIndex {
    return this.index != null;
  }

  bool get noIndex {
    return this.index == null;
  }

  int get indexRequired {
    return this.index ?? (throw StateError('index is required but was null'));
  }

  bool get hasOffset {
    return this.offset != null;
  }

  bool get noOffset {
    return this.offset == null;
  }

  int get offsetRequired {
    return this.offset ?? (throw StateError('offset is required but was null'));
  }

  bool get hasEntryId {
    return this.entryId != null;
  }

  bool get noEntryId {
    return this.entryId == null;
  }

  int get entryIdRequired {
    return this.entryId ??
        (throw StateError('entryId is required but was null'));
  }
}

extension WebHistoryItemSerialization on WebHistoryItem {
  Map<String, dynamic> toJson() {
    return _$WebHistoryItemToJson(this);
  }
}

enum WebHistoryItem$ { originalUrl, title, url, index_, offset, entryId }

class WebHistoryItemPatch extends PatchBase<WebHistoryItem, WebHistoryItem$> {
  WebHistoryItem applyTo(WebHistoryItem entity) {
    return entity.patchWithWebHistoryItem(this);
  }

  WebHistoryItemPatch withOriginalUrl(WebUri? value) {
    patchMap[WebHistoryItem$.originalUrl] = value;
    return this;
  }

  WebHistoryItemPatch withTitle(String? value) {
    patchMap[WebHistoryItem$.title] = value;
    return this;
  }

  WebHistoryItemPatch withUrl(WebUri? value) {
    patchMap[WebHistoryItem$.url] = value;
    return this;
  }

  WebHistoryItemPatch withIndex(int? value) {
    patchMap[WebHistoryItem$.index_] = value;
    return this;
  }

  WebHistoryItemPatch withOffset(int? value) {
    patchMap[WebHistoryItem$.offset] = value;
    return this;
  }

  WebHistoryItemPatch withEntryId(int? value) {
    patchMap[WebHistoryItem$.entryId] = value;
    return this;
  }
}

/// Field descriptors for [WebHistoryItem] query construction
abstract final class WebHistoryItemFields {
  static const originalUrl = Field<WebHistoryItem, WebUri?>(
    'originalUrl',
    _$originalUrl,
  );

  static const title = Field<WebHistoryItem, String?>('title', _$title);

  static const url = Field<WebHistoryItem, WebUri?>('url', _$url);

  static const index = Field<WebHistoryItem, int?>('index', _$index);

  static const offset = Field<WebHistoryItem, int?>('offset', _$offset);

  static const entryId = Field<WebHistoryItem, int?>('entryId', _$entryId);

  static WebUri? _$originalUrl(WebHistoryItem e) {
    return e.originalUrl;
  }

  static String? _$title(WebHistoryItem e) {
    return e.title;
  }

  static WebUri? _$url(WebHistoryItem e) {
    return e.url;
  }

  static int? _$index(WebHistoryItem e) {
    return e.index;
  }

  static int? _$offset(WebHistoryItem e) {
    return e.offset;
  }

  static int? _$entryId(WebHistoryItem e) {
    return e.entryId;
  }
}

extension WebHistoryItemCompareE on WebHistoryItem {
  Map<String, dynamic> compareToWebHistoryItem(WebHistoryItem other) {
    final Map<String, dynamic> diff = {};

    if (originalUrl != other.originalUrl) {
      diff['originalUrl'] = () => other.originalUrl;
    }

    if (title != other.title) {
      diff['title'] = () => other.title;
    }

    if (url != other.url) {
      diff['url'] = () => other.url;
    }

    if (index != other.index) {
      diff['index'] = () => other.index;
    }

    if (offset != other.offset) {
      diff['offset'] = () => other.offset;
    }

    if (entryId != other.entryId) {
      diff['entryId'] = () => other.entryId;
    }
    return diff;
  }
}
