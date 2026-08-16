

///Class that represents a floating-point value that determines the rate of deceleration after the user lifts their finger.
enum ScrollViewDecelerationRate {
  ///The default deceleration rate for a scroll view: `0.998`.
  NORMAL,
  ///A fast deceleration rate for a scroll view: `0.99`.
  FAST,
}


ScrollViewDecelerationRate? scrollViewDecelerationRateFromWire(Object? value) =>
    value is String ? ScrollViewDecelerationRate.values.firstWhere((e) => e.name == value, orElse: () => ScrollViewDecelerationRate.values.first) : null;

String? scrollViewDecelerationRateToWire(ScrollViewDecelerationRate? value) => value?.name;
