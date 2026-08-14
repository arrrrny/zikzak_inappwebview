import 'dart:convert';

///Builds a self-contained JS snippet that resolves a tap target during
///replay and clicks it.
///
///Resolution strategy (text-aware, in order):
///1. For each candidate selector in order, `document.querySelector` it;
///   when [textContent] is known, candidates whose resolved element contains
///   the recorded text are STRONGLY preferred over those that don't. This
///   fixes the case where an early candidate (e.g. a generic class or id)
///   matches a different element on the landing page — e.g. the seller link
///   instead of the product link on an order detail page.
///2. If no text-matching candidate exists, fall back to the first candidate
///   in order that matches anything.
///3. If nothing matched, fall back to a normalized [textContent] match among
///   actionable elements (`a, button, [role=button], input`).
///4. If still nothing, report `matched: false`.
///
///Dispatches `.click()` on the resolved element. Returns (via
///`evaluateJavascript`) a JSON string:
///`{"matched": bool, "usedSelector": string|null}`.
String resolveAndClickJs(
  List<String> selectorCandidates,
  String? textContent, {
  String? xpath,
}) {
  final selectorsJson = jsonEncode(selectorCandidates);
  final textJson = jsonEncode(textContent);
  final xpathJson = jsonEncode(xpath);
  return '''
(function () {
  var selectors = $selectorsJson;
  var text = $textJson;
  var xpath = $xpathJson;

  function normalize(t) {
    return String(t || '').trim().replace(/\\s+/g, ' ');
  }

  var wanted = text ? normalize(text) : null;

  function containsWanted(el) {
    if (!wanted) return false;
    try {
      return normalize(el.textContent).indexOf(wanted) !== -1;
    } catch (e) {
      return false;
    }
  }

  var el = null;
  var usedSelector = null;
  var fallback = null;
  var fallbackSelector = null;
  for (var i = 0; i < selectors.length; i++) {
    var sel = selectors[i];
    var found = null;
    try {
      found = document.querySelector(sel);
    } catch (e) {}
    if (!found) continue;
    if (!fallback) {
      fallback = found;
      fallbackSelector = sel;
    }
    if (containsWanted(found)) {
      el = found;
      usedSelector = sel;
      break;
    }
  }

  if (!el && fallback) {
    el = fallback;
    usedSelector = fallbackSelector;
  }

  // XPath fallback: recorded positional path survives class/structure shifts.
  if (!el && xpath) {
    try {
      var xr = document.evaluate(
        xpath, document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null
      );
      if (xr && xr.singleNodeValue) {
        el = xr.singleNodeValue;
        usedSelector = 'xpath:' + xpath;
      }
    } catch (e) {}
  }

  if (!el && wanted) {
    var actionable = document.querySelectorAll('a, button, [role="button"], input');
    for (var j = 0; j < actionable.length; j++) {
      if (normalize(actionable[j].textContent) === wanted) {
        el = actionable[j];
        break;
      }
    }
  }

  if (!el) {
    return JSON.stringify({ matched: false, usedSelector: null });
  }
  try {
    el.click();
  } catch (e) {}
  return JSON.stringify({ matched: true, usedSelector: usedSelector });
})();
''';
}

///Builds a self-contained JS snippet that returns `true` when any of
///[selectors] matches an element in the current document.
String matchesAnySelectorJs(List<String> selectors) {
  final selectorsJson = jsonEncode(selectors);
  return '''
(function () {
  var selectors = $selectorsJson;
  for (var i = 0; i < selectors.length; i++) {
    try {
      if (document.querySelector(selectors[i])) return true;
    } catch (e) {}
  }
  return false;
})();
''';
}
