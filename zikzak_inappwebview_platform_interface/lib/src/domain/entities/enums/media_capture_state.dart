

///Class that describes whether a media device, like a camera or microphone, is currently capturing audio or video.
enum MediaCaptureState {
  ///The media device is off.
  NONE,
  ///The media device is actively capturing audio or video.
  ACTIVE,
  ///The media device is muted, and not actively capturing audio or video.
  MUTED,
}

///MediaCaptureState wire values are sequential 0..n-1 — `.index` matches.
MediaCaptureState? mediaCaptureStateFromWire(Object? value) {
  if (value is! int) return null;
  return value >= 0 && value < MediaCaptureState.values.length
      ? MediaCaptureState.values[value]
      : null;
}

Object? mediaCaptureStateToWire(MediaCaptureState? value) => value?.index;
