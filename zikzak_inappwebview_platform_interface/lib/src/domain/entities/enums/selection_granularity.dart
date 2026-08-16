///Class used to set the level of granularity with which the user can interactively select content in the web view.
enum SelectionGranularity {
  ///Selection granularity varies automatically based on the selection.
  DYNAMIC,

  ///Selection endpoints can be placed at any character boundary.
  CHARACTER,
}

SelectionGranularity? selectionGranularityFromWire(Object? value) {
  if (value is! int) return null;
  return value >= 0 && value < SelectionGranularity.values.length
      ? SelectionGranularity.values[value]
      : null;
}

Object? selectionGranularityToWire(SelectionGranularity? value) => value?.index;
