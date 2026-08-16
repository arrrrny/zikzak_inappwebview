
import '../../../content_blocker.dart';


///Class that represents the kind of load context that can be used with a [ContentBlockerTrigger].
enum ContentBlockerTriggerLoadContext {
  ///Top frame load context
  TOP_FRAME,
  ///Child frame load context
  CHILD_FRAME,
}


///ContentBlockerTriggerLoadContext wire values are the content-blocker strings (e.g. 'document'), which
///differ from the member names — lookup by value.


///ContentBlockerTriggerLoadContext wire values are the content-blocker strings (child-frame, top-frame) — lookup by value.
const _contentBlockerTriggerLoadContext_wire = ['child-frame', 'top-frame'];

ContentBlockerTriggerLoadContext? contentBlockerTriggerLoadContextFromWire(String? value) {
  if (value == null) return null;
  final index = _contentBlockerTriggerLoadContext_wire.indexOf(value);
  return index >= 0 ? ContentBlockerTriggerLoadContext.values[index] : null;
}

String? contentBlockerTriggerLoadContextToWire(ContentBlockerTriggerLoadContext? value) =>
    value == null ? null : _contentBlockerTriggerLoadContext_wire[value.index];
