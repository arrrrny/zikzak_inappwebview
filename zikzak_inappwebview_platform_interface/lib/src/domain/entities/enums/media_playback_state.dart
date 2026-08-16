///Class that describes whether an audio or video presentation is playing, paused, or suspended.
enum MediaPlaybackState {
  ///There is no media to play back.
  NONE,

  ///The media is playing.
  PLAYING,

  ///The media playback is paused.
  PAUSED,

  ///The media is not playing, and cannot be resumed until the user revokes the suspension.
  SUSPENDED,
}

///MediaPlaybackState wire values are sequential 0..n-1 — `.index` matches.
MediaPlaybackState? mediaPlaybackStateFromWire(Object? value) {
  if (value is! int) return null;
  return value >= 0 && value < MediaPlaybackState.values.length
      ? MediaPlaybackState.values[value]
      : null;
}

Object? mediaPlaybackStateToWire(MediaPlaybackState? value) => value?.index;
