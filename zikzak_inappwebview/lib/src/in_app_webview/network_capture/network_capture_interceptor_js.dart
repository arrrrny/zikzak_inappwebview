import 'dart:convert';

///Builds the JavaScript network interceptor injected into every page
///(at document start, in all frames) when the Network Capture API is
///enabled.
///
///The script monkey-patches `window.fetch` and `XMLHttpRequest` and reports
///events through the `__zikzakNetworkCapture__` JavaScript handler.
///Events fired before the Dart side has registered its handler are buffered
///in-page and flushed when [NetworkCaptureManager] calls
///`window.__zikzakNetworkCapture__.ready()`.
String buildNetworkCaptureInterceptorJs(Map<String, dynamic> config) {
  return networkCaptureInterceptorJsTemplate.replaceFirst(
    '@@CONFIG@@',
    jsonEncode(config),
  );
}

///The raw interceptor source. `@@CONFIG@@` is replaced with the JSON
///configuration at build time.
const String networkCaptureInterceptorJsTemplate = r'''
(function () {
  if (window.__zikzakNetworkCaptureInstalled__) return;
  window.__zikzakNetworkCaptureInstalled__ = true;

  var CONFIG = @@CONFIG@@;
  var HANDLER_NAME = '__zikzakNetworkCapture__';
  var MAX_QUEUE_SIZE = 500;

  var pageId = Date.now().toString(36) + Math.random().toString(36).slice(2, 10);
  var seq = 0;
  var reqCounter = 0;
  var queue = [];
  var dartReady = false;

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

  function emit(kind, payload) {
    payload.kind = kind;
    payload.pageId = pageId;
    payload.seq = ++seq;
    if (dartReady) {
      if (send(payload)) return;
    } else {
      // Optimistically send: the native handler may already be registered.
      // The event is also queued and re-sent on ready(); the Dart side
      // deduplicates by pageId + seq.
      send(payload);
    }
    if (queue.length < MAX_QUEUE_SIZE) queue.push(payload);
  }

  window.__zikzakNetworkCapture__ = {
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

  // ---------------- configuration helpers ----------------

  var regexes = null;
  if (
    CONFIG.patternType === 'regex' &&
    CONFIG.urlPatterns &&
    CONFIG.urlPatterns.length
  ) {
    regexes = [];
    for (var i = 0; i < CONFIG.urlPatterns.length; i++) {
      try {
        regexes.push(new RegExp(CONFIG.urlPatterns[i]));
      } catch (e) {}
    }
    if (!regexes.length) regexes = null;
  }

  function urlMatches(url) {
    var patterns = CONFIG.urlPatterns || [];
    if (!patterns.length) return true;
    if (regexes) {
      for (var i = 0; i < regexes.length; i++) {
        if (regexes[i].test(url)) return true;
      }
      return false;
    }
    for (var j = 0; j < patterns.length; j++) {
      if (url.indexOf(patterns[j]) !== -1) return true;
    }
    return false;
  }

  function resourceTypeEnabled(type) {
    var types = CONFIG.resourceTypes || ['xhr', 'fetch'];
    return types.indexOf(type) !== -1;
  }

  function shouldCapture(type, url) {
    return resourceTypeEnabled(type) && urlMatches(url);
  }

  var TEXTUAL_MIME =
    /json|text\/|xml|html|javascript|ecmascript|x-www-form-urlencoded|svg|csv|yaml|atom|rss/i;

  function isTextualMime(mime) {
    return TEXTUAL_MIME.test(mime || '');
  }

  function mimeAllowed(mime) {
    var mimes = CONFIG.mimeTypes || [];
    if (!mimes.length) return true;
    mime = (mime || '').toLowerCase();
    for (var i = 0; i < mimes.length; i++) {
      if (mime.indexOf(String(mimes[i]).toLowerCase()) !== -1) return true;
    }
    return false;
  }

  function nextId() {
    return pageId + '-' + ++reqCounter;
  }

  function nowMs() {
    return Date.now();
  }

  function truncateBody(str) {
    var max = CONFIG.maxBodySize != null ? CONFIG.maxBodySize : 50000;
    var total = str.length;
    if (total > max) {
      return {
        body:
          str.slice(0, max) + '... [truncated, total: ' + total + ' chars]',
        size: total,
        truncated: true
      };
    }
    return { body: str, size: total, truncated: false };
  }

  function arrayBufferToBase64(buffer) {
    var bytes = new Uint8Array(buffer);
    var binary = '';
    var chunk = 0x8000;
    for (var i = 0; i < bytes.length; i += chunk) {
      binary += String.fromCharCode.apply(
        null,
        bytes.subarray(i, Math.min(i + chunk, bytes.length))
      );
    }
    return btoa(binary);
  }

  function blobToBase64(blob) {
    return new Promise(function (resolve, reject) {
      var reader = new FileReader();
      reader.onloadend = function () {
        try {
          var result = reader.result || '';
          var comma = result.indexOf(',');
          resolve(comma >= 0 ? result.slice(comma + 1) : result);
        } catch (e) {
          reject(e);
        }
      };
      reader.onerror = reject;
      reader.readAsDataURL(blob);
    });
  }

  function cacheHint(url) {
    try {
      if (!window.performance || !performance.getEntriesByName) return false;
      var entries = performance.getEntriesByName(url);
      for (var i = 0; i < entries.length; i++) {
        var e = entries[i];
        if (e.transferSize === 0 && e.decodedBodySize > 0) return true;
      }
    } catch (e) {}
    return false;
  }

  // ---------------- request body serialization ----------------

  // Returns { body, isBinary } or null when async reading is required (Blob).
  function serializeBodySync(body) {
    if (body == null) return { body: null, isBinary: false };
    if (typeof body === 'string') return { body: body, isBinary: false };
    if (
      typeof URLSearchParams !== 'undefined' &&
      body instanceof URLSearchParams
    ) {
      return { body: body.toString(), isBinary: false };
    }
    if (typeof FormData !== 'undefined' && body instanceof FormData) {
      var parts = [];
      try {
        body.forEach(function (value, key) {
          if (typeof File !== 'undefined' && value instanceof File) {
            parts.push(
              encodeURIComponent(key) +
                '=[file name=' +
                value.name +
                ', size=' +
                value.size +
                ']'
            );
          } else {
            parts.push(
              encodeURIComponent(key) + '=' + encodeURIComponent(String(value))
            );
          }
        });
      } catch (e) {}
      return { body: parts.join('&'), isBinary: false };
    }
    if (typeof Blob !== 'undefined' && body instanceof Blob) return null;
    if (
      (typeof ArrayBuffer !== 'undefined' && body instanceof ArrayBuffer) ||
      (typeof ArrayBuffer !== 'undefined' &&
        ArrayBuffer.isView &&
        ArrayBuffer.isView(body))
    ) {
      var size =
        body.byteLength != null
          ? body.byteLength
          : body.buffer
            ? body.buffer.byteLength
            : 0;
      return { body: '[binary body, ' + size + ' bytes]', isBinary: true };
    }
    try {
      return { body: String(body), isBinary: false };
    } catch (e) {
      return { body: null, isBinary: false };
    }
  }

  function serializeBodyAsync(body, cb) {
    var sync = serializeBodySync(body);
    if (sync) {
      cb(sync.body, sync.isBinary);
      return;
    }
    if (body && typeof body.text === 'function' && isTextualMime(body.type)) {
      body.text().then(
        function (t) {
          cb(t, false);
        },
        function () {
          cb('[blob body, ' + body.size + ' bytes]', true);
        }
      );
    } else if (body) {
      cb('[binary body, ' + (body.size || 0) + ' bytes]', true);
    } else {
      cb(null, false);
    }
  }

  function headersToObject(headers) {
    var out = {};
    if (!headers) return out;
    try {
      if (typeof Headers !== 'undefined' && headers instanceof Headers) {
        headers.forEach(function (v, k) {
          out[k] = v;
        });
      } else if (Array.isArray(headers)) {
        for (var i = 0; i < headers.length; i++) out[headers[i][0]] = headers[i][1];
      } else {
        for (var k in headers) {
          if (Object.prototype.hasOwnProperty.call(headers, k))
            out[k] = String(headers[k]);
        }
      }
    } catch (e) {}
    return out;
  }

  // ---------------- fetch interception ----------------

  if (window.fetch) {
    var __originalFetch = window.fetch;
    window.fetch = function (resource, options) {
      options = options || {};
      var isRequest =
        typeof Request !== 'undefined' && resource instanceof Request;
      var url = isRequest ? resource.url : String(resource);
      var method = (
        options.method ||
        (isRequest ? resource.method : 'GET') ||
        'GET'
      ).toUpperCase();
      var headers = headersToObject(isRequest ? resource.headers : null);
      var optHeaders = headersToObject(options.headers);
      for (var hk in optHeaders) headers[hk] = optHeaders[hk];
      var id = nextId();
      var captured = shouldCapture('fetch', url);
      var startTime = performance.now();

      function emitRequest(bodyStr, isBinary) {
        emit('request', {
          requestId: id,
          url: url,
          method: method,
          headers: headers,
          body: bodyStr,
          bodyIsBinary: !!isBinary,
          resourceType: 'fetch',
          timestamp: nowMs()
        });
      }

      if (captured) {
        if (options.body != null) {
          serializeBodyAsync(options.body, emitRequest);
        } else if (isRequest && method !== 'GET' && method !== 'HEAD') {
          try {
            resource.clone().text().then(
              function (t) {
                emitRequest(t || null, false);
              },
              function () {
                emitRequest(null, false);
              }
            );
          } catch (e) {
            emitRequest(null, false);
          }
        } else {
          emitRequest(null, false);
        }
      }

      return __originalFetch.apply(window, arguments).then(
        function (response) {
          if (!captured) return response;
          var responseTime = performance.now();
          var resHeaders = headersToObject(response.headers);
          var mime = (response.headers.get('content-type') || '')
            .split(';')[0]
            .trim();
          var resUrl = response.url || url;

          emit('response', {
            requestId: id,
            url: resUrl,
            statusCode: response.status,
            statusText: response.statusText || '',
            headers: resHeaders,
            mimeType: mime,
            resourceType: 'fetch',
            timestamp: nowMs(),
            duration: Math.round(responseTime - startTime),
            fromCache: cacheHint(resUrl),
            fromServiceWorker: false
          });

          if (CONFIG.captureBodies !== false && mimeAllowed(mime)) {
            if (isTextualMime(mime)) {
              response.clone().text().then(
                function (text) {
                  var t = truncateBody(text || '');
                  emit('body', {
                    requestId: id,
                    url: resUrl,
                    body: t.body,
                    isBase64: false,
                    size: t.size,
                    truncated: t.truncated,
                    mimeType: mime
                  });
                },
                function () {}
              );
            } else if (CONFIG.captureBinaryBodies === true) {
              response.clone().arrayBuffer().then(
                function (buf) {
                  try {
                    var b64 = arrayBufferToBase64(buf);
                    emit('body', {
                      requestId: id,
                      url: resUrl,
                      body: b64,
                      isBase64: true,
                      size: buf.byteLength,
                      truncated: false,
                      mimeType: mime
                    });
                  } catch (e) {}
                },
                function () {}
              );
            }
          }
          return response;
        },
        function (err) {
          if (captured) {
            emit('error', {
              requestId: id,
              url: url,
              error: err && err.message ? err.message : String(err)
            });
          }
          throw err;
        }
      );
    };
  }

  // ---------------- XMLHttpRequest interception ----------------

  var __originalOpen = XMLHttpRequest.prototype.open;
  var __originalSend = XMLHttpRequest.prototype.send;
  var __originalSetHeader = XMLHttpRequest.prototype.setRequestHeader;

  XMLHttpRequest.prototype.open = function (method, url) {
    this.__zikzakMethod = (method || 'GET').toUpperCase();
    try {
      this.__zikzakUrl = new URL(url, window.location.href).href;
    } catch (e) {
      this.__zikzakUrl = String(url);
    }
    this.__zikzakHeaders = {};
    return __originalOpen.apply(this, arguments);
  };

  XMLHttpRequest.prototype.setRequestHeader = function (name, value) {
    if (this.__zikzakHeaders) this.__zikzakHeaders[name] = value;
    return __originalSetHeader.apply(this, arguments);
  };

  function parseXhrHeaders(raw) {
    var out = {};
    if (!raw) return out;
    var lines = raw.trim().split(/[\r\n]+/);
    for (var i = 0; i < lines.length; i++) {
      var idx = lines[i].indexOf(':');
      if (idx > 0)
        out[lines[i].slice(0, idx).trim()] = lines[i].slice(idx + 1).trim();
    }
    return out;
  }

  XMLHttpRequest.prototype.send = function (body) {
    var xhr = this;
    var id = nextId();
    var url = xhr.__zikzakUrl || '';
    var method = xhr.__zikzakMethod || 'GET';
    var captured = shouldCapture('xhr', url);
    var startTime = performance.now();

    if (captured) {
      serializeBodyAsync(body, function (bodyStr, isBinary) {
        emit('request', {
          requestId: id,
          url: url,
          method: method,
          headers: xhr.__zikzakHeaders || {},
          body: bodyStr,
          bodyIsBinary: !!isBinary,
          resourceType: 'xhr',
          timestamp: nowMs()
        });
      });
    }

    xhr.addEventListener('load', function () {
      if (!captured) return;
      var responseTime = performance.now();
      var resUrl = xhr.responseURL || url;
      var mime = (xhr.getResponseHeader('content-type') || '')
        .split(';')[0]
        .trim();

      emit('response', {
        requestId: id,
        url: resUrl,
        statusCode: xhr.status,
        statusText: xhr.statusText || '',
        headers: parseXhrHeaders(xhr.getAllResponseHeaders()),
        mimeType: mime,
        resourceType: 'xhr',
        timestamp: nowMs(),
        duration: Math.round(responseTime - startTime),
        fromCache: cacheHint(resUrl),
        fromServiceWorker: false
      });

      if (CONFIG.captureBodies === false || !mimeAllowed(mime)) return;

      function emitText(text) {
        var t = truncateBody(text || '');
        emit('body', {
          requestId: id,
          url: resUrl,
          body: t.body,
          isBase64: false,
          size: t.size,
          truncated: t.truncated,
          mimeType: mime
        });
      }

      var responseType = xhr.responseType || 'text';
      if (responseType === '' || responseType === 'text') {
        try {
          emitText(xhr.responseText);
        } catch (e) {}
      } else if (responseType === 'json') {
        try {
          emitText(JSON.stringify(xhr.response));
        } catch (e) {}
      } else if (responseType === 'document') {
        try {
          var xml = xhr.response
            ? new XMLSerializer().serializeToString(xhr.response)
            : '';
          emitText(xml);
        } catch (e) {}
      } else if (responseType === 'arraybuffer') {
        if (CONFIG.captureBinaryBodies === true && xhr.response) {
          try {
            var b64 = arrayBufferToBase64(xhr.response);
            emit('body', {
              requestId: id,
              url: resUrl,
              body: b64,
              isBase64: true,
              size: xhr.response.byteLength,
              truncated: false,
              mimeType: mime
            });
          } catch (e) {}
        }
      } else if (responseType === 'blob') {
        if (CONFIG.captureBinaryBodies === true && xhr.response) {
          blobToBase64(xhr.response).then(
            function (b64) {
              emit('body', {
                requestId: id,
                url: resUrl,
                body: b64,
                isBase64: true,
                size: xhr.response.size,
                truncated: false,
                mimeType: mime
              });
            },
            function () {}
          );
        } else if (isTextualMime(mime) && xhr.response) {
          xhr.response.text().then(
            function (text) {
              emitText(text);
            },
            function () {}
          );
        }
      }
    });

    function onFailure(kind) {
      if (!captured) return;
      emit('error', { requestId: id, url: url, error: kind });
    }
    xhr.addEventListener('error', function () {
      onFailure('Network error');
    });
    xhr.addEventListener('abort', function () {
      onFailure('Request aborted');
    });
    xhr.addEventListener('timeout', function () {
      onFailure('Request timed out');
    });

    return __originalSend.apply(this, arguments);
  };
})();
''';
