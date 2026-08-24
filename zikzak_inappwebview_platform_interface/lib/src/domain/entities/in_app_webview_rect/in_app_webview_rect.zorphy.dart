// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'in_app_webview_rect.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class InAppWebViewRect {
  InAppWebViewRect({
    required double this.x,
    required double this.y,
    required double this.width,
    required double this.height,
  });

  factory InAppWebViewRect.fromJson(Map<String, dynamic> json) =>
      _$InAppWebViewRectFromJson(json);

  final double x;

  final double y;

  final double width;

  final double height;

  InAppWebViewRect copyWith({
    double? x,
    double? y,
    double? width,
    double? height,
  }) {
    return InAppWebViewRect(
      x: x ?? this.x,
      y: y ?? this.y,
      width: width ?? this.width,
      height: height ?? this.height,
    );
  }

  InAppWebViewRect copyWithInAppWebViewRect({
    double? x,
    double? y,
    double? width,
    double? height,
  }) {
    return copyWith(x: x, y: y, width: width, height: height);
  }

  InAppWebViewRect patchWithInAppWebViewRect([
    InAppWebViewRectPatch? patchInput,
  ]) {
    final _patcher = patchInput ?? InAppWebViewRectPatch();
    final _patchMap = _patcher.patchMap;
    return InAppWebViewRect(
      x: _patchMap.containsKey(InAppWebViewRect$.x)
          ? ((_patchMap[InAppWebViewRect$.x] is Function)
                    ? _patchMap[InAppWebViewRect$.x](this.x)
                    : (_patchMap[InAppWebViewRect$.x] is Patch)
                    ? _patchMap[InAppWebViewRect$.x].applyTo(this.x)
                    : _patchMap[InAppWebViewRect$.x])
                as double
          : this.x,
      y: _patchMap.containsKey(InAppWebViewRect$.y)
          ? ((_patchMap[InAppWebViewRect$.y] is Function)
                    ? _patchMap[InAppWebViewRect$.y](this.y)
                    : (_patchMap[InAppWebViewRect$.y] is Patch)
                    ? _patchMap[InAppWebViewRect$.y].applyTo(this.y)
                    : _patchMap[InAppWebViewRect$.y])
                as double
          : this.y,
      width: _patchMap.containsKey(InAppWebViewRect$.width)
          ? ((_patchMap[InAppWebViewRect$.width] is Function)
                    ? _patchMap[InAppWebViewRect$.width](this.width)
                    : (_patchMap[InAppWebViewRect$.width] is Patch)
                    ? _patchMap[InAppWebViewRect$.width].applyTo(this.width)
                    : _patchMap[InAppWebViewRect$.width])
                as double
          : this.width,
      height: _patchMap.containsKey(InAppWebViewRect$.height)
          ? ((_patchMap[InAppWebViewRect$.height] is Function)
                    ? _patchMap[InAppWebViewRect$.height](this.height)
                    : (_patchMap[InAppWebViewRect$.height] is Patch)
                    ? _patchMap[InAppWebViewRect$.height].applyTo(this.height)
                    : _patchMap[InAppWebViewRect$.height])
                as double
          : this.height,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is InAppWebViewRect &&
        x == other.x &&
        y == other.y &&
        width == other.width &&
        height == other.height;
  }

  @override
  int get hashCode {
    return Object.hash(this.x, this.y, this.width, this.height);
  }

  @override
  String toString() {
    return 'InAppWebViewRect(' +
        'x: ${x}' +
        ', ' +
        'y: ${y}' +
        ', ' +
        'width: ${width}' +
        ', ' +
        'height: ${height})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$InAppWebViewRectToJson(this);
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

extension InAppWebViewRectPropertyHelpers on InAppWebViewRect {}

extension InAppWebViewRectSerialization on InAppWebViewRect {
  Map<String, dynamic> toJson() {
    return _$InAppWebViewRectToJson(this);
  }
}

enum InAppWebViewRect$ { x, y, width, height }

class InAppWebViewRectPatch
    extends PatchBase<InAppWebViewRect, InAppWebViewRect$> {
  InAppWebViewRect applyTo(InAppWebViewRect entity) {
    return entity.patchWithInAppWebViewRect(this);
  }

  InAppWebViewRectPatch withX(double? value) {
    patchMap[InAppWebViewRect$.x] = value;
    return this;
  }

  InAppWebViewRectPatch withY(double? value) {
    patchMap[InAppWebViewRect$.y] = value;
    return this;
  }

  InAppWebViewRectPatch withWidth(double? value) {
    patchMap[InAppWebViewRect$.width] = value;
    return this;
  }

  InAppWebViewRectPatch withHeight(double? value) {
    patchMap[InAppWebViewRect$.height] = value;
    return this;
  }
}

/// Field descriptors for [InAppWebViewRect] query construction
abstract final class InAppWebViewRectFields {
  static const x = Field<InAppWebViewRect, double>('x', _$x);

  static const y = Field<InAppWebViewRect, double>('y', _$y);

  static const width = Field<InAppWebViewRect, double>('width', _$width);

  static const height = Field<InAppWebViewRect, double>('height', _$height);

  static double _$x(InAppWebViewRect e) {
    return e.x;
  }

  static double _$y(InAppWebViewRect e) {
    return e.y;
  }

  static double _$width(InAppWebViewRect e) {
    return e.width;
  }

  static double _$height(InAppWebViewRect e) {
    return e.height;
  }
}

extension InAppWebViewRectCompareE on InAppWebViewRect {
  Map<String, dynamic> compareToInAppWebViewRect(InAppWebViewRect other) {
    final Map<String, dynamic> diff = {};

    if (x != other.x) {
      diff['x'] = () => other.x;
    }

    if (y != other.y) {
      diff['y'] = () => other.y;
    }

    if (width != other.width) {
      diff['width'] = () => other.width;
    }

    if (height != other.height) {
      diff['height'] = () => other.height;
    }
    return diff;
  }
}
