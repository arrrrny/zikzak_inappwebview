// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'ssl_certificate_dname.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class SslCertificateDName {
  SslCertificateDName({
    String? CName,
    String? DName,
    String? OName,
    String? UName,
  }) : this.CName = CName ?? "",
       this.DName = DName ?? "",
       this.OName = OName ?? "",
       this.UName = UName ?? "";

  factory SslCertificateDName.fromJson(Map<String, dynamic> json) =>
      _$SslCertificateDNameFromJson(json);

  @JsonKey(defaultValue: "")
  final String? CName;

  @JsonKey(defaultValue: "")
  final String? DName;

  @JsonKey(defaultValue: "")
  final String? OName;

  @JsonKey(defaultValue: "")
  final String? UName;

  SslCertificateDName copyWith({
    String? CName,
    String? DName,
    String? OName,
    String? UName,
  }) {
    return SslCertificateDName(
      CName: CName ?? this.CName,
      DName: DName ?? this.DName,
      OName: OName ?? this.OName,
      UName: UName ?? this.UName,
    );
  }

  SslCertificateDName copyWithSslCertificateDName({
    String? CName,
    String? DName,
    String? OName,
    String? UName,
  }) {
    return copyWith(CName: CName, DName: DName, OName: OName, UName: UName);
  }

  SslCertificateDName patchWithSslCertificateDName([
    SslCertificateDNamePatch? patchInput,
  ]) {
    final _patcher = patchInput ?? SslCertificateDNamePatch();
    final _patchMap = _patcher.patchMap;
    return SslCertificateDName(
      CName: _patchMap.containsKey(SslCertificateDName$.CName)
          ? ((_patchMap[SslCertificateDName$.CName] is Function)
                    ? _patchMap[SslCertificateDName$.CName](this.CName)
                    : (_patchMap[SslCertificateDName$.CName] is Patch)
                    ? _patchMap[SslCertificateDName$.CName].applyTo(this.CName)
                    : _patchMap[SslCertificateDName$.CName])
                as String?
          : this.CName,
      DName: _patchMap.containsKey(SslCertificateDName$.DName)
          ? ((_patchMap[SslCertificateDName$.DName] is Function)
                    ? _patchMap[SslCertificateDName$.DName](this.DName)
                    : (_patchMap[SslCertificateDName$.DName] is Patch)
                    ? _patchMap[SslCertificateDName$.DName].applyTo(this.DName)
                    : _patchMap[SslCertificateDName$.DName])
                as String?
          : this.DName,
      OName: _patchMap.containsKey(SslCertificateDName$.OName)
          ? ((_patchMap[SslCertificateDName$.OName] is Function)
                    ? _patchMap[SslCertificateDName$.OName](this.OName)
                    : (_patchMap[SslCertificateDName$.OName] is Patch)
                    ? _patchMap[SslCertificateDName$.OName].applyTo(this.OName)
                    : _patchMap[SslCertificateDName$.OName])
                as String?
          : this.OName,
      UName: _patchMap.containsKey(SslCertificateDName$.UName)
          ? ((_patchMap[SslCertificateDName$.UName] is Function)
                    ? _patchMap[SslCertificateDName$.UName](this.UName)
                    : (_patchMap[SslCertificateDName$.UName] is Patch)
                    ? _patchMap[SslCertificateDName$.UName].applyTo(this.UName)
                    : _patchMap[SslCertificateDName$.UName])
                as String?
          : this.UName,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SslCertificateDName &&
        CName == other.CName &&
        DName == other.DName &&
        OName == other.OName &&
        UName == other.UName;
  }

  @override
  int get hashCode {
    return Object.hash(this.CName, this.DName, this.OName, this.UName);
  }

  @override
  String toString() {
    return 'SslCertificateDName(' +
        'CName: ${CName}' +
        ', ' +
        'DName: ${DName}' +
        ', ' +
        'OName: ${OName}' +
        ', ' +
        'UName: ${UName})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$SslCertificateDNameToJson(this);
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

extension SslCertificateDNamePropertyHelpers on SslCertificateDName {
  bool get hasCName {
    return this.CName?.isNotEmpty == true;
  }

  bool get noCName {
    return this.CName?.isEmpty ?? true;
  }

  String get CNameRequired {
    return this.CName ?? (throw StateError('CName is required but was null'));
  }

  bool get hasDName {
    return this.DName?.isNotEmpty == true;
  }

  bool get noDName {
    return this.DName?.isEmpty ?? true;
  }

  String get DNameRequired {
    return this.DName ?? (throw StateError('DName is required but was null'));
  }

  bool get hasOName {
    return this.OName?.isNotEmpty == true;
  }

  bool get noOName {
    return this.OName?.isEmpty ?? true;
  }

  String get ONameRequired {
    return this.OName ?? (throw StateError('OName is required but was null'));
  }

  bool get hasUName {
    return this.UName?.isNotEmpty == true;
  }

  bool get noUName {
    return this.UName?.isEmpty ?? true;
  }

  String get UNameRequired {
    return this.UName ?? (throw StateError('UName is required but was null'));
  }
}

extension SslCertificateDNameSerialization on SslCertificateDName {
  Map<String, dynamic> toJson() {
    return _$SslCertificateDNameToJson(this);
  }
}

enum SslCertificateDName$ { CName, DName, OName, UName }

class SslCertificateDNamePatch
    extends PatchBase<SslCertificateDName, SslCertificateDName$> {
  SslCertificateDName applyTo(SslCertificateDName entity) {
    return entity.patchWithSslCertificateDName(this);
  }

  SslCertificateDNamePatch withCName(String? value) {
    patchMap[SslCertificateDName$.CName] = value;
    return this;
  }

  SslCertificateDNamePatch withDName(String? value) {
    patchMap[SslCertificateDName$.DName] = value;
    return this;
  }

  SslCertificateDNamePatch withOName(String? value) {
    patchMap[SslCertificateDName$.OName] = value;
    return this;
  }

  SslCertificateDNamePatch withUName(String? value) {
    patchMap[SslCertificateDName$.UName] = value;
    return this;
  }
}

/// Field descriptors for [SslCertificateDName] query construction
abstract final class SslCertificateDNameFields {
  static const CName = Field<SslCertificateDName, String?>('CName', _$CName);

  static const DName = Field<SslCertificateDName, String?>('DName', _$DName);

  static const OName = Field<SslCertificateDName, String?>('OName', _$OName);

  static const UName = Field<SslCertificateDName, String?>('UName', _$UName);

  static String? _$CName(SslCertificateDName e) {
    return e.CName;
  }

  static String? _$DName(SslCertificateDName e) {
    return e.DName;
  }

  static String? _$OName(SslCertificateDName e) {
    return e.OName;
  }

  static String? _$UName(SslCertificateDName e) {
    return e.UName;
  }
}

extension SslCertificateDNameCompareE on SslCertificateDName {
  Map<String, dynamic> compareToSslCertificateDName(SslCertificateDName other) {
    final Map<String, dynamic> diff = {};

    if (CName != other.CName) {
      diff['CName'] = () => other.CName;
    }

    if (DName != other.DName) {
      diff['DName'] = () => other.DName;
    }

    if (OName != other.OName) {
      diff['OName'] = () => other.OName;
    }

    if (UName != other.UName) {
      diff['UName'] = () => other.UName;
    }
    return diff;
  }
}
