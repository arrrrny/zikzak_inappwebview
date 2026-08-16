
import '../../../content_blocker.dart';


///Class that represents the possible load type for a [ContentBlockerTrigger].
enum ContentBlockerTriggerLoadType {
  ///FIRST_PARTY is triggered only if the resource has the same scheme, domain, and port as the main page resource.
  FIRST_PARTY,
  ///THIRD_PARTY is triggered if the resource is not from the same domain as the main page resource.
  THIRD_PARTY,
}


///ContentBlockerTriggerLoadType wire values are the content-blocker strings (e.g. 'document'), which
///differ from the member names — lookup by value.


///ContentBlockerTriggerLoadType wire values are the content-blocker strings (first-party, third-party) — lookup by value.
const _contentBlockerTriggerLoadType_wire = ['first-party', 'third-party'];

ContentBlockerTriggerLoadType? contentBlockerTriggerLoadTypeFromWire(String? value) {
  if (value == null) return null;
  final index = _contentBlockerTriggerLoadType_wire.indexOf(value);
  return index >= 0 ? ContentBlockerTriggerLoadType.values[index] : null;
}

String? contentBlockerTriggerLoadTypeToWire(ContentBlockerTriggerLoadType? value) =>
    value == null ? null : _contentBlockerTriggerLoadType_wire[value.index];
