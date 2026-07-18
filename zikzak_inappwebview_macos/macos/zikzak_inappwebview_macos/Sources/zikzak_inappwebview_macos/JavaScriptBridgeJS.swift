import Foundation

let JAVASCRIPT_BRIDGE_JS_SOURCE = """
    window.\(JAVASCRIPT_BRIDGE_NAME) = {};
    window.\(JAVASCRIPT_BRIDGE_NAME).callHandler = function() {
        var _callHandlerID = setTimeout(function(){});
        window.webkit.messageHandlers['callHandler'].postMessage({
            'handlerName': arguments[0],
            '_callHandlerID': _callHandlerID,
            'args': JSON.stringify(Array.prototype.slice.call(arguments, 1))
        });
        return new Promise(function(resolve, reject) {
            window.\(JAVASCRIPT_BRIDGE_NAME)[_callHandlerID] = {resolve: resolve, reject: reject};
        });
    };
    """
