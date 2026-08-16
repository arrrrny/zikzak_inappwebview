

///Class used to configure how safe area insets are added to the adjusted content inset.
enum ScrollViewContentInsetAdjustmentBehavior {
  ///Automatically adjust the scroll view insets.
  AUTOMATIC,
  ///Adjust the insets only in the scrollable directions.
  SCROLLABLE_AXES,
  ///Do not adjust the scroll view insets.
  NEVER,
  ///Always include the safe area insets in the content adjustment.
  ALWAYS,
}


ScrollViewContentInsetAdjustmentBehavior? scrollViewContentInsetAdjustmentBehaviorFromWire(Object? value) {
  if (value is! int) return null;
  return value >= 0 && value < ScrollViewContentInsetAdjustmentBehavior.values.length
      ? ScrollViewContentInsetAdjustmentBehavior.values[value]
      : null;
}

Object? scrollViewContentInsetAdjustmentBehaviorToWire(ScrollViewContentInsetAdjustmentBehavior? value) => value?.index;
