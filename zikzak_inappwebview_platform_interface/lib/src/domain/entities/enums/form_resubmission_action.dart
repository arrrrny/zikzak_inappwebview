///Class that represents the action to take used by the [PlatformWebViewCreationParams.onFormResubmission] event.
enum FormResubmissionAction {
  ///Resend data
  RESEND,
  ///Don't resend data
  DONT_RESEND,
}

///FormResubmissionAction wire values are sequential 0..n-1 — `.index` matches.
FormResubmissionAction? formResubmissionActionFromWire(Object? value) {
  if (value is! int) return null;
  return value >= 0 && value < FormResubmissionAction.values.length
      ? FormResubmissionAction.values[value]
      : null;
}

Object? formResubmissionActionToWire(FormResubmissionAction? value) =>
    value?.index;
