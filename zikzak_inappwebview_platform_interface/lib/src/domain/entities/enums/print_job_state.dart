///Class representing the state of a [PlatformPrintJobController].
enum PrintJobState {
  ///Print job state: The print job is being created but not yet ready to be printed.
  ///
  ///Next valid states: [QUEUED].
  CREATED,

  ///Print job state: The print jobs is created, it is ready to be printed and should be processed.
  ///
  ///Next valid states: [STARTED], [FAILED], [CANCELED].
  QUEUED,

  ///Print job state: The print job is being printed.
  ///
  ///Next valid states: [COMPLETED], [FAILED], [CANCELED], [BLOCKED].
  STARTED,

  ///Print job state: The print job is blocked.
  ///
  ///Next valid states: [FAILED], [CANCELED], [STARTED].
  BLOCKED,

  ///Print job state: The print job is successfully printed. This is a terminal state.
  ///
  ///Next valid states: None.
  COMPLETED,

  ///Print job state: The print job was printing but printing failed.
  ///
  ///Next valid states: None.
  FAILED,

  ///Print job state: The print job is canceled. This is a terminal state.
  ///
  ///Next valid states: None.
  CANCELED,
}

///PrintJobState wire values are 1-based (CREATED=1 .. CANCELED=7) — a plain
///enum's `.index` is offset by one.
PrintJobState? printJobStateFromWire(int? value) =>
    value != null && value >= 1 && value <= PrintJobState.values.length
    ? PrintJobState.values[value - 1]
    : null;

int? printJobStateToWire(PrintJobState? state) =>
    state == null ? null : state.index + 1;
