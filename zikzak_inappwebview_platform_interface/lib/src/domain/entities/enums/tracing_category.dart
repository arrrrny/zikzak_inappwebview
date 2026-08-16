///Constants that describe the results summary the find panel UI includes.
enum TracingCategory {
  ///Predefined set of categories, includes all categories enabled by default in chromium.
  ///Use with caution: this setting may produce large trace output.
  CATEGORIES_ALL,

  ///Predefined set of categories typically useful for analyzing WebViews.
  ///Typically includes "android_webview" and "Java" categories.
  CATEGORIES_ANDROID_WEBVIEW,

  ///Predefined set of categories for studying difficult rendering performance problems.
  ///Typically includes "blink", "compositor", "gpu", "renderer.scheduler", "v8"
  ///and some other compositor categories which are disabled by default.
  CATEGORIES_FRAME_VIEWER,

  ///Predefined set of categories for analyzing input latency issues.
  ///Typically includes "input", "renderer.scheduler" categories.
  CATEGORIES_INPUT_LATENCY,

  ///Predefined set of categories for analyzing javascript and rendering issues.
  ///Typically includes "blink", "compositor", "gpu", "renderer.scheduler" and "v8" categories.
  CATEGORIES_JAVASCRIPT_AND_RENDERING,

  ///Indicates that there are no predefined categories.
  CATEGORIES_NONE,

  ///Predefined set of categories for analyzing rendering issues.
  ///Typically includes "blink", "compositor" and "gpu" categories.
  CATEGORIES_RENDERING,

  ///Predefined set of categories typically useful for web developers.
  ///Typically includes "blink", "compositor", "renderer.scheduler" and "v8" categories.
  CATEGORIES_WEB_DEVELOPER,
}

///tracing_category wire values are NOT sequential (1, 2, 64, 8, 32, 0, 16, 4) — a plain enum's `.index`
///does not match the old `_value`.

///TracingCategory wire values differ from `.index` — lookup by value.
const _tracingCategory_wire = [1, 2, 64, 8, 32, 0, 16, 4];

TracingCategory? tracingCategoryFromWire(Object? value) {
  if (value is! int) return null;
  final index = _tracingCategory_wire.indexOf(value);
  return index >= 0 ? TracingCategory.values[index] : null;
}

Object? tracingCategoryToWire(TracingCategory? value) =>
    value == null ? null : _tracingCategory_wire[value.index];
