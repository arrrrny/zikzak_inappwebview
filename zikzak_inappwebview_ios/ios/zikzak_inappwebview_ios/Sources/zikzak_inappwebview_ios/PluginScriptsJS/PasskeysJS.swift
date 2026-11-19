//
//  PasskeysJS.swift
//  zikzak_inappwebview
//
//  GENERATED FILE - do not edit by hand.
//  Rendered by scripts/generate_passkeys_shim.sh from the canonical
//  zikzak_inappwebview_platform_interface passkeys_js_source.dart
//  (issues #358 macOS, #384 iOS). Edit the canonical source and
//  regenerate; hand edits fail the source-contract drift tests.
//
import UIKit
import WebKit

let PASSKEYS_JS_PLUGIN_SCRIPT_GROUP_NAME = "IN_APP_WEBVIEW_PASSKEYS_JS_PLUGIN_SCRIPT"

/// WebAuthn/passkey JS shim: overrides `navigator.credentials.create/get`
/// for PublicKeyCredential options and forwards the ceremony over the
/// plugin's JS-handler channel to the native `PasskeyBridge`
/// (ASAuthorizationController). Generated - see the file header.
let PASSKEYS_JS_SOURCE = """
(function() {
    if (window.__zikzakPasskeysShimInstalled) return;
    window.__zikzakPasskeysShimInstalled = true;

    // Frame-correct reply channel. Where the host registers the
    // 'PasskeyBridge' script-message handler WITH a reply (the
    // WKScriptMessageHandlerWithReply API), postMessage returns a promise
    // that WebKit resolves in the frame that sent the message. The legacy
    // JS-bridge reply is delivered through a main-frame evaluateJavaScript,
    // which can never resolve a promise that a cross-origin iframe
    // registered — the iframe's promise hangs until the relying party's own
    // timeout, which RP pages report as a generic "browser needs to be
    // updated" banner (issue #446 follow-up: the App Store Connect passkey
    // ceremony runs in an idmsa.apple.com iframe).
    function bridgeCall(payload) {
        var direct = window.webkit && window.webkit.messageHandlers && window.webkit.messageHandlers['PasskeyBridge'];
        if (direct) {
            return direct.postMessage(payload);
        }
        return window.\(JAVASCRIPT_BRIDGE_NAME).callHandler('PasskeyBridge', payload);
    }

    // Telemetry over the SAME native bridge (never console: Apple's widget
    // bundle no-ops console.* in production, and content-world mismatches
    // swallow console-forwarded lines). Fire-and-forget; the native side
    // answers {"ok": true} which the promise ignores. The telemetry gate
    // below is rendered to the native `PasskeyBridge.telemetryEnabled`
    // static by scripts/generate_passkeys_shim.sh — JS cannot read a Swift
    // static let, so the generator substitutes the literal flag value.
    var telemetryEnabled = \(PasskeyBridge.telemetryEnabled);
    function telemetry(message) {
        if (!telemetryEnabled) return;
        try {
            bridgeCall({ method: 'telemetry', options: { text: String(message).slice(0, 1200) } })
                .catch(function() {});
        } catch (e) {}
    }

    var B64URL_CHARS = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_';

    function b64urlEncode(buffer) {
        var bytes = new Uint8Array(buffer);
        var base64 = '';
        for (var i = 0; i < bytes.length; i += 3) {
            var b0 = bytes[i], b1 = bytes[i + 1], b2 = bytes[i + 2];
            var hasB1 = i + 1 < bytes.length, hasB2 = i + 2 < bytes.length;
            base64 += B64URL_CHARS[b0 >> 2];
            base64 += B64URL_CHARS[((b0 & 3) << 4) | (hasB1 ? b1 >> 4 : 0)];
            if (hasB1) base64 += B64URL_CHARS[((b1 & 15) << 2) | (hasB2 ? b2 >> 6 : 0)];
            if (hasB2) base64 += B64URL_CHARS[b2 & 63];
        }
        return base64;
    }

    function b64urlDecode(text) {
        var clean = String(text).replace(/[^A-Za-z0-9\\-_]/g, '');
        var padding = (4 - (clean.length % 4)) % 4;
        var base64 = clean.replace(/-/g, '+').replace(/_/g, '/');
        for (var i = 0; i < padding; i++) base64 += '=';
        var binary = atob(base64);
        var bytes = new Uint8Array(binary.length);
        for (var j = 0; j < binary.length; j++) bytes[j] = binary.charCodeAt(j);
        return bytes.buffer;
    }

    // WebAuthn transports binary fields (challenge, user.id, credential ids)
    // as ArrayBuffers, which JSON.stringify cannot carry. Mark each buffer
    // so the native side can decode it back with its base64url decoder.
    function encodeBinary(value) {
        if (value instanceof ArrayBuffer) return {'$b64url': b64urlEncode(value)};
        if (typeof ArrayBuffer !== 'undefined' && ArrayBuffer.isView(value)) {
            return {'$b64url': b64urlEncode(value.buffer.slice(value.byteOffset, value.byteOffset + value.byteLength))};
        }
        if (Array.isArray(value)) return value.map(encodeBinary);
        if (value && typeof value === 'object') {
            var out = {};
            for (var key in value) {
                if (Object.prototype.hasOwnProperty.call(value, key)) out[key] = encodeBinary(value[key]);
            }
            return out;
        }
        return value;
    }

    function bufferToBase64url(buffer) {
        return b64urlEncode(buffer);
    }

    function buildCredential(c) {
        var response;
        if (c.kind === 'attestation') {
            response = {
                clientDataJSON: b64urlDecode(c.response.clientDataJSON),
                attestationObject: b64urlDecode(c.response.attestationObject)
            };
        } else {
            response = {
                clientDataJSON: b64urlDecode(c.response.clientDataJSON),
                authenticatorData: b64urlDecode(c.response.authenticatorData),
                signature: b64urlDecode(c.response.signature),
                userHandle: c.response.userHandle ? b64urlDecode(c.response.userHandle) : null
            };
        }
        var credential = {
            id: c.id,
            rawId: b64urlDecode(c.rawId),
            type: "public-key",
            authenticatorAttachment: c.authenticatorAttachment || null,
            response: response,
            getClientExtensionResults: function() { return c.clientExtensionResults || {}; }
        };
        // Relying parties (idmsa.apple.com above all) serialize the resolved
        // credential immediately after the ceremony — either via
        // credential.toJSON() or JSON.stringify(credential). A plain object
        // without toJSON makes JSON.stringify emit ArrayBuffer fields as
        // "{}" and a missing toJSON throws where the widget calls it
        // directly — either failure surfaces to the user as the generic
        // "your browser needs to be updated" banner. The spec shape
        // (PublicKeyCredential.toJSON) base64url-encodes every ArrayBuffer.
        credential.toJSON = function() {
            var out = {
                id: this.id,
                rawId: bufferToBase64url(this.rawId),
                type: this.type,
                authenticatorAttachment: this.authenticatorAttachment,
                clientExtensionResults: this.getClientExtensionResults(),
                response: {}
            };
            var r = this.response;
            for (var key in r) {
                if (Object.prototype.hasOwnProperty.call(r, key)) {
                    out.response[key] = (r[key] instanceof ArrayBuffer)
                        ? bufferToBase64url(r[key]) : r[key];
                }
            }
            return out;
        };
        return credential;
    }

    // Server-round-trip observability: idmsa.apple.com POSTs the assertion
    // from inside its own frame; the app's network capture and CDP do not
    // mirror subframe traffic, so the only reliable vantage is a fetch/XHR
    // wrapper installed in this frame. Logs the request the RP makes with
    // the resolved credential and the response status/body-head, so a
    // server-side rejection ("Can't verify your account") is attributable
    // to an exact endpoint + payload + status instead of a guess.
    (function installNetworkLogger() {
        if (!telemetryEnabled) return; // no wrappers, no bridge traffic by default
        var origFetch = window.fetch;
        if (typeof origFetch === 'function') {
            window.fetch = function(input, init) {
                var url = (typeof input === 'string') ? input
                    : (input && input.url) || String(input);
                var isAuth = url.indexOf('/appleauth/') !== -1
                    || url.indexOf('/verify/') !== -1;
                var p = origFetch.call(window, input, init);
                if (isAuth) {
                    // A page may pass a Request object with no init — read
                    // method/body off the Request first, else init, else
                    // defaults (a bare `init && init.method` logs a
                    // misleading GET for `fetch(new Request(url, {method:
                    // 'POST', body}))`).
                    var method = (init && init.method) || (input && input.method) || 'GET';
                    var body = (init && init.body) || (input && input.body) || '';
                    p.then(function(resp) {
                        var clone = resp.clone();
                        clone.text().then(function(text) {
                            telemetry('FETCH ' + method
                                + ' ' + url + ' -> ' + resp.status
                                + ' body=' + String(body).slice(0, 300)
                                + ' resp=' + text.slice(0, 300));
                        }).catch(function() {
                            telemetry('FETCH ' + url + ' -> ' + resp.status + ' (body unread)');
                        });
                    }).catch(function(err) {
                        telemetry('FETCH ' + url + ' FAILED ' + err);
                    });
                }
                return p;
            };
        }
        var OrigOpen = XMLHttpRequest.prototype.open;
        var OrigSend = XMLHttpRequest.prototype.send;
        XMLHttpRequest.prototype.open = function(method, url) {
            this.__pkMethod = method;
            this.__pkUrl = url;
            return OrigOpen.apply(this, arguments);
        };
        XMLHttpRequest.prototype.send = function(body) {
            var xhr = this;
            var url = String(xhr.__pkUrl || '');
            if (url.indexOf('/appleauth/') !== -1 || url.indexOf('/verify/') !== -1) {
                xhr.addEventListener('loadend', function() {
                    telemetry('XHR ' + xhr.__pkMethod + ' ' + url
                        + ' -> ' + xhr.status
                        + ' body=' + String(body || '').slice(0, 300)
                        + ' resp=' + String(xhr.responseText || '').slice(0, 300));
                });
            }
            return OrigSend.apply(this, arguments);
        };
    })();

    function bridgeError(result) {
        var name = (result && result.error && result.error.name) || 'NotAllowedError';
        var message = (result && result.error && result.error.message) || 'The passkey ceremony failed.';
        return new DOMException(message, name);
    }

    function runCeremony(method, options) {
        var publicKey = options.publicKey;
        // WebAuthn defaults rp.id to the caller's effective domain, and the
        // authentication shape (PublicKeyCredentialRequestOptions) carries
        // the optional rpId at the top level — there is no `rp` object — so
        // normalize both shapes for the native bridge.
        var rpId = publicKey.rpId || (publicKey.rp && publicKey.rp.id) || location.hostname;
        // Spec-mandated SecurityError: rp.id must be a registrable suffix of
        // the caller's effective domain, rejected before any user gesture is
        // spent. (Ends-with is an approximation of the public-suffix list.)
        if (rpId !== location.hostname &&
            location.hostname.indexOf('.' + rpId) !== location.hostname.length - rpId.length - 1) {
            return Promise.reject(new DOMException('publicKey.rp.id is not a registrable suffix of the caller origin.', 'SecurityError'));
        }
        publicKey.rpId = rpId;
        publicKey.rp = Object.assign({name: location.hostname}, publicKey.rp);
        publicKey.rp.id = rpId;

        var signal = options.signal || null;
        if (signal && signal.aborted) {
            return Promise.reject(new DOMException('The operation was aborted.', 'AbortError'));
        }

        var payload = encodeBinary(publicKey);
        var bridgePromise = bridgeCall({
            method: method,
            options: payload
        }).then(function(result) {
            if (result && result.ok) return buildCredential(result.credential);
            throw bridgeError(result);
        });

        // Ceremony observability for relying parties that reject silently
        // (App Store Connect renders its "browser needs to be updated"
        // banner with no console output when serialization or the server
        // round-trip fails). Marks resolve/reject on the shim side so a
        // failed run can be attributed to either the page's use of the
        // credential (this fires) or a native bridge failure (it does not).
        bridgePromise.then(
            function(credential) {
                // The exact bytes the RP receives, logged over the native
                // bridge — distinguishes a client-side serialization failure
                // from a server rejection. Runs here (not after the signal
                // branch) so ceremonies without an AbortSignal log too.
                try {
                    var j = JSON.stringify(credential.toJSON());
                    telemetry('assertion-toJSON=' + j.slice(0, 900));
                } catch (e1) {
                    telemetry('assertion-toJSON THREW: ' + e1.message);
                }
                try {
                    var probe = JSON.stringify(credential);
                    telemetry('ceremony RESOLVED method=' + method +
                        ' serializeOK=' + (typeof probe === 'string' && probe.length > 10) +
                        ' len=' + (probe ? probe.length : 0));
                } catch (e) {
                    telemetry('ceremony RESOLVED but serialization threw: ' + e.message);
                }
            },
            function(error) {
                telemetry('ceremony REJECTED method=' + method +
                    ' name=' + (error && error.name) + ' msg=' + (error && error.message));
            }
        );

        if (!signal) return bridgePromise;
        return new Promise(function(resolve, reject) {
            var onAbort = function() {
                // Cancel the outstanding ASAuthorizationController; the
                // late native resolve is ignored because this promise is
                // already settled.
                bridgeCall({method: 'cancel'}).catch(function() {});
                reject(new DOMException('The operation was aborted.', 'AbortError'));
            };
            signal.addEventListener('abort', onAbort, {once: true});
            bridgePromise.then(
                function(credential) { signal.removeEventListener('abort', onAbort); resolve(credential); },
                function(error) { signal.removeEventListener('abort', onAbort); reject(error); }
            );
        });
    }

    var credentials = navigator.credentials;
    if (!credentials) return;
    var originalCreate = credentials.create ? credentials.create.bind(credentials) : null;
    var originalGet = credentials.get ? credentials.get.bind(credentials) : null;

    navigator.credentials.create = function(options) {
        if (options && options.publicKey) return runCeremony('create', options);
        if (originalCreate) return originalCreate(options);
        return Promise.reject(new DOMException('Credential type not supported.', 'NotSupportedError'));
    };
    navigator.credentials.get = function(options) {
        if (options && options.publicKey) return runCeremony('get', options);
        if (originalGet) return originalGet(options);
        return Promise.reject(new DOMException('Credential type not supported.', 'NotSupportedError'));
    };

    // Feature-detection surface: sites gate passkey UX on these statics.
    // If WebKit never exposed PublicKeyCredential (mediation broken), define
    // a minimal stand-in so `window.PublicKeyCredential` checks pass.
    if (typeof window.PublicKeyCredential === 'undefined') {
        window.PublicKeyCredential = function() {};
    }
    window.PublicKeyCredential.isUserVerifyingPlatformAuthenticatorAvailable = function() {
        return bridgeCall({method: 'isUvPaa'})
            .then(function(result) { return !!(result && result.ok && result.available); })
            .catch(function() { return false; });
    };
    window.PublicKeyCredential.isConditionalMediationAvailable = function() {
        // Conditional UI (autofill) is not bridged; report unavailable so
        // sites fall back to modal ceremonies, which ARE bridged.
        return Promise.resolve(false);
    };
    // idmsa.apple.com's widget calls getClientCapabilities() when present
    // and reads `hybridTransport` / `passkeyPlatformAuthenticator` off the
    // result to decide whether passkeys are usable; a missing static reads
    // as supported (it guards `void 0 !==`), but a throw inside the call is
    // caught and ALSO reads as supported — so this only formalizes the
    // capability surface the widget already assumes. Values match what the
    // bridge actually supports: platform authenticator yes (isUvPaa),
    // hybrid (QR/phone) yes since the bluetooth entitlement, conditional
    // get (autofill) no. `userVerifyingPlatformAuthenticator` is a live
    // `isUvPaa` probe rather than a hardcoded `true`: on a device with no
    // platform authenticator the probe returns false, and a static `true`
    // here would disagree with the probe the same widget also calls.
    if (typeof window.PublicKeyCredential.getClientCapabilities !== 'function') {
        window.PublicKeyCredential.getClientCapabilities = function() {
            return window.PublicKeyCredential
                .isUserVerifyingPlatformAuthenticatorAvailable()
                .then(function(uv) {
                    return {
                        conditionalGet: false,
                        conditionalCreate: false,
                        hybridTransport: true,
                        passkeyPlatformAuthenticator: true,
                        userVerifyingPlatformAuthenticator: !!uv,
                        relatedOrigins: false,
                        signalAvailable: true
                    };
                });
        };
    }
})();
"""

let PASSKEYS_JS_PLUGIN_SCRIPT = PluginScript(
    groupName: PASSKEYS_JS_PLUGIN_SCRIPT_GROUP_NAME,
    source: PASSKEYS_JS_SOURCE,
    injectionTime: .atDocumentStart,
    forMainFrameOnly: false,
    requiredInAllContentWorlds: false,
    messageHandlerNames: [])
