import Foundation

let JAVASCRIPT_BRIDGE_JS_SOURCE = """
    window.\(JAVASCRIPT_BRIDGE_NAME) = {};
    window.\(JAVASCRIPT_BRIDGE_NAME)._callHandlerIdCounter = 0;
    window.\(JAVASCRIPT_BRIDGE_NAME).callHandler = function() {
        var _callHandlerID = ++window.\(JAVASCRIPT_BRIDGE_NAME)._callHandlerIdCounter;
        try {
            window.webkit.messageHandlers['callHandler'].postMessage(
                JSON.stringify({
                    'handlerName': arguments[0],
                    '_callHandlerID': _callHandlerID,
                    'args': JSON.stringify(Array.prototype.slice.call(arguments, 1))
                })
            );
        } catch(e) {
            // postMessage failed - reject the promise
            if (window.\(JAVASCRIPT_BRIDGE_NAME)[_callHandlerID]) {
                window.\(JAVASCRIPT_BRIDGE_NAME)[_callHandlerID].reject(e);
                delete window.\(JAVASCRIPT_BRIDGE_NAME)[_callHandlerID];
            }
            return Promise.reject(e);
        }
        return new Promise(function(resolve, reject) {
            window.\(JAVASCRIPT_BRIDGE_NAME)[_callHandlerID] = {resolve: resolve, reject: reject};
        });
    };
    """
