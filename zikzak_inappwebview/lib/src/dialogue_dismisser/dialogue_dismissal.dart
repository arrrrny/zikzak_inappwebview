///One dismissed overlay, reported by the dialogue dismisser script.
class DialogueDismissal {
  ///Which preset matched (`cookieConsent`, `gdpr`, `inAppDownload`,
  ///`newsletter` — never `all`; the concrete category is reported).
  final String preset;

  ///How the overlay was dismissed: `clicked` (an accept/close button inside
  ///the dialog was clicked) or `removed` (the element was removed and the
  ///page scroll-lock restored).
  final String method;

  ///Short normalized text snippet of the dismissed element.
  final String snippet;

  ///URL of the page the overlay was dismissed on.
  final String pageUrl;

  const DialogueDismissal({
    required this.preset,
    required this.method,
    required this.snippet,
    required this.pageUrl,
  });

  factory DialogueDismissal.fromJson(Map<String, dynamic> json) {
    return DialogueDismissal(
      preset: json['preset']?.toString() ?? '',
      method: json['method']?.toString() ?? '',
      snippet: json['snippet']?.toString() ?? '',
      pageUrl: json['pageUrl']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'preset': preset,
    'method': method,
    'snippet': snippet,
    'pageUrl': pageUrl,
  };

  @override
  String toString() =>
      'DialogueDismissal(preset: $preset, method: $method, snippet: $snippet, pageUrl: $pageUrl)';
}
