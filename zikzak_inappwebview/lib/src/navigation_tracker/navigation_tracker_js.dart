///Name of the JavaScript handler the navigation tracker reports through.
const String kNavigationTrackerHandlerName = '__zikzakNavigationTracker__';

///Builds the JavaScript navigation tracker injected into every page
///(at document start, in all frames).
///
///The script monkey-patches `history.pushState`/`replaceState` and listens
///to `popstate`/`hashchange`/`pageshow`, reporting each URL change through
///the `__zikzakNavigationTracker__` JavaScript handler with trigger
///`'jsHistory'`. Events fired before the Dart side has registered its
///handler are buffered in-page and flushed when `NavigationTracker` calls
///`window.__zikzakNavigationTracker__.ready()` (same pattern as the
///network capture interceptor).
String buildNavigationTrackerJs() => navigationTrackerJsTemplate;

///The raw tracker source.
const String navigationTrackerJsTemplate = r'''
(function () {
  if (window.__zikzakNavigationTrackerInstalled__) return;
  window.__zikzakNavigationTrackerInstalled__ = true;

  var HANDLER_NAME = '__zikzakNavigationTracker__';
  var MAX_QUEUE_SIZE = 500;

  var queue = [];
  var dartReady = false;
  var lastUrl = null;

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

  function currentUrl() {
    try {
      return String(window.location.href);
    } catch (e) {
      return '';
    }
  }

  function isMainFrame() {
    try {
      return window.top === window.self;
    } catch (e) {
      return false;
    }
  }

  function emit() {
    var url = currentUrl();
    if (!url || url === lastUrl) return;
    lastUrl = url;
    var payload = {
      url: url,
      trigger: 'jsHistory',
      isMainFrame: isMainFrame(),
      timestamp: Date.now()
    };
    if (dartReady) {
      if (send(payload)) return;
    } else {
      // Optimistically send: the native handler may already be registered.
      // The event is also queued and re-sent on ready(); the Dart side
      // deduplicates by url + timestamp.
      send(payload);
    }
    if (queue.length < MAX_QUEUE_SIZE) queue.push(payload);
  }

  window.__zikzakNavigationTracker__ = {
    ready: function () {
      dartReady = true;
      var q = queue.slice();
      queue.length = 0;
      var flushed = 0;
      for (var i = 0; i < q.length; i++) {
        if (send(q[i])) flushed++;
      }
      return flushed;
    }
  };

  if (window.history) {
    var wrapHistory = function (method) {
      var original = window.history[method];
      if (typeof original !== 'function') return;
      window.history[method] = function () {
        var result = original.apply(window.history, arguments);
        emit();
        return result;
      };
    };
    wrapHistory('pushState');
    wrapHistory('replaceState');
  }

  window.addEventListener('popstate', emit);
  window.addEventListener('hashchange', emit);
  window.addEventListener('pageshow', emit);

  // Record the initial document URL.
  lastUrl = null;
  emit();
})();
''';
