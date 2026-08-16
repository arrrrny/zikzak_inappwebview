import 'package:zorphy_annotation/zorphy_annotation.dart';
import 'dart:ui';

import '../attributed_string/attributed_string.dart';
import '../enums/pull_to_refresh_size.dart';
import '../../../util.dart';

part 'pull_to_refresh_settings.zorphy.dart';
part 'pull_to_refresh_settings.g.dart';

///Pull-To-Refresh Settings
@Zorphy(
  kind: ZorphyKind.valueObject,
  generateJson: true,
  generateCompareTo: true,
)
abstract class $PullToRefreshSettings {
  ///Sets whether the pull-to-refresh feature is enabled or not.
  ///The default value is `true`.
  ///
  ///**Officially Supported Platforms/Implementations**:
  @JsonKey(defaultValue: true)
  bool? get enabled;

  ///The color of the refresh control.
  ///
  ///**Officially Supported Platforms/Implementations**:
  @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
  Color_? get color;

  ///The background color of the refresh control.
  ///
  ///**Officially Supported Platforms/Implementations**:
  @JsonKey(fromJson: _colorFromJson, toJson: _colorToJson)
  Color_? get backgroundColor;

  ///The distance to trigger a sync in dips.
  ///
  ///**Officially Supported Platforms/Implementations**:
  int? get distanceToTriggerSync;

  ///The distance in pixels that the refresh indicator can be pulled beyond its resting position.
  ///
  ///**Officially Supported Platforms/Implementations**:
  int? get slingshotDistance;

  ///The size of the refresh indicator.
  ///
  ///**Officially Supported Platforms/Implementations**:
  @JsonKey(fromJson: _sizeFromJson, toJson: _sizeToJson)
  PullToRefreshSize? get size;

  ///The title text to display in the refresh control.
  ///
  ///**Officially Supported Platforms/Implementations**:
  @JsonKey(fromJson: _attributedTitleFromJson, toJson: _attributedTitleToJson)
  AttributedString? get attributedTitle;
}

Color_? _colorFromJson(Object? value) {
  if (value == null) return null;
  final color = UtilColor.fromStringRepresentation(value as String);
  return color == null ? null : Color_(color.value);
}

Object? _colorToJson(Color_? color) => color?.toHex();

AttributedString? _attributedTitleFromJson(Object? value) => value == null
    ? null
    : AttributedString.fromJson((value as Map).cast<String, dynamic>());

Object? _attributedTitleToJson(AttributedString? attributedTitle) =>
    attributedTitle?.toJson();

PullToRefreshSize? _sizeFromJson(Object? value) {
  if (value is! int) return null;
  return switch (value) {
    1 => PullToRefreshSize.DEFAULT,
    0 => PullToRefreshSize.LARGE,
    _ => null,
  };
}

Object? _sizeToJson(PullToRefreshSize? size) =>
    size == null ? null : pullToRefreshSizeToWire(size);
