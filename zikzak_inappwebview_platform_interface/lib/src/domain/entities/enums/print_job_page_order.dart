///Class representing the page order that will be used to generate the pages of a [PlatformPrintJobController].
enum PrintJobPageOrder {
  ///Descending (front to back) page order.
  DESCENDING,

  ///The spooler does not rearrange pages—they are printed in the order received by the spooler.
  SPECIAL,

  ///Ascending (back to front) page order.
  ASCENDING,

  ///No page order specified.
  UNKNOWN,
}

///PrintJobPageOrder wire values are NOT sequential (DESCENDING=-1, SPECIAL=0,
///ASCENDING=1, UNKNOWN=2) — a plain enum's `.index` does not match.
const _printJobPageOrderWire = [-1, 0, 1, 2];

PrintJobPageOrder? printJobPageOrderFromWire(int? value) {
  if (value == null) return null;
  final index = _printJobPageOrderWire.indexOf(value);
  return index >= 0 ? PrintJobPageOrder.values[index] : null;
}

int? printJobPageOrderToWire(PrintJobPageOrder? pageOrder) =>
    pageOrder == null ? null : _printJobPageOrderWire[pageOrder.index];
