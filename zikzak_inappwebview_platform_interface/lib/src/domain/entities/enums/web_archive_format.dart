

///Class that represents the known Web Archive formats used when saving a web page.
enum WebArchiveFormat {
  ///Web Archive format used only by Android.
  MHT,
  ///Web Archive format used only by iOS.
  WEBARCHIVE,
}

///WebArchiveFormat wire values differ from the member names — lookup by value.
const _webArchiveFormat_wire = ['mht', 'webarchive'];

WebArchiveFormat? webArchiveFormatFromWire(Object? value) {
  if (value is! String) return null;
  final index = _webArchiveFormat_wire.indexOf(value);
  return index >= 0 ? WebArchiveFormat.values[index] : null;
}

Object? webArchiveFormatToWire(WebArchiveFormat? value) =>
    value == null ? null : _webArchiveFormat_wire[value.index];
