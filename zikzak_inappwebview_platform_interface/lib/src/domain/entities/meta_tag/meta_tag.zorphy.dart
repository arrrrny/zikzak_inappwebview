// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'meta_tag.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class MetaTag {
  MetaTag({
    String? this.name,
    String? this.content,
    List<MetaTagAttribute>? this.attrs,
  });

  factory MetaTag.fromJson(Map<String, dynamic> json) =>
      _$MetaTagFromJson(json);

  final String? name;

  final String? content;

  final List<MetaTagAttribute>? attrs;

  MetaTag copyWith({
    String? name,
    String? content,
    List<MetaTagAttribute>? attrs,
  }) {
    return MetaTag(
      name: name ?? this.name,
      content: content ?? this.content,
      attrs: attrs ?? this.attrs,
    );
  }

  MetaTag copyWithMetaTag({
    String? name,
    String? content,
    List<MetaTagAttribute>? attrs,
  }) {
    return copyWith(name: name, content: content, attrs: attrs);
  }

  MetaTag patchWithMetaTag([MetaTagPatch? patchInput]) {
    final _patcher = patchInput ?? MetaTagPatch();
    final _patchMap = _patcher.patchMap;
    return MetaTag(
      name: _patchMap.containsKey(MetaTag$.name_)
          ? ((_patchMap[MetaTag$.name_] is Function)
                    ? _patchMap[MetaTag$.name_](this.name)
                    : (_patchMap[MetaTag$.name_] is Patch)
                    ? _patchMap[MetaTag$.name_].applyTo(this.name)
                    : _patchMap[MetaTag$.name_])
                as String?
          : this.name,
      content: _patchMap.containsKey(MetaTag$.content)
          ? ((_patchMap[MetaTag$.content] is Function)
                    ? _patchMap[MetaTag$.content](this.content)
                    : (_patchMap[MetaTag$.content] is Patch)
                    ? _patchMap[MetaTag$.content].applyTo(this.content)
                    : _patchMap[MetaTag$.content])
                as String?
          : this.content,
      attrs: _patchMap.containsKey(MetaTag$.attrs)
          ? ((_patchMap[MetaTag$.attrs] is Function)
                    ? _patchMap[MetaTag$.attrs](this.attrs)
                    : (_patchMap[MetaTag$.attrs] is Patch)
                    ? _patchMap[MetaTag$.attrs].applyTo(this.attrs)
                    : _patchMap[MetaTag$.attrs])
                as List<MetaTagAttribute>?
          : this.attrs,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MetaTag &&
        name == other.name &&
        content == other.content &&
        attrs == other.attrs;
  }

  @override
  int get hashCode {
    return Object.hash(this.name, this.content, this.attrs);
  }

  @override
  String toString() {
    return 'MetaTag(' +
        'name: ${name}' +
        ', ' +
        'content: ${content}' +
        ', ' +
        'attrs: ${attrs})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$MetaTagToJson(this);
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

extension MetaTagPropertyHelpers on MetaTag {
  bool get hasName {
    return this.name?.isNotEmpty == true;
  }

  bool get noName {
    return this.name?.isEmpty ?? true;
  }

  String get nameRequired {
    return this.name ?? (throw StateError('name is required but was null'));
  }

  bool get hasContent {
    return this.content?.isNotEmpty == true;
  }

  bool get noContent {
    return this.content?.isEmpty ?? true;
  }

  String get contentRequired {
    return this.content ??
        (throw StateError('content is required but was null'));
  }

  List<MetaTagAttribute> get attrsRequired {
    return this.attrs ?? (throw StateError('attrs is required but was null'));
  }

  bool get hasAttrs {
    return this.attrs?.isNotEmpty ?? false;
  }

  bool get noAttrs {
    return this.attrs?.isEmpty ?? true;
  }
}

extension MetaTagSerialization on MetaTag {
  Map<String, dynamic> toJson() {
    return _$MetaTagToJson(this);
  }
}

enum MetaTag$ { name_, content, attrs }

class MetaTagPatch extends PatchBase<MetaTag, MetaTag$> {
  MetaTag applyTo(MetaTag entity) {
    return entity.patchWithMetaTag(this);
  }

  MetaTagPatch withName(String? value) {
    patchMap[MetaTag$.name_] = value;
    return this;
  }

  MetaTagPatch withContent(String? value) {
    patchMap[MetaTag$.content] = value;
    return this;
  }

  MetaTagPatch withAttrs(List<MetaTagAttribute>? value) {
    patchMap[MetaTag$.attrs] = value;
    return this;
  }

  MetaTagPatch updateAttrsAt(
    int index,
    MetaTagAttributePatch Function(MetaTagAttributePatch) patch,
  ) {
    patchMap[MetaTag$.attrs] = (List<dynamic> list) {
      var updatedList = List<MetaTagAttribute>.from(list);
      if (index >= 0 && index < updatedList.length) {
        updatedList[index] = patch(
          MetaTagAttributePatch(),
        ).applyTo(updatedList[index] as MetaTagAttribute);
      }
      return updatedList;
    };
    return this;
  }
}

/// Field descriptors for [MetaTag] query construction
abstract final class MetaTagFields {
  static const name = Field<MetaTag, String?>('name', _$name);

  static const content = Field<MetaTag, String?>('content', _$content);

  static const attrs = Field<MetaTag, List<MetaTagAttribute>?>(
    'attrs',
    _$attrs,
  );

  static String? _$name(MetaTag e) {
    return e.name;
  }

  static String? _$content(MetaTag e) {
    return e.content;
  }

  static List<MetaTagAttribute>? _$attrs(MetaTag e) {
    return e.attrs;
  }
}

extension MetaTagCompareE on MetaTag {
  Map<String, dynamic> compareToMetaTag(MetaTag other) {
    final Map<String, dynamic> diff = {};

    if (name != other.name) {
      diff['name'] = () => other.name;
    }

    if (content != other.content) {
      diff['content'] = () => other.content;
    }

    if (attrs != other.attrs) {
      diff['attrs'] = () => other.attrs;
    }
    return diff;
  }
}
