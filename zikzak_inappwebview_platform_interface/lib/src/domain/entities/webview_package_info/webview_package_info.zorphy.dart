// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'webview_package_info.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class WebViewPackageInfo {
  WebViewPackageInfo({String? this.versionName, String? this.packageName});

  factory WebViewPackageInfo.fromJson(Map<String, dynamic> json) =>
      _$WebViewPackageInfoFromJson(json);

  final String? versionName;

  final String? packageName;

  WebViewPackageInfo copyWith({String? versionName, String? packageName}) {
    return WebViewPackageInfo(
      versionName: versionName ?? this.versionName,
      packageName: packageName ?? this.packageName,
    );
  }

  WebViewPackageInfo copyWithWebViewPackageInfo({
    String? versionName,
    String? packageName,
  }) {
    return copyWith(versionName: versionName, packageName: packageName);
  }

  WebViewPackageInfo patchWithWebViewPackageInfo([
    WebViewPackageInfoPatch? patchInput,
  ]) {
    final _patcher = patchInput ?? WebViewPackageInfoPatch();
    final _patchMap = _patcher.patchMap;
    return WebViewPackageInfo(
      versionName: _patchMap.containsKey(WebViewPackageInfo$.versionName)
          ? (_patchMap[WebViewPackageInfo$.versionName] is Function)
                ? _patchMap[WebViewPackageInfo$.versionName](this.versionName)
                : (_patchMap[WebViewPackageInfo$.versionName] is Patch)
                ? _patchMap[WebViewPackageInfo$.versionName].applyTo(
                    this.versionName,
                  )
                : _patchMap[WebViewPackageInfo$.versionName]
          : this.versionName,
      packageName: _patchMap.containsKey(WebViewPackageInfo$.packageName)
          ? (_patchMap[WebViewPackageInfo$.packageName] is Function)
                ? _patchMap[WebViewPackageInfo$.packageName](this.packageName)
                : (_patchMap[WebViewPackageInfo$.packageName] is Patch)
                ? _patchMap[WebViewPackageInfo$.packageName].applyTo(
                    this.packageName,
                  )
                : _patchMap[WebViewPackageInfo$.packageName]
          : this.packageName,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WebViewPackageInfo &&
        versionName == other.versionName &&
        packageName == other.packageName;
  }

  @override
  int get hashCode {
    return Object.hash(this.versionName, this.packageName);
  }

  @override
  String toString() {
    return 'WebViewPackageInfo(' +
        'versionName: ${versionName}' +
        ', ' +
        'packageName: ${packageName})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$WebViewPackageInfoToJson(this);
    return _sanitizeJson(data);
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

extension WebViewPackageInfoPropertyHelpers on WebViewPackageInfo {
  bool get hasVersionName {
    return this.versionName?.isNotEmpty == true;
  }

  bool get noVersionName {
    return this.versionName?.isEmpty ?? true;
  }

  String get versionNameRequired {
    return this.versionName ??
        (throw StateError('versionName is required but was null'));
  }

  bool get hasPackageName {
    return this.packageName?.isNotEmpty == true;
  }

  bool get noPackageName {
    return this.packageName?.isEmpty ?? true;
  }

  String get packageNameRequired {
    return this.packageName ??
        (throw StateError('packageName is required but was null'));
  }
}

extension WebViewPackageInfoSerialization on WebViewPackageInfo {
  Map<String, dynamic> toJson() {
    return _$WebViewPackageInfoToJson(this);
  }
}

enum WebViewPackageInfo$ { versionName, packageName }

class WebViewPackageInfoPatch
    extends PatchBase<WebViewPackageInfo, WebViewPackageInfo$> {
  WebViewPackageInfo applyTo(WebViewPackageInfo entity) {
    return entity.patchWithWebViewPackageInfo(this);
  }

  WebViewPackageInfoPatch withVersionName(String? value) {
    patchMap[WebViewPackageInfo$.versionName] = value;
    return this;
  }

  WebViewPackageInfoPatch withPackageName(String? value) {
    patchMap[WebViewPackageInfo$.packageName] = value;
    return this;
  }
}

/// Field descriptors for [WebViewPackageInfo] query construction
abstract final class WebViewPackageInfoFields {
  static const versionName = Field<WebViewPackageInfo, String?>(
    'versionName',
    _$versionName,
  );

  static const packageName = Field<WebViewPackageInfo, String?>(
    'packageName',
    _$packageName,
  );

  static String? _$versionName(WebViewPackageInfo e) {
    return e.versionName;
  }

  static String? _$packageName(WebViewPackageInfo e) {
    return e.packageName;
  }
}

extension WebViewPackageInfoCompareE on WebViewPackageInfo {
  Map<String, dynamic> compareToWebViewPackageInfo(WebViewPackageInfo other) {
    final Map<String, dynamic> diff = {};

    if (versionName != other.versionName) {
      diff['versionName'] = () => other.versionName;
    }

    if (packageName != other.packageName) {
      diff['packageName'] = () => other.packageName;
    }
    return diff;
  }
}
