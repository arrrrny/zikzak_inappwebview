//
//  WebMessageListenerJS.swift
//  zikzak_inappwebview
//
//  macOS port of the iOS WebMessageListenerJS. Provides the in-page
//  FlutterInAppWebViewWebMessageListener constructor + the origin-matching
//  helpers. See issue #197.
//

import Foundation

let WEB_MESSAGE_LISTENER_JS_SOURCE = """
function FlutterInAppWebViewWebMessageListener(jsObjectName) {
    this.jsObjectName = jsObjectName;
    this.listeners = [];
    this.onmessage = null;
}
FlutterInAppWebViewWebMessageListener.prototype.postMessage = function(data) {
    var message = {
        "data": window.ArrayBuffer != null && data instanceof ArrayBuffer ? Array.from(new Uint8Array(data)) : (data != null ? data.toString() : null),
        "type": window.ArrayBuffer != null && data instanceof ArrayBuffer ? 1 : 0
    };
    window.webkit.messageHandlers['onWebMessageListenerPostMessageReceived'].postMessage({jsObjectName: this.jsObjectName, message: message});
};
FlutterInAppWebViewWebMessageListener.prototype.addEventListener = function(type, listener) {
    if (listener == null) {
        return;
    }
    this.listeners.push(listener);
};
FlutterInAppWebViewWebMessageListener.prototype.removeEventListener = function(type, listener) {
    if (listener == null) {
        return;
    }
    var index = this.listeners.indexOf(listener);
    if (index >= 0) {
        this.listeners.splice(index, 1);
    }
};

window.\(JAVASCRIPT_BRIDGE_NAME)._isOriginAllowed = function(allowedOriginRules, scheme, host, port) {
    for (var rule of allowedOriginRules) {
        if (rule === "*") {
            return true;
        }
        if (scheme == null || scheme === "") {
            continue;
        }
        var rulePort = rule.port == null || rule.port === 0 ? (rule.scheme == "https" ? 443 : 80) : rule.port;
        var currentPort = port === 0 || port === "" || port == null ? (scheme == "https" ? 443 : 80) : port;

        var schemeAllowed = scheme == rule.scheme;

        var hostAllowed = rule.host == null ||
            rule.host === "" ||
            host === rule.host ||
            (rule.host[0] === "*" && host != null && host.indexOf(rule.host.split("*")[1]) >= 0);

        var portAllowed = rulePort === currentPort;

        if (schemeAllowed && hostAllowed && portAllowed) {
            return true;
        }
    }
    return false;
}
"""
