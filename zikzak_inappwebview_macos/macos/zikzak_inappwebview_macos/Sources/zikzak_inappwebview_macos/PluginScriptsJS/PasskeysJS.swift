import Foundation

let PASSKEYS_JS_PLUGIN_SCRIPT_GROUP_NAME = "IN_APP_WEBVIEW_PASSKEYS_JS_PLUGIN_SCRIPT"

/// Issue #358 — WebAuthn/passkey JS shim.
///
/// WebKit's in-page WKWebView WebAuthn mediation is broken for entitled
/// custom-browser apps (zuraffa_browser#278): `navigator.credentials.*`
/// dies inside ASCAgent ~2 ms after "Allowing request from web browser."
/// with `AuthorizationError Code=1` and no UI. This shim bypasses WebKit
/// mediation entirely: `navigator.credentials.create/get` calls carrying
/// `publicKey` options are forwarded over the plugin's JS-handler channel
/// to the native `PasskeyBridge` (ASAuthorizationController), and the
/// result is shaped back into a PublicKeyCredential-quacking object.
/// Password/OTP credential calls fall through to the platform default.
let PASSKEYS_JS_SOURCE = """
(function() {
    if (window.__zikzakPasskeysShimInstalled) return;
    window.__zikzakPasskeysShimInstalled = true;

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
        return {
            id: c.id,
            rawId: b64urlDecode(c.rawId),
            type: "public-key",
            authenticatorAttachment: c.authenticatorAttachment || null,
            response: response,
            getClientExtensionResults: function() { return c.clientExtensionResults || {}; }
        };
    }

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
        var bridgePromise = window.\(JAVASCRIPT_BRIDGE_NAME).callHandler('PasskeyBridge', {
            method: method,
            options: payload
        }).then(function(result) {
            if (result && result.ok) return buildCredential(result.credential);
            throw bridgeError(result);
        });

        if (!signal) return bridgePromise;
        return new Promise(function(resolve, reject) {
            var onAbort = function() {
                // Cancel the outstanding ASAuthorizationController; the
                // late native resolve is ignored because this promise is
                // already settled.
                window.\(JAVASCRIPT_BRIDGE_NAME).callHandler('PasskeyBridge', {method: 'cancel'});
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
        return window.\(JAVASCRIPT_BRIDGE_NAME).callHandler('PasskeyBridge', {method: 'isUvPaa'})
            .then(function(result) { return !!(result && result.ok && result.available); })
            .catch(function() { return false; });
    };
    window.PublicKeyCredential.isConditionalMediationAvailable = function() {
        // Conditional UI (autofill) is not bridged; report unavailable so
        // sites fall back to modal ceremonies, which ARE bridged.
        return Promise.resolve(false);
    };
})();
"""
