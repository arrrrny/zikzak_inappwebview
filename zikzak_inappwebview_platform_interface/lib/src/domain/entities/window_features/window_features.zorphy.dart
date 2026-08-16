// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'window_features.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class WindowFeatures {
  WindowFeatures({
    bool? this.allowsResizing,
    double? this.height,
    bool? this.menuBarVisibility,
    bool? this.statusBarVisibility,
    bool? this.toolbarsVisibility,
    double? this.width,
    double? this.x,
    double? this.y,
  });

  factory WindowFeatures.fromJson(Map<String, dynamic> json) =>
      _$WindowFeaturesFromJson(json);

  final bool? allowsResizing;

  final double? height;

  final bool? menuBarVisibility;

  final bool? statusBarVisibility;

  final bool? toolbarsVisibility;

  final double? width;

  final double? x;

  final double? y;

  WindowFeatures copyWith({
    bool? allowsResizing,
    double? height,
    bool? menuBarVisibility,
    bool? statusBarVisibility,
    bool? toolbarsVisibility,
    double? width,
    double? x,
    double? y,
  }) {
    return WindowFeatures(
      allowsResizing: allowsResizing ?? this.allowsResizing,
      height: height ?? this.height,
      menuBarVisibility: menuBarVisibility ?? this.menuBarVisibility,
      statusBarVisibility: statusBarVisibility ?? this.statusBarVisibility,
      toolbarsVisibility: toolbarsVisibility ?? this.toolbarsVisibility,
      width: width ?? this.width,
      x: x ?? this.x,
      y: y ?? this.y,
    );
  }

  WindowFeatures copyWithWindowFeatures({
    bool? allowsResizing,
    double? height,
    bool? menuBarVisibility,
    bool? statusBarVisibility,
    bool? toolbarsVisibility,
    double? width,
    double? x,
    double? y,
  }) {
    return copyWith(
      allowsResizing: allowsResizing,
      height: height,
      menuBarVisibility: menuBarVisibility,
      statusBarVisibility: statusBarVisibility,
      toolbarsVisibility: toolbarsVisibility,
      width: width,
      x: x,
      y: y,
    );
  }

  WindowFeatures patchWithWindowFeatures([WindowFeaturesPatch? patchInput]) {
    final _patcher = patchInput ?? WindowFeaturesPatch();
    final _patchMap = _patcher.patchMap;
    return WindowFeatures(
      allowsResizing: _patchMap.containsKey(WindowFeatures$.allowsResizing)
          ? (_patchMap[WindowFeatures$.allowsResizing] is Function)
                ? _patchMap[WindowFeatures$.allowsResizing](this.allowsResizing)
                : (_patchMap[WindowFeatures$.allowsResizing] is Patch)
                ? _patchMap[WindowFeatures$.allowsResizing].applyTo(
                    this.allowsResizing,
                  )
                : _patchMap[WindowFeatures$.allowsResizing]
          : this.allowsResizing,
      height: _patchMap.containsKey(WindowFeatures$.height)
          ? (_patchMap[WindowFeatures$.height] is Function)
                ? _patchMap[WindowFeatures$.height](this.height)
                : (_patchMap[WindowFeatures$.height] is Patch)
                ? _patchMap[WindowFeatures$.height].applyTo(this.height)
                : _patchMap[WindowFeatures$.height]
          : this.height,
      menuBarVisibility:
          _patchMap.containsKey(WindowFeatures$.menuBarVisibility)
          ? (_patchMap[WindowFeatures$.menuBarVisibility] is Function)
                ? _patchMap[WindowFeatures$.menuBarVisibility](
                    this.menuBarVisibility,
                  )
                : (_patchMap[WindowFeatures$.menuBarVisibility] is Patch)
                ? _patchMap[WindowFeatures$.menuBarVisibility].applyTo(
                    this.menuBarVisibility,
                  )
                : _patchMap[WindowFeatures$.menuBarVisibility]
          : this.menuBarVisibility,
      statusBarVisibility:
          _patchMap.containsKey(WindowFeatures$.statusBarVisibility)
          ? (_patchMap[WindowFeatures$.statusBarVisibility] is Function)
                ? _patchMap[WindowFeatures$.statusBarVisibility](
                    this.statusBarVisibility,
                  )
                : (_patchMap[WindowFeatures$.statusBarVisibility] is Patch)
                ? _patchMap[WindowFeatures$.statusBarVisibility].applyTo(
                    this.statusBarVisibility,
                  )
                : _patchMap[WindowFeatures$.statusBarVisibility]
          : this.statusBarVisibility,
      toolbarsVisibility:
          _patchMap.containsKey(WindowFeatures$.toolbarsVisibility)
          ? (_patchMap[WindowFeatures$.toolbarsVisibility] is Function)
                ? _patchMap[WindowFeatures$.toolbarsVisibility](
                    this.toolbarsVisibility,
                  )
                : (_patchMap[WindowFeatures$.toolbarsVisibility] is Patch)
                ? _patchMap[WindowFeatures$.toolbarsVisibility].applyTo(
                    this.toolbarsVisibility,
                  )
                : _patchMap[WindowFeatures$.toolbarsVisibility]
          : this.toolbarsVisibility,
      width: _patchMap.containsKey(WindowFeatures$.width)
          ? (_patchMap[WindowFeatures$.width] is Function)
                ? _patchMap[WindowFeatures$.width](this.width)
                : (_patchMap[WindowFeatures$.width] is Patch)
                ? _patchMap[WindowFeatures$.width].applyTo(this.width)
                : _patchMap[WindowFeatures$.width]
          : this.width,
      x: _patchMap.containsKey(WindowFeatures$.x)
          ? (_patchMap[WindowFeatures$.x] is Function)
                ? _patchMap[WindowFeatures$.x](this.x)
                : (_patchMap[WindowFeatures$.x] is Patch)
                ? _patchMap[WindowFeatures$.x].applyTo(this.x)
                : _patchMap[WindowFeatures$.x]
          : this.x,
      y: _patchMap.containsKey(WindowFeatures$.y)
          ? (_patchMap[WindowFeatures$.y] is Function)
                ? _patchMap[WindowFeatures$.y](this.y)
                : (_patchMap[WindowFeatures$.y] is Patch)
                ? _patchMap[WindowFeatures$.y].applyTo(this.y)
                : _patchMap[WindowFeatures$.y]
          : this.y,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WindowFeatures &&
        allowsResizing == other.allowsResizing &&
        height == other.height &&
        menuBarVisibility == other.menuBarVisibility &&
        statusBarVisibility == other.statusBarVisibility &&
        toolbarsVisibility == other.toolbarsVisibility &&
        width == other.width &&
        x == other.x &&
        y == other.y;
  }

  @override
  int get hashCode {
    return Object.hash(
      this.allowsResizing,
      this.height,
      this.menuBarVisibility,
      this.statusBarVisibility,
      this.toolbarsVisibility,
      this.width,
      this.x,
      this.y,
    );
  }

  @override
  String toString() {
    return 'WindowFeatures(' +
        'allowsResizing: ${allowsResizing}' +
        ', ' +
        'height: ${height}' +
        ', ' +
        'menuBarVisibility: ${menuBarVisibility}' +
        ', ' +
        'statusBarVisibility: ${statusBarVisibility}' +
        ', ' +
        'toolbarsVisibility: ${toolbarsVisibility}' +
        ', ' +
        'width: ${width}' +
        ', ' +
        'x: ${x}' +
        ', ' +
        'y: ${y})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$WindowFeaturesToJson(this);
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

extension WindowFeaturesPropertyHelpers on WindowFeatures {
  bool get hasAllowsResizing {
    return this.allowsResizing != null;
  }

  bool get noAllowsResizing {
    return this.allowsResizing == null;
  }

  bool get allowsResizingRequired {
    return this.allowsResizing ??
        (throw StateError('allowsResizing is required but was null'));
  }

  bool get hasHeight {
    return this.height != null;
  }

  bool get noHeight {
    return this.height == null;
  }

  double get heightRequired {
    return this.height ?? (throw StateError('height is required but was null'));
  }

  bool get hasMenuBarVisibility {
    return this.menuBarVisibility != null;
  }

  bool get noMenuBarVisibility {
    return this.menuBarVisibility == null;
  }

  bool get menuBarVisibilityRequired {
    return this.menuBarVisibility ??
        (throw StateError('menuBarVisibility is required but was null'));
  }

  bool get hasStatusBarVisibility {
    return this.statusBarVisibility != null;
  }

  bool get noStatusBarVisibility {
    return this.statusBarVisibility == null;
  }

  bool get statusBarVisibilityRequired {
    return this.statusBarVisibility ??
        (throw StateError('statusBarVisibility is required but was null'));
  }

  bool get hasToolbarsVisibility {
    return this.toolbarsVisibility != null;
  }

  bool get noToolbarsVisibility {
    return this.toolbarsVisibility == null;
  }

  bool get toolbarsVisibilityRequired {
    return this.toolbarsVisibility ??
        (throw StateError('toolbarsVisibility is required but was null'));
  }

  bool get hasWidth {
    return this.width != null;
  }

  bool get noWidth {
    return this.width == null;
  }

  double get widthRequired {
    return this.width ?? (throw StateError('width is required but was null'));
  }

  bool get hasX {
    return this.x != null;
  }

  bool get noX {
    return this.x == null;
  }

  double get xRequired {
    return this.x ?? (throw StateError('x is required but was null'));
  }

  bool get hasY {
    return this.y != null;
  }

  bool get noY {
    return this.y == null;
  }

  double get yRequired {
    return this.y ?? (throw StateError('y is required but was null'));
  }
}

extension WindowFeaturesSerialization on WindowFeatures {
  Map<String, dynamic> toJson() {
    return _$WindowFeaturesToJson(this);
  }
}

enum WindowFeatures$ {
  allowsResizing,
  height,
  menuBarVisibility,
  statusBarVisibility,
  toolbarsVisibility,
  width,
  x,
  y,
}

class WindowFeaturesPatch extends PatchBase<WindowFeatures, WindowFeatures$> {
  WindowFeatures applyTo(WindowFeatures entity) {
    return entity.patchWithWindowFeatures(this);
  }

  WindowFeaturesPatch withAllowsResizing(bool? value) {
    patchMap[WindowFeatures$.allowsResizing] = value;
    return this;
  }

  WindowFeaturesPatch withHeight(double? value) {
    patchMap[WindowFeatures$.height] = value;
    return this;
  }

  WindowFeaturesPatch withMenuBarVisibility(bool? value) {
    patchMap[WindowFeatures$.menuBarVisibility] = value;
    return this;
  }

  WindowFeaturesPatch withStatusBarVisibility(bool? value) {
    patchMap[WindowFeatures$.statusBarVisibility] = value;
    return this;
  }

  WindowFeaturesPatch withToolbarsVisibility(bool? value) {
    patchMap[WindowFeatures$.toolbarsVisibility] = value;
    return this;
  }

  WindowFeaturesPatch withWidth(double? value) {
    patchMap[WindowFeatures$.width] = value;
    return this;
  }

  WindowFeaturesPatch withX(double? value) {
    patchMap[WindowFeatures$.x] = value;
    return this;
  }

  WindowFeaturesPatch withY(double? value) {
    patchMap[WindowFeatures$.y] = value;
    return this;
  }
}

/// Field descriptors for [WindowFeatures] query construction
abstract final class WindowFeaturesFields {
  static const allowsResizing = Field<WindowFeatures, bool?>(
    'allowsResizing',
    _$allowsResizing,
  );

  static const height = Field<WindowFeatures, double?>('height', _$height);

  static const menuBarVisibility = Field<WindowFeatures, bool?>(
    'menuBarVisibility',
    _$menuBarVisibility,
  );

  static const statusBarVisibility = Field<WindowFeatures, bool?>(
    'statusBarVisibility',
    _$statusBarVisibility,
  );

  static const toolbarsVisibility = Field<WindowFeatures, bool?>(
    'toolbarsVisibility',
    _$toolbarsVisibility,
  );

  static const width = Field<WindowFeatures, double?>('width', _$width);

  static const x = Field<WindowFeatures, double?>('x', _$x);

  static const y = Field<WindowFeatures, double?>('y', _$y);

  static bool? _$allowsResizing(WindowFeatures e) {
    return e.allowsResizing;
  }

  static double? _$height(WindowFeatures e) {
    return e.height;
  }

  static bool? _$menuBarVisibility(WindowFeatures e) {
    return e.menuBarVisibility;
  }

  static bool? _$statusBarVisibility(WindowFeatures e) {
    return e.statusBarVisibility;
  }

  static bool? _$toolbarsVisibility(WindowFeatures e) {
    return e.toolbarsVisibility;
  }

  static double? _$width(WindowFeatures e) {
    return e.width;
  }

  static double? _$x(WindowFeatures e) {
    return e.x;
  }

  static double? _$y(WindowFeatures e) {
    return e.y;
  }
}

extension WindowFeaturesCompareE on WindowFeatures {
  Map<String, dynamic> compareToWindowFeatures(WindowFeatures other) {
    final Map<String, dynamic> diff = {};

    if (allowsResizing != other.allowsResizing) {
      diff['allowsResizing'] = () => other.allowsResizing;
    }

    if (height != other.height) {
      diff['height'] = () => other.height;
    }

    if (menuBarVisibility != other.menuBarVisibility) {
      diff['menuBarVisibility'] = () => other.menuBarVisibility;
    }

    if (statusBarVisibility != other.statusBarVisibility) {
      diff['statusBarVisibility'] = () => other.statusBarVisibility;
    }

    if (toolbarsVisibility != other.toolbarsVisibility) {
      diff['toolbarsVisibility'] = () => other.toolbarsVisibility;
    }

    if (width != other.width) {
      diff['width'] = () => other.width;
    }

    if (x != other.x) {
      diff['x'] = () => other.x;
    }

    if (y != other.y) {
      diff['y'] = () => other.y;
    }
    return diff;
  }
}
