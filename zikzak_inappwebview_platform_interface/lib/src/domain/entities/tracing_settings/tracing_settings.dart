import 'package:zorphy_annotation/zorphy_annotation.dart';

import '../enums/tracing_mode.dart';
import '../enums/tracing_category.dart';

part 'tracing_settings.zorphy.dart';
part 'tracing_settings.g.dart';

///Class that represents the settings used to configure the [PlatformTracingController].
///
///**Officially Supported Platforms/Implementations**:
///- Android native WebView ([Official API - TracingConfig](https://developer.android.com/reference/androidx/webkit/TracingConfig))
@Zorphy(
  kind: ZorphyKind.valueObject,
  generateJson: true,
  generateCompareTo: true,
)
abstract class $TracingSettings {
  ///Adds predefined [TracingCategory] and/or custom [String] sets of categories to be included in the trace output.
  ///
  ///Note that the categories are defined by the currently-in-use version of WebView.
  ///They live in chromium code and are not part of the Android API.
  ///See [chromium documentation on tracing](https://www.chromium.org/developers/how-tos/trace-event-profiling-tool)
  ///for more details.
  ///
  ///A category pattern can contain wildcards, e.g. `"blink*"` or full category name e.g. `"renderer.scheduler"`.
  @JsonKey(fromJson: _deserializeCategories, toJson: _serializeCategories)
  List<dynamic> get categories;

  ///The tracing mode for this configuration.
  ///When tracingMode is not set explicitly, the default is [TracingMode.RECORD_CONTINUOUSLY].
  @JsonKey(fromJson: _tracingModeFromJson, toJson: _tracingModeToJson)
  TracingMode? get tracingMode;
}

List<dynamic> _deserializeCategories(List<dynamic> categories) {
  List<dynamic> deserializedCategories = [];
  for (dynamic category in categories) {
    if (category is String) {
      deserializedCategories.add(category);
    } else if (category is int) {
      final mode = tracingCategoryFromWire(category);
      if (mode != null) {
        deserializedCategories.add(mode);
      }
    }
  }
  return deserializedCategories;
}

List<dynamic> _serializeCategories(List<dynamic> categories) {
  List<dynamic> serializedCategories = [];
  for (dynamic category in categories) {
    if (category is String) {
      serializedCategories.add(category);
    } else if (category is TracingCategory) {
      serializedCategories.add(tracingCategoryToWire(category));
    }
  }
  return serializedCategories;
}

TracingMode? _tracingModeFromJson(Object? value) => tracingModeFromWire(value);

Object? _tracingModeToJson(TracingMode? value) => tracingModeToWire(value);
