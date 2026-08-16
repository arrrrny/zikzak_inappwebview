///Pure-Dart keyword rules for the content-aware dialogue dismisser.
///
///The dismisser script (`dialogue_dismisser_js.dart`) mirrors these rules in
///JavaScript; keeping them in Dart makes them unit-testable.
library;

///Content category a dismissed overlay belongs to.
///
///`all` is a meta-preset meaning the union of the four concrete presets —
///it is NOT the legacy brute-force `dismissDialogues` behaviour.
enum DialogueDismissPreset {
  cookieConsent,
  gdpr,
  inAppDownload,
  newsletter,
  all,
}

///Keyword rules used to classify candidate overlay elements by their text
///content. A candidate overlay is dismissed ONLY when its (normalized) text
///matches at least one pattern of an enabled preset; non-matching sticky /
///fixed elements (price banners, nav bars, chat widgets) are never touched.
class DialogueDismissRules {
  DialogueDismissRules._();

  ///Keyword patterns per concrete preset. Patterns are JS- AND Dart-compatible
  ///regular expressions, matched against [normalizeText] output
  ///(Turkish-aware lowercase, collapsed whitespace).
  static const Map<DialogueDismissPreset, List<String>> keywordPatterns =
      <DialogueDismissPreset, List<String>>{
        DialogueDismissPreset.cookieConsent: <String>[
          r'cookie',
          r'çerez',
          r'cerez',
        ],
        DialogueDismissPreset.gdpr: <String>[
          r'consent',
          r'gdpr',
          r'kvkk',
          r'privacy',
          r'gizlilik',
          r'kişisel veri',
          r'accept all',
          r'kabul et',
          r'tercihler',
        ],
        DialogueDismissPreset.inAppDownload: <String>[
          r'download.{0,20}app',
          r'app store',
          r'google play',
          r'uygulama',
          r'\bindir\b',
          r'open in.{0,20}app',
          r'uygulamada aç',
        ],
        DialogueDismissPreset.newsletter: <String>[
          r'newsletter',
          r'subscribe',
          r'e-bülten',
          r'bülten',
        ],
      };

  ///The concrete (non-`all`) presets, in classification priority order.
  static const List<DialogueDismissPreset> concretePresets =
      <DialogueDismissPreset>[
        DialogueDismissPreset.cookieConsent,
        DialogueDismissPreset.gdpr,
        DialogueDismissPreset.inAppDownload,
        DialogueDismissPreset.newsletter,
      ];

  ///Expands [presets], replacing `all` with the four concrete presets.
  static Set<DialogueDismissPreset> expandPresets(
    Set<DialogueDismissPreset> presets,
  ) {
    if (presets.contains(DialogueDismissPreset.all)) {
      return Set<DialogueDismissPreset>.of(concretePresets);
    }
    return Set<DialogueDismissPreset>.of(presets);
  }

  ///Turkish-aware lowercase + whitespace collapse. `İ` → `i`, `I` → `ı`
  ///before lowercasing so keyword matching is stable across locales.
  static String normalizeText(String text) {
    final buf = StringBuffer();
    for (final rune in text.runes) {
      var ch = String.fromCharCode(rune);
      if (ch == 'İ') ch = 'i';
      if (ch == 'I') ch = 'ı';
      buf.write(ch);
    }
    return buf.toString().toLowerCase().replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  ///Whether [text] matches the keyword patterns of [preset]. `all` matches
  ///any concrete preset.
  static bool matchesPreset(String text, DialogueDismissPreset preset) {
    final normalized = normalizeText(text);
    final presets = preset == DialogueDismissPreset.all
        ? concretePresets
        : <DialogueDismissPreset>[preset];
    for (final p in presets) {
      for (final pattern in keywordPatterns[p]!) {
        if (RegExp(pattern).hasMatch(normalized)) return true;
      }
    }
    return false;
  }

  ///Classifies [text] against the enabled [presets], returning the first
  ///matching concrete preset, or `null` when nothing matches (the caller
  ///must then leave the element alone).
  static DialogueDismissPreset? classify(
    String text,
    Set<DialogueDismissPreset> presets,
  ) {
    final normalized = normalizeText(text);
    final enabled = expandPresets(presets);
    for (final preset in concretePresets) {
      if (!enabled.contains(preset)) continue;
      for (final pattern in keywordPatterns[preset]!) {
        if (RegExp(pattern).hasMatch(normalized)) return preset;
      }
    }
    return null;
  }
}
