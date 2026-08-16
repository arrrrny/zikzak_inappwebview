import '../../../content_blocker.dart';

///Class that represents the possible resource type defined for a [ContentBlockerTrigger].
enum ContentBlockerTriggerResourceType {
  DOCUMENT,
  IMAGE,
  STYLE_SHEET,
  SCRIPT,
  FONT,
  MEDIA,
  SVG_DOCUMENT,

  ///Any untyped load
  RAW,
}

///ContentBlockerTriggerResourceType wire values are the content-blocker strings (e.g. 'document'), which
///differ from the member names — lookup by value.

///ContentBlockerTriggerResourceType wire values are the content-blocker strings (document, image, style-sheet...) — lookup by value.
const _contentBlockerTriggerResourceType_wire = [
  'document',
  'image',
  'style-sheet',
  'script',
  'font',
  'media',
  'svg-document',
  'raw',
];

ContentBlockerTriggerResourceType? contentBlockerTriggerResourceTypeFromWire(
  String? value,
) {
  if (value == null) return null;
  final index = _contentBlockerTriggerResourceType_wire.indexOf(value);
  return index >= 0 ? ContentBlockerTriggerResourceType.values[index] : null;
}

String? contentBlockerTriggerResourceTypeToWire(
  ContentBlockerTriggerResourceType? value,
) =>
    value == null ? null : _contentBlockerTriggerResourceType_wire[value.index];
