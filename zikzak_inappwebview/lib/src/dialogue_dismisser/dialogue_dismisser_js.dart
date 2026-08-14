import 'dart:convert';

import 'dialogue_dismiss_rules.dart';

///Name of the JavaScript handler the dialogue dismisser reports through.
const String kDialogueDismissedHandlerName = '__zikzakDialogueDismissed__';

///Builds the JavaScript dialogue dismisser injected into the main frame of
///every page (at document start) for the enabled [presets].
///
///The script scans for candidate overlay elements on DOM ready, on timed
///retries (500ms / 1500ms / 3000ms — consent banners are often injected
///late) and via a light MutationObserver for dialog-role insertions. A
///candidate is dismissed ONLY when its text content matches the keyword
///patterns of an enabled preset (mirror of the Dart-side
///`DialogueDismissRules`); non-matching sticky/fixed elements (price
///banners, nav bars, chat widgets) are never touched. Each dismissal is
///reported through the `__zikzakDialogueDismissed__` JavaScript handler;
///events fired before the Dart side has registered its handler are buffered
///in-page and flushed when the dismisser calls
///`window.__zikzakDialogueDismisser__.ready()`.
String buildDialogueDismisserJs(Set<DialogueDismissPreset> presets) {
  final expanded = DialogueDismissRules.expandPresets(presets);
  final patternMap = <String, List<String>>{
    for (final preset in DialogueDismissRules.concretePresets)
      if (expanded.contains(preset))
        preset.name: DialogueDismissRules.keywordPatterns[preset]!,
  };
  return dialogueDismisserJsTemplate
      .replaceFirst('__PRESET_PATTERNS__', jsonEncode(patternMap));
}

///The raw dismisser source.
const String dialogueDismisserJsTemplate = r'''
(function () {
  if (window.__zikzakDialogueDismisserInstalled__) return;
  window.__zikzakDialogueDismisserInstalled__ = true;

  var HANDLER_NAME = '__zikzakDialogueDismissed__';
  var MAX_QUEUE_SIZE = 100;
  // Re-rendered banners (SPA frameworks re-mount them) are removed again —
  // each cycle burns one dismissal, so the cap needs headroom.
  var MAX_DISMISSALS = 25;
  var MAX_SNIPPET_LENGTH = 120;
  var MAX_TEXT_LENGTH = 4000;
  var MIN_Z_INDEX = 10;
  var MIN_AREA_RATIO = 0.08;
  var MAX_REMOVE_AREA_RATIO = 0.95;

  var PRESET_PATTERNS = __PRESET_PATTERNS__;
  var PRESET_ORDER = ['cookieConsent', 'gdpr', 'inAppDownload', 'newsletter'];

  var STRONG_SELECTORS = [
    '#onetrust-consent-sdk',
    '#onetrust-banner-sdk',
    '.qc-cmp2-container',
    '#qc-cmp2-container',
    '#cookiebot',
    '#CybotCookiebotDialog',
    '[id*="cookie-consent"]',
    '[class*="cookie-consent"]',
    '[class*="smart-banner"]',
    '[id*="smart-banner"]',
    '[id*="gizlilik"]',
    '[class*="gizlilik"]',
    '[id*="privacy"]',
    '[class*="privacy"]',
    '[id*="popup"]',
    '[class*="popup"]',
    '[id*="banner"]',
    '[class*="banner"]',
    '[id*="modal"]',
    '[class*="modal"]'
  ];
  // Widened to catch Turkish privacy/KVKK and generic popup/banner/modal names.
  var CONSENT_NAME_RE = /cookie|consent|gdpr|cmp|gizlilik|privacy|kvkk|pop-up|popup|banner|modal|overlay/i;

  var queue = [];
  var dartReady = false;
  var dismissedCount = 0;
  var processed = [];
  var scanScheduled = false;

  function bridge() {
    try {
      var b = window.zikzak_inappwebview;
      if (b && typeof b.callHandler === 'function') return b;
    } catch (e) {}
    return null;
  }

  function send(payload) {
    var b = bridge();
    if (!b) return false;
    try {
      b.callHandler(HANDLER_NAME, payload);
      return true;
    } catch (e) {
      return false;
    }
  }

  function report(payload) {
    if (dartReady) {
      if (send(payload)) return;
    } else {
      // Optimistically send: the native handler may already be registered.
      // The event is also queued and re-sent on ready().
      send(payload);
    }
    if (queue.length < MAX_QUEUE_SIZE) queue.push(payload);
  }

  window.__zikzakDialogueDismisser__ = {
    ready: function () {
      dartReady = true;
      var q = queue.slice();
      queue.length = 0;
      var flushed = 0;
      for (var i = 0; i < q.length; i++) {
        if (send(q[i])) flushed++;
      }
      return flushed;
    },
    scan: function () {
      scan();
    }
  };

  // ---------------- keyword rules (mirror of DialogueDismissRules) ----------------

  function norm(s) {
    return String(s || '')
      .replace(/İ/g, 'i')
      .replace(/I/g, 'ı')
      .toLowerCase()
      .replace(/\s+/g, ' ')
      .trim();
  }

  var presetRegexes = null;
  function compilePresetRegexes() {
    if (presetRegexes) return presetRegexes;
    presetRegexes = {};
    for (var preset in PRESET_PATTERNS) {
      var list = PRESET_PATTERNS[preset] || [];
      var compiled = [];
      for (var i = 0; i < list.length; i++) {
        try {
          compiled.push(new RegExp(list[i]));
        } catch (e) {}
      }
      presetRegexes[preset] = compiled;
    }
    return presetRegexes;
  }

  function classify(text) {
    var compiled = compilePresetRegexes();
    for (var i = 0; i < PRESET_ORDER.length; i++) {
      var preset = PRESET_ORDER[i];
      var list = compiled[preset];
      if (!list) continue;
      for (var j = 0; j < list.length; j++) {
        if (list[j].test(text)) return preset;
      }
    }
    return null;
  }

  // ---------------- candidate detection ----------------

  // Collects VISIBLE text only: walks the (shadow-inclusive) tree, skipping
  // SCRIPT/STYLE/NOSCRIPT subtrees. Two hard-won lessons:
  //  - CMP web components (Efilli) put 60K+ of CSS at the TOP of their shadow
  //    root — reading raw textContent both wastes the text budget on CSS and
  //    drowns the real consent wording below it.
  //  - Script source text causes false matches ("uygulamayıIndir" inside a
  //    searchbox JS object matched inAppDownload and removed a header).
  function collectText(node, out, depth) {
    if (!node || depth > 10 || out.length > 200) return;
    if (node.nodeType === 3) {
      // Text node.
      out.push(node.nodeValue);
      return;
    }
    if (node.nodeType !== 1 && node.nodeType !== 11) return; // element/shadow root
    var tag = node.tagName;
    if (tag === 'SCRIPT' || tag === 'STYLE' || tag === 'NOSCRIPT') return;
    var kids = node.childNodes;
    for (var i = 0; i < kids.length; i++) collectText(kids[i], out, depth + 1);
    if (node.shadowRoot) collectText(node.shadowRoot, out, depth + 1);
  }

  function elementText(el) {
    var out = [];
    try {
      collectText(el, out, 0);
    } catch (e) {}
    var text = norm(out.join(' '));
    if (text.length > MAX_TEXT_LENGTH) text = text.substring(0, MAX_TEXT_LENGTH);
    return text;
  }

  function snippetOf(text) {
    if (text.length > MAX_SNIPPET_LENGTH) {
      return text.substring(0, MAX_SNIPPET_LENGTH);
    }
    return text;
  }

  function matchesStrongSelector(el) {
    if (!el.matches) return false;
    for (var i = 0; i < STRONG_SELECTORS.length; i++) {
      try {
        if (el.matches(STRONG_SELECTORS[i])) return true;
      } catch (e) {}
    }
    return false;
  }

  function hasConsentName(el) {
    var id = '';
    var cls = '';
    var tag = '';
    try {
      id = el.id || '';
      cls = typeof el.className === 'string' ? el.className : '';
      tag = el.tagName || '';
    } catch (e) {}
    // Tag names cover custom-element CMPs (Efilli, OneTrust web components).
    return (
      CONSENT_NAME_RE.test(id) ||
      CONSENT_NAME_RE.test(cls) ||
      /efilli|onetrust|cookiebot|didomi|consentmanager/i.test(tag)
    );
  }

  function viewportArea() {
    var w = window.innerWidth || document.documentElement.clientWidth || 0;
    var h = window.innerHeight || document.documentElement.clientHeight || 0;
    return w * h;
  }

  function isOverlayPositioned(el) {
    try {
      var style = window.getComputedStyle(el);
      if (style.position !== 'fixed' && style.position !== 'sticky') {
        return false;
      }
      var rect = el.getBoundingClientRect();
      var elArea = rect.width * rect.height;
      if (elArea < viewportArea() * MIN_AREA_RATIO) return false;
      // Dismissal is gated by TEXT MATCH later, so candidate gathering can be
      // permissive: only z-index values that are clearly in-page (below 10) are
      // rejected; missing/auto z-index is accepted (many consent banners don't
      // set one explicitly).
      var z = parseInt(style.zIndex, 10);
      if (!isNaN(z) && z < MIN_Z_INDEX) return false;
      return true;
    } catch (e) {
      return false;
    }
  }

  // Collects candidate overlays: { el, strong, overlay } where `strong`
  // marks known consent containers / dialog roles and `overlay` marks
  // fixed/sticky high-z overlays — both may be removed regardless of size
  // (full-screen consent backdrops cover ~100% of the viewport; only
  // non-overlay consent-NAMED elements stay size-capped so page content
  // that merely mentions cookies is never ripped out).
  function gatherCandidates() {
    var out = [];
    var body = document.body;
    if (!body) return out;

    for (var i = 0; i < STRONG_SELECTORS.length; i++) {
      var nodes;
      try {
        nodes = document.querySelectorAll(STRONG_SELECTORS[i]);
      } catch (e) {
        continue;
      }
      for (var j = 0; j < nodes.length; j++) {
        out.push({ el: nodes[j], strong: true, overlay: false });
      }
    }

    var dialogs = document.querySelectorAll('[role="dialog"], [aria-modal="true"]');
    for (var k = 0; k < dialogs.length; k++) {
      out.push({ el: dialogs[k], strong: true, overlay: false });
    }

    var all = body.querySelectorAll('*');
    for (var m = 0; m < all.length; m++) {
      var el = all[m];
      var consentName = hasConsentName(el);
      var overlayPositioned = isOverlayPositioned(el);
      if (consentName || overlayPositioned) {
        out.push({ el: el, strong: consentName, overlay: overlayPositioned });
      }
    }

    // Nested-candidate dedupe: when both an ancestor and its descendant are
    // candidates (e.g. a sticky header CONTAINING an app-download nudge),
    // keep only the deepest ones — removing the ancestor would take legit
    // content (search bar, nav) down with the nudge.
    var filtered = [];
    for (var a = 0; a < out.length; a++) {
      var hasCandidateDescendant = false;
      for (var b = 0; b < out.length; b++) {
        if (a === b) continue;
        try {
          if (out[a].el !== out[b].el && out[a].el.contains(out[b].el)) {
            hasCandidateDescendant = true;
            break;
          }
        } catch (e) {}
      }
      if (!hasCandidateDescendant) filtered.push(out[a]);
    }
    return filtered;
  }

  // ---------------- dismissal ----------------

  function restoreScroll() {
    try {
      document.documentElement.style.overflow = '';
      document.documentElement.style.margin = '';
      if (document.body) {
        document.body.style.overflow = '';
        document.body.style.margin = '';
      }
    } catch (e) {}
  }

  function removeElement(el) {
    try {
      if (el && el.parentNode && el !== document.body && el !== document.documentElement) {
        el.parentNode.removeChild(el);
        return true;
      }
    } catch (e) {}
    return false;
  }

  function canRemove(candidate) {
    // Strong consent containers and genuine overlays are always removable —
    // a full-screen fixed backdrop with consent text is exactly the target.
    if (candidate.strong || candidate.overlay) return true;
    // Non-overlay consent-named elements stay size-capped so in-page content
    // that merely mentions cookies is never removed.
    try {
      var rect = candidate.el.getBoundingClientRect();
      return rect.width * rect.height < viewportArea() * MAX_REMOVE_AREA_RATIO;
    } catch (e) {
      return false;
    }
  }

  // Walks DOWN from a matched candidate to the deepest descendant that still
  // classifies as a dialogue (crossing shadow roots) AND covers a meaningful
  // share of the VIEWPORT (not of the parent). Parent-relative floors break
  // on fixed full-app shells (Trendyol: consent banner ~20% of a 100% shell
  // → descent stops → whole shell, header included, would be removed). A
  // viewport-relative floor descends into real banners/nudges but stops
  // before bare text spans, so shadow consents still come out whole.
  var MIN_DESCEND_VIEWPORT_RATIO = 0.015;

  function descendToMatched(el) {
    var node = el;
    var guard = 0;
    while (guard++ < 10) {
      var kids = null;
      try {
        kids = node.shadowRoot ? node.shadowRoot.children : node.children;
      } catch (e) {
        break;
      }
      if (!kids || !kids.length) break;
      var next = null;
      for (var i = 0; i < kids.length; i++) {
        var t = elementText(kids[i]);
        if (!t || !classify(t)) continue;
        try {
          var kr = kids[i].getBoundingClientRect();
          if (kr.width * kr.height < viewportArea() * MIN_DESCEND_VIEWPORT_RATIO) {
            continue;
          }
        } catch (e) {}
        next = kids[i];
        break;
      }
      if (!next) break;
      // Stop at consent-named containers (sf-smart-banner, consent dialogs):
      // they ARE the popup — remove them whole instead of descending into
      // their text fragments and gutting only the inside.
      if (hasConsentName(next)) return next;
      node = next;
    }
    return node;
  }

  function dismissCandidate(candidate, preset, text) {
    // Consent-named containers (CMP web components like EFILLI-LAYOUT-DYNAMIC)
    // are removed AS A WHOLE — hiding/removing the host kills the entire
    // shadow-DOM consent (verified: Chrome "hide" on the host makes it gone).
    // Descending INTO the shadow root only guts inner fragments and can leave
    // the banner shell behind. Surgical descent is for regular overlays
    // (e.g. a sticky header containing an app-download nudge).
    var el = candidate.strong ? candidate.el : descendToMatched(candidate.el);

    // Final app-shell guard: never remove a main-DOM element that covers
    // ~the whole viewport unless it is a strong consent container. A fixed
    // full-screen app shell that merely CONTAINS consent text must survive;
    // shadow-internal backdrops (inside a strong host) stay removable.
    if (!candidate.strong) {
      try {
        var host = el.getRootNode && el.getRootNode();
        var inShadow = host && host !== document;
        var rect = el.getBoundingClientRect();
        if (!inShadow &&
            rect.width * rect.height >= viewportArea() * MAX_REMOVE_AREA_RATIO) {
          return;
        }
      } catch (e) {}
    }

    // Consistent with the legacy `dismissDialogues` approach: when a candidate
    // overlay is matched (by its text content and an enabled preset), we remove
    // the element directly. We do not click accept/close/reject buttons; sites
    // vary too much in event handling, and direct removal is the reliable way
    // to keep the page usable for the recording/replay flow.
    if (!canRemove(candidate)) return;
    if (!removeElement(el)) return;

    dismissedCount++;
    restoreScroll();
    report({
      preset: preset,
      method: 'removed',
      // Snippet of the element actually removed (the descended target), not
      // the outer candidate — otherwise logs show the header's text when only
      // the nudge strip inside it was removed.
      snippet: snippetOf(elementText(el) || text),
      pageUrl: String(window.location.href)
    });
  }

  function scan() {
    if (dismissedCount >= MAX_DISMISSALS) return;
    // Purge detached nodes: a site that re-appends the SAME element (SPA
    // frameworks keep node references) must be re-evaluated, not skipped
    // forever by the processed list.
    processed = processed.filter(function (e) {
      try {
        return e.isConnected;
      } catch (err) {
        return false;
      }
    });
    var candidates = gatherCandidates();
    for (var i = 0; i < candidates.length; i++) {
      if (dismissedCount >= MAX_DISMISSALS) return;
      var el = candidates[i].el;
      if (processed.indexOf(el) !== -1) continue;
      if (!el.isConnected) continue;
      var text = elementText(el);
      if (!text) continue; // not marked processed — shadow/late content retries later
      var preset = classify(text);
      if (!preset) continue; // Not a dialogue we know — leave it alone, retry later.
      // Only matched candidates are marked processed (whether removal
      // succeeds or not); unmatched ones are re-evaluated on later scans so
      // asynchronously-rendered consent text (shadow DOM, CMP hydration)
      // still gets classified once it appears.
      processed.push(el);
      dismissCandidate(candidates[i], preset, text);
    }
  }

  function scheduleScan() {
    if (scanScheduled) return;
    scanScheduled = true;
    setTimeout(function () {
      scanScheduled = false;
      scan();
    }, 300);
  }

  // ---------------- scheduling ----------------

  function startObserver() {
    if (!window.MutationObserver || !document.documentElement) return;
    try {
      var observer = new MutationObserver(function (mutations) {
        if (dismissedCount >= MAX_DISMISSALS) {
          observer.disconnect();
          return;
        }
        for (var i = 0; i < mutations.length; i++) {
          var added = mutations[i].addedNodes;
          for (var j = 0; j < added.length; j++) {
            var node = added[j];
            if (node.nodeType !== 1) continue;
            // Schedule on ANY element insertion. The CMP wrapper div itself
            // usually has no consent name — the consent-named/dialog elements
            // live deeper inside — so filtering on the added node alone misses
            // late-injected banners. scheduleScan() debounces to one scan per
            // 300ms, so a chatty DOM costs one extra pass, not N.
            scheduleScan();
            return;
          }
        }
      });
      observer.observe(document.documentElement, {
        childList: true,
        subtree: true
      });
    } catch (e) {}
  }

  function kickoff() {
    scan();
    // Consent banners are often injected late; retry a few times.
    setTimeout(scan, 500);
    setTimeout(scan, 1500);
    setTimeout(scan, 3000);
    startObserver();
    // The legacy `dismissDialogues` removal runs on `onLoadStop` — i.e. AFTER
    // the full page (incl. late CMP scripts) has loaded. Mirror that timing so
    // the smart dismisser fires at the same moment instead of giving up at 3s
    // post-DOMContentLoaded.
    if (document.readyState === 'complete') {
      setTimeout(scan, 400);
    } else {
      window.addEventListener('load', function () {
        setTimeout(scan, 400);
        setTimeout(scan, 1600);
        setTimeout(scan, 3200);
      });
    }
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', kickoff);
  } else {
    kickoff();
  }
})();
''';
