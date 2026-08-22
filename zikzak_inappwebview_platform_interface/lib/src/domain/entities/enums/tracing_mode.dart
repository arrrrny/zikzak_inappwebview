///Constants that describe the results summary the find panel UI includes.
enum TracingMode {
  ///Record trace events until the internal tracing buffer is full.
  ///Typically the buffer memory usage is larger than [RECORD_CONTINUOUSLY].
  ///Depending on the implementation typically allows up to 256k events to be stored.
  RECORD_UNTIL_FULL,

  ///Record trace events continuously using an internal ring buffer.
  ///Default tracing mode.
  ///Overwrites old events if they exceed buffer capacity.
  ///Uses less memory than the [RECORD_UNTIL_FULL] mode.
  ///Depending on the implementation typically allows up to 64k events to be stored.
  RECORD_CONTINUOUSLY,
}

///TracingMode wire values are sequential 0..n-1 — `.index` matches.
TracingMode? tracingModeFromWire(Object? value) {
  if (value is! int) return null;
  return value >= 0 && value < TracingMode.values.length
      ? TracingMode.values[value]
      : null;
}

Object? tracingModeToWire(TracingMode? value) => value?.index;
