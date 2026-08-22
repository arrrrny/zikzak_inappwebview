import '../renderer_priority_policy/renderer_priority_policy.dart';

///Class used by [RendererPriorityPolicy] class.
enum RendererPriority {
  ///The renderer associated with this WebView is bound with Android `Context#BIND_WAIVE_PRIORITY`.
  ///At this priority level WebView renderers will be strong targets for out of memory killing.
  RENDERER_PRIORITY_WAIVED,

  ///The renderer associated with this WebView is bound with the default priority for services.
  RENDERER_PRIORITY_BOUND,

  ///The renderer associated with this WebView is bound with Android `Context#BIND_IMPORTANT`.
  RENDERER_PRIORITY_IMPORTANT,
}

RendererPriority? rendererPriorityFromWire(Object? value) {
  if (value is! int) return null;
  return value >= 0 && value < RendererPriority.values.length
      ? RendererPriority.values[value]
      : null;
}

Object? rendererPriorityToWire(RendererPriority? value) => value?.index;
