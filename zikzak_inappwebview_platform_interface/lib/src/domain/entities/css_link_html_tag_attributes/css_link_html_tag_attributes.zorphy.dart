// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'css_link_html_tag_attributes.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class CSSLinkHtmlTagAttributes {
  CSSLinkHtmlTagAttributes({
    String? this.id,
    String? this.media,
    CrossOrigin? this.crossOrigin,
    String? this.integrity,
    ReferrerPolicy? this.referrerPolicy,
    bool? this.disabled,
    bool? this.alternate,
    String? this.title,
  });

  factory CSSLinkHtmlTagAttributes.fromJson(Map<String, dynamic> json) =>
      _$CSSLinkHtmlTagAttributesFromJson(json);

  final String? id;

  final String? media;

  @JsonKey(toJson: _crossOriginToJson, fromJson: _crossOriginFromJson)
  final CrossOrigin? crossOrigin;

  final String? integrity;

  @JsonKey(toJson: _referrerPolicyToJson, fromJson: _referrerPolicyFromJson)
  final ReferrerPolicy? referrerPolicy;

  final bool? disabled;

  final bool? alternate;

  final String? title;

  CSSLinkHtmlTagAttributes copyWith({
    String? id,
    String? media,
    CrossOrigin? crossOrigin,
    String? integrity,
    ReferrerPolicy? referrerPolicy,
    bool? disabled,
    bool? alternate,
    String? title,
  }) {
    return CSSLinkHtmlTagAttributes(
      id: id ?? this.id,
      media: media ?? this.media,
      crossOrigin: crossOrigin ?? this.crossOrigin,
      integrity: integrity ?? this.integrity,
      referrerPolicy: referrerPolicy ?? this.referrerPolicy,
      disabled: disabled ?? this.disabled,
      alternate: alternate ?? this.alternate,
      title: title ?? this.title,
    );
  }

  CSSLinkHtmlTagAttributes copyWithCSSLinkHtmlTagAttributes({
    String? id,
    String? media,
    CrossOrigin? crossOrigin,
    String? integrity,
    ReferrerPolicy? referrerPolicy,
    bool? disabled,
    bool? alternate,
    String? title,
  }) {
    return copyWith(
      id: id,
      media: media,
      crossOrigin: crossOrigin,
      integrity: integrity,
      referrerPolicy: referrerPolicy,
      disabled: disabled,
      alternate: alternate,
      title: title,
    );
  }

  CSSLinkHtmlTagAttributes patchWithCSSLinkHtmlTagAttributes([
    CSSLinkHtmlTagAttributesPatch? patchInput,
  ]) {
    final _patcher = patchInput ?? CSSLinkHtmlTagAttributesPatch();
    final _patchMap = _patcher.patchMap;
    return CSSLinkHtmlTagAttributes(
      id: _patchMap.containsKey(CSSLinkHtmlTagAttributes$.id)
          ? ((_patchMap[CSSLinkHtmlTagAttributes$.id] is Function)
                    ? _patchMap[CSSLinkHtmlTagAttributes$.id](this.id)
                    : (_patchMap[CSSLinkHtmlTagAttributes$.id] is Patch)
                    ? _patchMap[CSSLinkHtmlTagAttributes$.id].applyTo(this.id)
                    : _patchMap[CSSLinkHtmlTagAttributes$.id])
                as String?
          : this.id,
      media: _patchMap.containsKey(CSSLinkHtmlTagAttributes$.media)
          ? ((_patchMap[CSSLinkHtmlTagAttributes$.media] is Function)
                    ? _patchMap[CSSLinkHtmlTagAttributes$.media](this.media)
                    : (_patchMap[CSSLinkHtmlTagAttributes$.media] is Patch)
                    ? _patchMap[CSSLinkHtmlTagAttributes$.media].applyTo(
                        this.media,
                      )
                    : _patchMap[CSSLinkHtmlTagAttributes$.media])
                as String?
          : this.media,
      crossOrigin: _patchMap.containsKey(CSSLinkHtmlTagAttributes$.crossOrigin)
          ? ((_patchMap[CSSLinkHtmlTagAttributes$.crossOrigin] is Function)
                    ? _patchMap[CSSLinkHtmlTagAttributes$.crossOrigin](
                        this.crossOrigin,
                      )
                    : (_patchMap[CSSLinkHtmlTagAttributes$.crossOrigin]
                          is Patch)
                    ? _patchMap[CSSLinkHtmlTagAttributes$.crossOrigin].applyTo(
                        this.crossOrigin,
                      )
                    : _patchMap[CSSLinkHtmlTagAttributes$.crossOrigin])
                as CrossOrigin?
          : this.crossOrigin,
      integrity: _patchMap.containsKey(CSSLinkHtmlTagAttributes$.integrity)
          ? ((_patchMap[CSSLinkHtmlTagAttributes$.integrity] is Function)
                    ? _patchMap[CSSLinkHtmlTagAttributes$.integrity](
                        this.integrity,
                      )
                    : (_patchMap[CSSLinkHtmlTagAttributes$.integrity] is Patch)
                    ? _patchMap[CSSLinkHtmlTagAttributes$.integrity].applyTo(
                        this.integrity,
                      )
                    : _patchMap[CSSLinkHtmlTagAttributes$.integrity])
                as String?
          : this.integrity,
      referrerPolicy:
          _patchMap.containsKey(CSSLinkHtmlTagAttributes$.referrerPolicy)
          ? ((_patchMap[CSSLinkHtmlTagAttributes$.referrerPolicy] is Function)
                    ? _patchMap[CSSLinkHtmlTagAttributes$.referrerPolicy](
                        this.referrerPolicy,
                      )
                    : (_patchMap[CSSLinkHtmlTagAttributes$.referrerPolicy]
                          is Patch)
                    ? _patchMap[CSSLinkHtmlTagAttributes$.referrerPolicy]
                          .applyTo(this.referrerPolicy)
                    : _patchMap[CSSLinkHtmlTagAttributes$.referrerPolicy])
                as ReferrerPolicy?
          : this.referrerPolicy,
      disabled: _patchMap.containsKey(CSSLinkHtmlTagAttributes$.disabled)
          ? ((_patchMap[CSSLinkHtmlTagAttributes$.disabled] is Function)
                    ? _patchMap[CSSLinkHtmlTagAttributes$.disabled](
                        this.disabled,
                      )
                    : (_patchMap[CSSLinkHtmlTagAttributes$.disabled] is Patch)
                    ? _patchMap[CSSLinkHtmlTagAttributes$.disabled].applyTo(
                        this.disabled,
                      )
                    : _patchMap[CSSLinkHtmlTagAttributes$.disabled])
                as bool?
          : this.disabled,
      alternate: _patchMap.containsKey(CSSLinkHtmlTagAttributes$.alternate)
          ? ((_patchMap[CSSLinkHtmlTagAttributes$.alternate] is Function)
                    ? _patchMap[CSSLinkHtmlTagAttributes$.alternate](
                        this.alternate,
                      )
                    : (_patchMap[CSSLinkHtmlTagAttributes$.alternate] is Patch)
                    ? _patchMap[CSSLinkHtmlTagAttributes$.alternate].applyTo(
                        this.alternate,
                      )
                    : _patchMap[CSSLinkHtmlTagAttributes$.alternate])
                as bool?
          : this.alternate,
      title: _patchMap.containsKey(CSSLinkHtmlTagAttributes$.title)
          ? ((_patchMap[CSSLinkHtmlTagAttributes$.title] is Function)
                    ? _patchMap[CSSLinkHtmlTagAttributes$.title](this.title)
                    : (_patchMap[CSSLinkHtmlTagAttributes$.title] is Patch)
                    ? _patchMap[CSSLinkHtmlTagAttributes$.title].applyTo(
                        this.title,
                      )
                    : _patchMap[CSSLinkHtmlTagAttributes$.title])
                as String?
          : this.title,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CSSLinkHtmlTagAttributes &&
        id == other.id &&
        media == other.media &&
        crossOrigin == other.crossOrigin &&
        integrity == other.integrity &&
        referrerPolicy == other.referrerPolicy &&
        disabled == other.disabled &&
        alternate == other.alternate &&
        title == other.title;
  }

  @override
  int get hashCode {
    return Object.hash(
      this.id,
      this.media,
      this.crossOrigin,
      this.integrity,
      this.referrerPolicy,
      this.disabled,
      this.alternate,
      this.title,
    );
  }

  @override
  String toString() {
    return 'CSSLinkHtmlTagAttributes(' +
        'id: ${id}' +
        ', ' +
        'media: ${media}' +
        ', ' +
        'crossOrigin: ${crossOrigin}' +
        ', ' +
        'integrity: ${integrity}' +
        ', ' +
        'referrerPolicy: ${referrerPolicy}' +
        ', ' +
        'disabled: ${disabled}' +
        ', ' +
        'alternate: ${alternate}' +
        ', ' +
        'title: ${title})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$CSSLinkHtmlTagAttributesToJson(this);
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

extension CSSLinkHtmlTagAttributesPropertyHelpers on CSSLinkHtmlTagAttributes {
  bool get hasId {
    return this.id?.isNotEmpty == true;
  }

  bool get noId {
    return this.id?.isEmpty ?? true;
  }

  String get idRequired {
    return this.id ?? (throw StateError('id is required but was null'));
  }

  bool get hasMedia {
    return this.media?.isNotEmpty == true;
  }

  bool get noMedia {
    return this.media?.isEmpty ?? true;
  }

  String get mediaRequired {
    return this.media ?? (throw StateError('media is required but was null'));
  }

  bool get hasCrossOrigin {
    return this.crossOrigin != null;
  }

  bool get noCrossOrigin {
    return this.crossOrigin == null;
  }

  CrossOrigin get crossOriginRequired {
    return this.crossOrigin ??
        (throw StateError('crossOrigin is required but was null'));
  }

  bool get isCrossOriginANONYMOUS {
    return this.crossOrigin == CrossOrigin.ANONYMOUS;
  }

  bool get isCrossOriginUSE_CREDENTIALS {
    return this.crossOrigin == CrossOrigin.USE_CREDENTIALS;
  }

  bool get hasIntegrity {
    return this.integrity?.isNotEmpty == true;
  }

  bool get noIntegrity {
    return this.integrity?.isEmpty ?? true;
  }

  String get integrityRequired {
    return this.integrity ??
        (throw StateError('integrity is required but was null'));
  }

  bool get hasReferrerPolicy {
    return this.referrerPolicy != null;
  }

  bool get noReferrerPolicy {
    return this.referrerPolicy == null;
  }

  ReferrerPolicy get referrerPolicyRequired {
    return this.referrerPolicy ??
        (throw StateError('referrerPolicy is required but was null'));
  }

  bool get isReferrerPolicyNO_REFERRER {
    return this.referrerPolicy == ReferrerPolicy.NO_REFERRER;
  }

  bool get isReferrerPolicyNO_REFERRER_WHEN_DOWNGRADE {
    return this.referrerPolicy == ReferrerPolicy.NO_REFERRER_WHEN_DOWNGRADE;
  }

  bool get isReferrerPolicyORIGIN {
    return this.referrerPolicy == ReferrerPolicy.ORIGIN;
  }

  bool get isReferrerPolicyORIGIN_WHEN_CROSS_ORIGIN {
    return this.referrerPolicy == ReferrerPolicy.ORIGIN_WHEN_CROSS_ORIGIN;
  }

  bool get isReferrerPolicySAME_ORIGIN {
    return this.referrerPolicy == ReferrerPolicy.SAME_ORIGIN;
  }

  bool get isReferrerPolicySTRICT_ORIGIN {
    return this.referrerPolicy == ReferrerPolicy.STRICT_ORIGIN;
  }

  bool get isReferrerPolicySTRICT_ORIGIN_WHEN_CROSS_ORIGIN {
    return this.referrerPolicy ==
        ReferrerPolicy.STRICT_ORIGIN_WHEN_CROSS_ORIGIN;
  }

  bool get isReferrerPolicyUNSAFE_URL {
    return this.referrerPolicy == ReferrerPolicy.UNSAFE_URL;
  }

  bool get hasDisabled {
    return this.disabled != null;
  }

  bool get noDisabled {
    return this.disabled == null;
  }

  bool get disabledRequired {
    return this.disabled ??
        (throw StateError('disabled is required but was null'));
  }

  bool get hasAlternate {
    return this.alternate != null;
  }

  bool get noAlternate {
    return this.alternate == null;
  }

  bool get alternateRequired {
    return this.alternate ??
        (throw StateError('alternate is required but was null'));
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
}

extension CSSLinkHtmlTagAttributesSerialization on CSSLinkHtmlTagAttributes {
  Map<String, dynamic> toJson() {
    return _$CSSLinkHtmlTagAttributesToJson(this);
  }
}

enum CSSLinkHtmlTagAttributes$ {
  id,
  media,
  crossOrigin,
  integrity,
  referrerPolicy,
  disabled,
  alternate,
  title,
}

class CSSLinkHtmlTagAttributesPatch
    extends PatchBase<CSSLinkHtmlTagAttributes, CSSLinkHtmlTagAttributes$> {
  CSSLinkHtmlTagAttributes applyTo(CSSLinkHtmlTagAttributes entity) {
    return entity.patchWithCSSLinkHtmlTagAttributes(this);
  }

  CSSLinkHtmlTagAttributesPatch withId(String? value) {
    patchMap[CSSLinkHtmlTagAttributes$.id] = value;
    return this;
  }

  CSSLinkHtmlTagAttributesPatch withMedia(String? value) {
    patchMap[CSSLinkHtmlTagAttributes$.media] = value;
    return this;
  }

  CSSLinkHtmlTagAttributesPatch withCrossOrigin(CrossOrigin? value) {
    patchMap[CSSLinkHtmlTagAttributes$.crossOrigin] = value;
    return this;
  }

  CSSLinkHtmlTagAttributesPatch withIntegrity(String? value) {
    patchMap[CSSLinkHtmlTagAttributes$.integrity] = value;
    return this;
  }

  CSSLinkHtmlTagAttributesPatch withReferrerPolicy(ReferrerPolicy? value) {
    patchMap[CSSLinkHtmlTagAttributes$.referrerPolicy] = value;
    return this;
  }

  CSSLinkHtmlTagAttributesPatch withDisabled(bool? value) {
    patchMap[CSSLinkHtmlTagAttributes$.disabled] = value;
    return this;
  }

  CSSLinkHtmlTagAttributesPatch withAlternate(bool? value) {
    patchMap[CSSLinkHtmlTagAttributes$.alternate] = value;
    return this;
  }

  CSSLinkHtmlTagAttributesPatch withTitle(String? value) {
    patchMap[CSSLinkHtmlTagAttributes$.title] = value;
    return this;
  }
}

/// Field descriptors for [CSSLinkHtmlTagAttributes] query construction
abstract final class CSSLinkHtmlTagAttributesFields {
  static const id = Field<CSSLinkHtmlTagAttributes, String?>('id', _$id);

  static const media = Field<CSSLinkHtmlTagAttributes, String?>(
    'media',
    _$media,
  );

  static const crossOrigin = Field<CSSLinkHtmlTagAttributes, CrossOrigin?>(
    'crossOrigin',
    _$crossOrigin,
  );

  static const integrity = Field<CSSLinkHtmlTagAttributes, String?>(
    'integrity',
    _$integrity,
  );

  static const referrerPolicy =
      Field<CSSLinkHtmlTagAttributes, ReferrerPolicy?>(
        'referrerPolicy',
        _$referrerPolicy,
      );

  static const disabled = Field<CSSLinkHtmlTagAttributes, bool?>(
    'disabled',
    _$disabled,
  );

  static const alternate = Field<CSSLinkHtmlTagAttributes, bool?>(
    'alternate',
    _$alternate,
  );

  static const title = Field<CSSLinkHtmlTagAttributes, String?>(
    'title',
    _$title,
  );

  static String? _$id(CSSLinkHtmlTagAttributes e) {
    return e.id;
  }

  static String? _$media(CSSLinkHtmlTagAttributes e) {
    return e.media;
  }

  static CrossOrigin? _$crossOrigin(CSSLinkHtmlTagAttributes e) {
    return e.crossOrigin;
  }

  static String? _$integrity(CSSLinkHtmlTagAttributes e) {
    return e.integrity;
  }

  static ReferrerPolicy? _$referrerPolicy(CSSLinkHtmlTagAttributes e) {
    return e.referrerPolicy;
  }

  static bool? _$disabled(CSSLinkHtmlTagAttributes e) {
    return e.disabled;
  }

  static bool? _$alternate(CSSLinkHtmlTagAttributes e) {
    return e.alternate;
  }

  static String? _$title(CSSLinkHtmlTagAttributes e) {
    return e.title;
  }
}

extension CSSLinkHtmlTagAttributesCompareE on CSSLinkHtmlTagAttributes {
  Map<String, dynamic> compareToCSSLinkHtmlTagAttributes(
    CSSLinkHtmlTagAttributes other,
  ) {
    final Map<String, dynamic> diff = {};

    if (id != other.id) {
      diff['id'] = () => other.id;
    }

    if (media != other.media) {
      diff['media'] = () => other.media;
    }

    if (crossOrigin != other.crossOrigin) {
      diff['crossOrigin'] = () => other.crossOrigin;
    }

    if (integrity != other.integrity) {
      diff['integrity'] = () => other.integrity;
    }

    if (referrerPolicy != other.referrerPolicy) {
      diff['referrerPolicy'] = () => other.referrerPolicy;
    }

    if (disabled != other.disabled) {
      diff['disabled'] = () => other.disabled;
    }

    if (alternate != other.alternate) {
      diff['alternate'] = () => other.alternate;
    }

    if (title != other.title) {
      diff['title'] = () => other.title;
    }
    return diff;
  }
}
