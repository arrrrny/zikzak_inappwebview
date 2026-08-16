// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'screenshot_configuration.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class ScreenshotConfiguration {
  ScreenshotConfiguration({
    InAppWebViewRect? this.rect,
    double? this.snapshotWidth,
    CompressFormat? compressFormat,
    int? quality,
    bool? afterScreenUpdates,
  }) : this.compressFormat = compressFormat ?? CompressFormat.PNG,
       this.quality = quality ?? 100,
       this.afterScreenUpdates = afterScreenUpdates ?? true;

  factory ScreenshotConfiguration.fromJson(Map<String, dynamic> json) =>
      _$ScreenshotConfigurationFromJson(json);

  final InAppWebViewRect? rect;

  final double? snapshotWidth;

  @JsonKey(defaultValue: CompressFormat.PNG)
  final CompressFormat compressFormat;

  @JsonKey(defaultValue: 100)
  final int quality;

  @JsonKey(defaultValue: true)
  final bool afterScreenUpdates;

  ScreenshotConfiguration copyWith({
    InAppWebViewRect? rect,
    double? snapshotWidth,
    CompressFormat? compressFormat,
    int? quality,
    bool? afterScreenUpdates,
  }) {
    return ScreenshotConfiguration(
      rect: rect ?? this.rect,
      snapshotWidth: snapshotWidth ?? this.snapshotWidth,
      compressFormat: compressFormat ?? this.compressFormat,
      quality: quality ?? this.quality,
      afterScreenUpdates: afterScreenUpdates ?? this.afterScreenUpdates,
    );
  }

  ScreenshotConfiguration copyWithScreenshotConfiguration({
    InAppWebViewRect? rect,
    double? snapshotWidth,
    CompressFormat? compressFormat,
    int? quality,
    bool? afterScreenUpdates,
  }) {
    return copyWith(
      rect: rect,
      snapshotWidth: snapshotWidth,
      compressFormat: compressFormat,
      quality: quality,
      afterScreenUpdates: afterScreenUpdates,
    );
  }

  ScreenshotConfiguration patchWithScreenshotConfiguration([
    ScreenshotConfigurationPatch? patchInput,
  ]) {
    final _patcher = patchInput ?? ScreenshotConfigurationPatch();
    final _patchMap = _patcher.patchMap;
    return ScreenshotConfiguration(
      rect: _patchMap.containsKey(ScreenshotConfiguration$.rect)
          ? (_patchMap[ScreenshotConfiguration$.rect] is Function)
                ? _patchMap[ScreenshotConfiguration$.rect](this.rect)
                : (_patchMap[ScreenshotConfiguration$.rect] is Patch)
                ? _patchMap[ScreenshotConfiguration$.rect].applyTo(this.rect)
                : _patchMap[ScreenshotConfiguration$.rect]
          : this.rect,
      snapshotWidth:
          _patchMap.containsKey(ScreenshotConfiguration$.snapshotWidth)
          ? (_patchMap[ScreenshotConfiguration$.snapshotWidth] is Function)
                ? _patchMap[ScreenshotConfiguration$.snapshotWidth](
                    this.snapshotWidth,
                  )
                : (_patchMap[ScreenshotConfiguration$.snapshotWidth] is Patch)
                ? _patchMap[ScreenshotConfiguration$.snapshotWidth].applyTo(
                    this.snapshotWidth,
                  )
                : _patchMap[ScreenshotConfiguration$.snapshotWidth]
          : this.snapshotWidth,
      compressFormat:
          _patchMap.containsKey(ScreenshotConfiguration$.compressFormat)
          ? (_patchMap[ScreenshotConfiguration$.compressFormat] is Function)
                ? _patchMap[ScreenshotConfiguration$.compressFormat](
                    this.compressFormat,
                  )
                : (_patchMap[ScreenshotConfiguration$.compressFormat] is Patch)
                ? _patchMap[ScreenshotConfiguration$.compressFormat].applyTo(
                    this.compressFormat,
                  )
                : _patchMap[ScreenshotConfiguration$.compressFormat]
          : this.compressFormat,
      quality: _patchMap.containsKey(ScreenshotConfiguration$.quality)
          ? (_patchMap[ScreenshotConfiguration$.quality] is Function)
                ? _patchMap[ScreenshotConfiguration$.quality](this.quality)
                : (_patchMap[ScreenshotConfiguration$.quality] is Patch)
                ? _patchMap[ScreenshotConfiguration$.quality].applyTo(
                    this.quality,
                  )
                : _patchMap[ScreenshotConfiguration$.quality]
          : this.quality,
      afterScreenUpdates:
          _patchMap.containsKey(ScreenshotConfiguration$.afterScreenUpdates)
          ? (_patchMap[ScreenshotConfiguration$.afterScreenUpdates] is Function)
                ? _patchMap[ScreenshotConfiguration$.afterScreenUpdates](
                    this.afterScreenUpdates,
                  )
                : (_patchMap[ScreenshotConfiguration$.afterScreenUpdates]
                      is Patch)
                ? _patchMap[ScreenshotConfiguration$.afterScreenUpdates]
                      .applyTo(this.afterScreenUpdates)
                : _patchMap[ScreenshotConfiguration$.afterScreenUpdates]
          : this.afterScreenUpdates,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ScreenshotConfiguration &&
        rect == other.rect &&
        snapshotWidth == other.snapshotWidth &&
        compressFormat == other.compressFormat &&
        quality == other.quality &&
        afterScreenUpdates == other.afterScreenUpdates;
  }

  @override
  int get hashCode {
    return Object.hash(
      this.rect,
      this.snapshotWidth,
      this.compressFormat,
      this.quality,
      this.afterScreenUpdates,
    );
  }

  @override
  String toString() {
    return 'ScreenshotConfiguration(' +
        'rect: ${rect}' +
        ', ' +
        'snapshotWidth: ${snapshotWidth}' +
        ', ' +
        'compressFormat: ${compressFormat}' +
        ', ' +
        'quality: ${quality}' +
        ', ' +
        'afterScreenUpdates: ${afterScreenUpdates})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$ScreenshotConfigurationToJson(this);
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

extension ScreenshotConfigurationPropertyHelpers on ScreenshotConfiguration {
  bool get hasRect {
    return this.rect != null;
  }

  bool get noRect {
    return this.rect == null;
  }

  InAppWebViewRect get rectRequired {
    return this.rect ?? (throw StateError('rect is required but was null'));
  }

  bool get hasSnapshotWidth {
    return this.snapshotWidth != null;
  }

  bool get noSnapshotWidth {
    return this.snapshotWidth == null;
  }

  double get snapshotWidthRequired {
    return this.snapshotWidth ??
        (throw StateError('snapshotWidth is required but was null'));
  }

  bool get isCompressFormatPNG {
    return this.compressFormat == CompressFormat.PNG;
  }

  bool get isCompressFormatJPEG {
    return this.compressFormat == CompressFormat.JPEG;
  }

  bool get isCompressFormatWEBP {
    return this.compressFormat == CompressFormat.WEBP;
  }

  bool get isCompressFormatWEBP_LOSSY {
    return this.compressFormat == CompressFormat.WEBP_LOSSY;
  }

  bool get isCompressFormatWEBP_LOSSLESS {
    return this.compressFormat == CompressFormat.WEBP_LOSSLESS;
  }
}

extension ScreenshotConfigurationSerialization on ScreenshotConfiguration {
  Map<String, dynamic> toJson() {
    return _$ScreenshotConfigurationToJson(this);
  }
}

enum ScreenshotConfiguration$ {
  rect,
  snapshotWidth,
  compressFormat,
  quality,
  afterScreenUpdates,
}

class ScreenshotConfigurationPatch
    extends PatchBase<ScreenshotConfiguration, ScreenshotConfiguration$> {
  ScreenshotConfiguration applyTo(ScreenshotConfiguration entity) {
    return entity.patchWithScreenshotConfiguration(this);
  }

  ScreenshotConfigurationPatch withRect(InAppWebViewRect? value) {
    patchMap[ScreenshotConfiguration$.rect] = value;
    return this;
  }

  ScreenshotConfigurationPatch withRectPatch(InAppWebViewRectPatch patch) {
    patchMap[ScreenshotConfiguration$.rect] = patch;
    return this;
  }

  ScreenshotConfigurationPatch withRectPatchFunc(
    InAppWebViewRectPatch Function(InAppWebViewRectPatch) patch,
  ) {
    patchMap[ScreenshotConfiguration$.rect] = (dynamic current) {
      var currentPatch = InAppWebViewRectPatch();
      return patch(currentPatch).applyTo(current as InAppWebViewRect);
    };
    return this;
  }

  ScreenshotConfigurationPatch withSnapshotWidth(double? value) {
    patchMap[ScreenshotConfiguration$.snapshotWidth] = value;
    return this;
  }

  ScreenshotConfigurationPatch withCompressFormat(CompressFormat? value) {
    patchMap[ScreenshotConfiguration$.compressFormat] = value;
    return this;
  }

  ScreenshotConfigurationPatch withQuality(int? value) {
    patchMap[ScreenshotConfiguration$.quality] = value;
    return this;
  }

  ScreenshotConfigurationPatch withAfterScreenUpdates(bool? value) {
    patchMap[ScreenshotConfiguration$.afterScreenUpdates] = value;
    return this;
  }
}

/// Field descriptors for [ScreenshotConfiguration] query construction
abstract final class ScreenshotConfigurationFields {
  static const rect = Field<ScreenshotConfiguration, InAppWebViewRect?>(
    'rect',
    _$rect,
  );

  static const snapshotWidth = Field<ScreenshotConfiguration, double?>(
    'snapshotWidth',
    _$snapshotWidth,
  );

  static const compressFormat = Field<ScreenshotConfiguration, CompressFormat>(
    'compressFormat',
    _$compressFormat,
  );

  static const quality = Field<ScreenshotConfiguration, int>(
    'quality',
    _$quality,
  );

  static const afterScreenUpdates = Field<ScreenshotConfiguration, bool>(
    'afterScreenUpdates',
    _$afterScreenUpdates,
  );

  static InAppWebViewRect? _$rect(ScreenshotConfiguration e) {
    return e.rect;
  }

  static double? _$snapshotWidth(ScreenshotConfiguration e) {
    return e.snapshotWidth;
  }

  static CompressFormat _$compressFormat(ScreenshotConfiguration e) {
    return e.compressFormat;
  }

  static int _$quality(ScreenshotConfiguration e) {
    return e.quality;
  }

  static bool _$afterScreenUpdates(ScreenshotConfiguration e) {
    return e.afterScreenUpdates;
  }
}

extension ScreenshotConfigurationCompareE on ScreenshotConfiguration {
  Map<String, dynamic> compareToScreenshotConfiguration(
    ScreenshotConfiguration other,
  ) {
    final Map<String, dynamic> diff = {};

    if (rect != other.rect) {
      diff['rect'] = () => other.rect;
    }

    if (snapshotWidth != other.snapshotWidth) {
      diff['snapshotWidth'] = () => other.snapshotWidth;
    }

    if (compressFormat != other.compressFormat) {
      diff['compressFormat'] = () => other.compressFormat;
    }

    if (quality != other.quality) {
      diff['quality'] = () => other.quality;
    }

    if (afterScreenUpdates != other.afterScreenUpdates) {
      diff['afterScreenUpdates'] = () => other.afterScreenUpdates;
    }
    return diff;
  }
}
