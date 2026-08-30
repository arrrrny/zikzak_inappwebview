import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';

void main() {
  group('DialogueDismissRules.normalizeText', () {
    test('applies Turkish-aware lowercase', () {
      expect(DialogueDismissRules.normalizeText('KABUL ET'), 'kabul et');
      expect(
        DialogueDismissRules.normalizeText('Uygulamayı İndir'),
        'uygulamayı indir',
      );
      // Dotless I must not become dotted i.
      expect(DialogueDismissRules.normalizeText('IZIN'), 'ızın');
    });

    test('collapses whitespace', () {
      expect(
        DialogueDismissRules.normalizeText('  accept   all\n cookies '),
        'accept all cookies',
      );
    });
  });

  group('DialogueDismissRules classification', () {
    test('Turkish cookie banner matches cookieConsent', () {
      expect(
        DialogueDismissRules.matchesPreset(
          'Bu site deneyiminizi iyileştirmek için çerezleri kullanır.',
          DialogueDismissPreset.cookieConsent,
        ),
        isTrue,
      );
      expect(
        DialogueDismissRules.matchesPreset(
          'Çerez Politikası',
          DialogueDismissPreset.cookieConsent,
        ),
        isTrue,
      );
      // Un-dotted spelling also matches.
      expect(
        DialogueDismissRules.matchesPreset(
          'cerez ayarlari',
          DialogueDismissPreset.cookieConsent,
        ),
        isTrue,
      );
    });

    test('"Kabul Et" matches gdpr', () {
      expect(
        DialogueDismissRules.matchesPreset(
          'Kabul Et',
          DialogueDismissPreset.gdpr,
        ),
        isTrue,
      );
      expect(
        DialogueDismissRules.matchesPreset(
          'Kişisel verilerin korunması (KVKK) kapsamında onayınızı istiyoruz.',
          DialogueDismissPreset.gdpr,
        ),
        isTrue,
      );
      expect(
        DialogueDismissRules.matchesPreset(
          'Gizlilik tercihlerinizi yönetin',
          DialogueDismissPreset.gdpr,
        ),
        isTrue,
      );
    });

    test('app-download banners match inAppDownload', () {
      expect(
        DialogueDismissRules.matchesPreset(
          'Uygulamayı İndir',
          DialogueDismissPreset.inAppDownload,
        ),
        isTrue,
      );
      expect(
        DialogueDismissRules.matchesPreset(
          "App Store'dan indir",
          DialogueDismissPreset.inAppDownload,
        ),
        isTrue,
      );
      expect(
        DialogueDismissRules.matchesPreset(
          'Download our app for a better experience',
          DialogueDismissPreset.inAppDownload,
        ),
        isTrue,
      );
      expect(
        DialogueDismissRules.matchesPreset(
          'Open in the App',
          DialogueDismissPreset.inAppDownload,
        ),
        isTrue,
      );
    });

    test('newsletter banners match newsletter', () {
      expect(
        DialogueDismissRules.matchesPreset(
          'Subscribe to our newsletter',
          DialogueDismissPreset.newsletter,
        ),
        isTrue,
      );
      expect(
        DialogueDismissRules.matchesPreset(
          'E-bültenimize kaydolun',
          DialogueDismissPreset.newsletter,
        ),
        isTrue,
      );
    });

    test('price/campaign banners match NOTHING', () {
      for (final preset in DialogueDismissRules.concretePresets) {
        expect(
          DialogueDismissRules.matchesPreset('Sepette %20 indirim', preset),
          isFalse,
          reason: '$preset must not match "Sepette %20 indirim"',
        );
        expect(
          DialogueDismissRules.matchesPreset('Kargo Bedava', preset),
          isFalse,
          reason: '$preset must not match "Kargo Bedava"',
        );
      }
      // Word boundary: `indir` must not match inside `indirim`.
      expect(
        DialogueDismissRules.matchesPreset(
          'Sepette %20 indirim',
          DialogueDismissPreset.inAppDownload,
        ),
        isFalse,
      );
    });

    test('preset .all matches all categories', () {
      expect(
        DialogueDismissRules.matchesPreset(
          'We use cookies',
          DialogueDismissPreset.all,
        ),
        isTrue,
      );
      expect(
        DialogueDismissRules.matchesPreset(
          'Kabul Et',
          DialogueDismissPreset.all,
        ),
        isTrue,
      );
      expect(
        DialogueDismissRules.matchesPreset(
          'Uygulamayı İndir',
          DialogueDismissPreset.all,
        ),
        isTrue,
      );
      expect(
        DialogueDismissRules.matchesPreset(
          'Subscribe to our newsletter',
          DialogueDismissPreset.all,
        ),
        isTrue,
      );
      expect(
        DialogueDismissRules.matchesPreset(
          'Kargo Bedava',
          DialogueDismissPreset.all,
        ),
        isFalse,
      );
    });

    test('classify honours the enabled preset set', () {
      // Single-preset dismisser rejects other categories.
      expect(
        DialogueDismissRules.classify('Kabul Et', {
          DialogueDismissPreset.cookieConsent,
        }),
        isNull,
      );
      expect(
        DialogueDismissRules.classify('Çerez kullanıyoruz', {
          DialogueDismissPreset.cookieConsent,
        }),
        DialogueDismissPreset.cookieConsent,
      );
      // gdpr text is rejected when only inAppDownload is enabled.
      expect(
        DialogueDismissRules.classify('Gizlilik tercihleri', {
          DialogueDismissPreset.inAppDownload,
        }),
        isNull,
      );
      // Non-matching text is never classified.
      expect(
        DialogueDismissRules.classify('Sepette %20 indirim', {
          DialogueDismissPreset.all,
        }),
        isNull,
      );
    });
  });

  group('buildDialogueDismisserJs', () {
    test('serializes enabled presets into the JS', () {
      final js = buildDialogueDismisserJs({
        DialogueDismissPreset.cookieConsent,
        DialogueDismissPreset.inAppDownload,
      });
      expect(js, contains('__zikzakDialogueDismissed__'));
      expect(js, contains('"cookieConsent"'));
      expect(js, contains('"inAppDownload"'));
      expect(js, contains('cookie'));
      expect(js, contains('çerez'));
      expect(js, contains('app store'));
      // Disabled presets must not be serialized.
      expect(js, isNot(contains('"gdpr"')));
      expect(js, isNot(contains('"newsletter"')));
      // Dismissal is now removal-only; no accept/close/reject button patterns.
      expect(js, isNot(contains('__REJECT_PATTERNS__')));
      expect(js, isNot(contains('__CLOSE_PATTERNS__')));
    });

    test('.all expands to every concrete preset', () {
      final js = buildDialogueDismisserJs({DialogueDismissPreset.all});
      for (final preset in DialogueDismissRules.concretePresets) {
        expect(js, contains('"${preset.name}"'));
      }
    });

    test('template is shadow-DOM aware (CMP web components)', () {
      final js = buildDialogueDismisserJs({DialogueDismissPreset.cookieConsent});
      expect(js, contains('shadowRoot'));
      // Unmatched candidates are re-evaluated on later scans (late shadow
      // content) — processed marking happens only after classification.
      expect(js, contains('retry later'));
    });

    test('no template placeholders remain', () {
      final js = buildDialogueDismisserJs({DialogueDismissPreset.all});
      expect(js, isNot(contains('__PRESET_PATTERNS__')));
      expect(js, isNot(contains('__REJECT_PATTERNS__')));
      expect(js, isNot(contains('__CLOSE_PATTERNS__')));
    });
  });

  group('DialogueDismisser', () {
    test('maybeCreate returns null for empty presets', () {
      expect(DialogueDismisser.maybeCreate(presets: {}), isNull);
    });

    test('buildUserScript is main-frame-only at document start', () {
      final dismisser = DialogueDismisser.maybeCreate(
        presets: {DialogueDismissPreset.cookieConsent},
      )!;
      final script = dismisser.buildUserScript();
      expect(script.groupName, 'zikzakDialogueDismisser');
      expect(script.injectionTime, UserScriptInjectionTime.AT_DOCUMENT_START);
      expect(script.forMainFrameOnly, isTrue);
      expect(script.source, contains('__zikzakDialogueDismissed__'));
    });

    test('mergeUserScripts appends the dismisser script', () {
      final dismisser = DialogueDismisser.maybeCreate(
        presets: {DialogueDismissPreset.all},
      )!;
      final merged = DialogueDismisser.mergeUserScripts(null, dismisser)!;
      expect(merged, hasLength(1));
      expect(merged.single.groupName, 'zikzakDialogueDismisser');
      // Null dismisser returns the caller scripts unchanged.
      expect(DialogueDismisser.mergeUserScripts(null, null), isNull);
    });

    test('mergeUserScripts keeps non-empty caller scripts and appends dismisser last', () {
      final dismisser = DialogueDismisser.maybeCreate(
        presets: {DialogueDismissPreset.cookieConsent},
      )!;
      final caller = UserScript(
        groupName: 'caller',
        source: 'console.log("hi");',
        injectionTime: UserScriptInjectionTime.AT_DOCUMENT_END,
        forMainFrameOnly: true,
      );

      final merged = DialogueDismisser.mergeUserScripts([caller], dismisser)!;
      expect(merged, hasLength(2), reason: 'caller script + dismisser script');
      expect(merged[0], same(caller), reason: 'caller script is preserved');
      expect(merged[1].groupName, 'zikzakDialogueDismisser');

      // Null dismisser returns only the caller script, unchanged.
      final passthrough = DialogueDismisser.mergeUserScripts([caller], null)!;
      expect(passthrough, hasLength(1));
      expect(passthrough.single, same(caller));
    });

    test('handleJsPayload routes dismissals to the callback', () {
      final received = <DialogueDismissal>[];
      final dismisser = DialogueDismisser.maybeCreate(
        presets: {DialogueDismissPreset.cookieConsent},
        onDismissal: received.add,
      )!;
      dismisser.handleJsPayload(const {
        'preset': 'cookieConsent',
        'method': 'removed',
        'snippet': 'Çerezleri kabul edin',
        'pageUrl': 'https://example.com/',
      });
      expect(received, hasLength(1));
      expect(received.single.preset, 'cookieConsent');
      expect(received.single.method, 'removed');
      expect(received.single.snippet, 'Çerezleri kabul edin');
      expect(received.single.pageUrl, 'https://example.com/');
      expect(dismisser.dismissals, hasLength(1));

      // Round-trips through JSON.
      final restored = DialogueDismissal.fromJson(received.single.toJson());
      expect(restored.preset, received.single.preset);
      expect(restored.method, received.single.method);
      expect(restored.snippet, received.single.snippet);
      expect(restored.pageUrl, received.single.pageUrl);
    });
  });

  group('recipe tap listener untrusted-event guard', () {
    test('tap listener JS ignores synthetic events', () {
      // The dismisser removes elements directly; the tap listener must still
      // ignore any synthetic events from the replayer or other scripts.
      expect(
        buildRecipeTapListenerJs(),
        contains('event.isTrusted === false'),
      );
    });
  });
}
