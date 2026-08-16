///Constants that describe the results summary the find panel UI includes.
enum SearchResultDisplayStyle {
  ///The find panel includes the total number of results the session reports and the index of the target result.
  CURRENT_AND_TOTAL,

  ///The find panel includes the total number of results the session reports.
  TOTAL,

  ///The find panel doesn’t include the number of results the session reports.
  NONE,
}

SearchResultDisplayStyle? searchResultDisplayStyleFromWire(Object? value) {
  if (value is! int) return null;
  return value >= 0 && value < SearchResultDisplayStyle.values.length
      ? SearchResultDisplayStyle.values[value]
      : null;
}

Object? searchResultDisplayStyleToWire(SearchResultDisplayStyle? value) =>
    value?.index;
