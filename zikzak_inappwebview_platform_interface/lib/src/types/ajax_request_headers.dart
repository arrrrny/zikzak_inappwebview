///Class that represents the HTTP headers of an [AjaxRequest].
///
///Hand-written (migration skip/fork — see PROGRESS.md migration map): this
///class is mutable by design and carries a custom method surface
///([getHeaders]/[setRequestHeader]) that Zorphy value objects cannot express,
///and its wire form is the accumulated `new headers` map rather than the
///fields of a value object. The `@ExchangeableObject` annotation here only
///generated a thin public wrapper; it is now a plain Dart class with an
///identical public API and wire format.
class AjaxRequestHeaders {
  Map<String, dynamic> _headers;
  Map<String, dynamic> _newHeaders = {};

  AjaxRequestHeaders(this._headers);

  ///Gets a possible [AjaxRequestHeaders] instance from a [Map] value.
  static AjaxRequestHeaders? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }

    return AjaxRequestHeaders(map);
  }

  ///Gets the HTTP headers of the [AjaxRequest].
  Map<String, dynamic> getHeaders() {
    return this._headers;
  }

  ///Sets/updates an HTTP header of the [AjaxRequest]. If there is already an existing [header] with the same name, the values are merged into one single request header.
  ///For security reasons, some headers can only be controlled by the user agent.
  ///These headers include the [forbidden header names](https://developer.mozilla.org/en-US/docs/Glossary/Forbidden_header_name)
  ///and [forbidden response header names](https://developer.mozilla.org/en-US/docs/Glossary/Forbidden_response_header_name).
  void setRequestHeader(String header, String value) {
    _newHeaders[header] = value;
  }

  ///Converts instance to a map.
  Map<String, dynamic> toMap() {
    return _newHeaders;
  }

  ///Converts instance to a map.
  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'AjaxRequestHeaders{headers: $_headers, requestHeaders: $_newHeaders}';
  }
}
