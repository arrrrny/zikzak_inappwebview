///Class that represents the error code for a web authentication session error.
enum WebAuthenticationSessionError {
  ///The login has been canceled.
  CANCELED_LOGIN,

  ///A context wasn’t provided.
  PRESENTATION_CONTEXT_NOT_PROVIDED,

  ///The context was invalid.
  PRESENTATION_CONTEXT_INVALID,
}

///WebAuthenticationSessionError wire values are 1-based (CANCELED_LOGIN=1,
///PRESENTATION_CONTEXT_NOT_PROVIDED=2, PRESENTATION_CONTEXT_INVALID=3) — a
///plain enum's `.index` is offset by one.
WebAuthenticationSessionError? webAuthenticationSessionErrorFromWire(
  int? value,
) =>
    value != null &&
        value >= 1 &&
        value <= WebAuthenticationSessionError.values.length
    ? WebAuthenticationSessionError.values[value - 1]
    : null;

int? webAuthenticationSessionErrorToWire(
  WebAuthenticationSessionError? error,
) => error == null ? null : error.index + 1;
