import Foundation

let JAVASCRIPT_BRIDGE_NAME = "flutter_inappwebview"

let FIND_TEXT_HIGHLIGHT_JS_SOURCE = """
window.\(JAVASCRIPT_BRIDGE_NAME) = window.\(JAVASCRIPT_BRIDGE_NAME) || {};
window.\(JAVASCRIPT_BRIDGE_NAME)._searchResultCount = 0;
window.\(JAVASCRIPT_BRIDGE_NAME)._currentHighlight = 0;
window.\(JAVASCRIPT_BRIDGE_NAME)._isDoneCounting = false;

window.\(JAVASCRIPT_BRIDGE_NAME)._findAllAsyncForElement = function(element, keyword) {
  if (element) {
    if (element.nodeType == 3) {
      // Text node
      var elementTmp = element;
      while (true) {
        var value = elementTmp.nodeValue;
        var idx = value.toLowerCase().indexOf(keyword);

        if (idx < 0) break;

        var span = document.createElement("span");
        var text = document.createTextNode(value.substr(idx, keyword.length));
        span.appendChild(text);

        span.setAttribute(
          "id",
          "\(JAVASCRIPT_BRIDGE_NAME)_SEARCH_WORD_" + window.\(JAVASCRIPT_BRIDGE_NAME)._searchResultCount
        );
        span.setAttribute("class", "\(JAVASCRIPT_BRIDGE_NAME)_Highlight");
        var backgroundColor = window.\(JAVASCRIPT_BRIDGE_NAME)._searchResultCount == 0 ? "#FF9732" : "#FFFF00";
        span.setAttribute("style", "color: #000 !important; background: " + backgroundColor + " !important; padding: 0px !important; margin: 0px !important; border: 0px !important;");

        text = document.createTextNode(value.substr(idx + keyword.length));
        element.deleteData(idx, value.length - idx);

        var next = element.nextSibling;
        element.parentNode.insertBefore(span, next);
        element.parentNode.insertBefore(text, next);
        element = text;

        window.\(JAVASCRIPT_BRIDGE_NAME)._searchResultCount++;
        elementTmp = document.createTextNode(
          value.substr(idx + keyword.length)
        );
      }
    } else if (element.nodeType == 1) {
      // Element node
      if (
        element.style.display != "none" &&
        element.nodeName.toLowerCase() != "select" &&
        element.nodeName.toLowerCase() != "script" &&
        element.nodeName.toLowerCase() != "style" &&
        element.nodeName.toLowerCase() != "textarea"
      ) {
        for (var i = element.childNodes.length - 1; i >= 0; i--) {
          window.\(JAVASCRIPT_BRIDGE_NAME)._findAllAsyncForElement(
            element.childNodes[element.childNodes.length - 1 - i],
            keyword
          );
        }
      }
    }
  }
}

window.\(JAVASCRIPT_BRIDGE_NAME)._findAllAsync = function(keyword) {
  window.\(JAVASCRIPT_BRIDGE_NAME)._clearMatches();
  window.\(JAVASCRIPT_BRIDGE_NAME)._findAllAsyncForElement(document.body, keyword.toLowerCase());
  window.\(JAVASCRIPT_BRIDGE_NAME)._isDoneCounting = true;

  window.webkit.messageHandlers["onFindResultReceived"].postMessage(
      {
          'activeMatchOrdinal': window.\(JAVASCRIPT_BRIDGE_NAME)._currentHighlight,
          'numberOfMatches': window.\(JAVASCRIPT_BRIDGE_NAME)._searchResultCount,
          'isDoneCounting': window.\(JAVASCRIPT_BRIDGE_NAME)._isDoneCounting
      }
  );
}

window.\(JAVASCRIPT_BRIDGE_NAME)._clearMatchesForElement = function(element) {
  if (element) {
    if (element.nodeType == 1) {
      if (element.getAttribute("class") == "\(JAVASCRIPT_BRIDGE_NAME)_Highlight") {
        var text = element.removeChild(element.firstChild);
        element.parentNode.insertBefore(text, element);
        element.parentNode.removeChild(element);
        return true;
      } else {
        var normalize = false;
        for (var i = element.childNodes.length - 1; i >= 0; i--) {
          if (window.\(JAVASCRIPT_BRIDGE_NAME)._clearMatchesForElement(element.childNodes[i])) {
            normalize = true;
          }
        }
        if (normalize) {
          element.normalize();
        }
      }
    }
  }
  return false;
}

window.\(JAVASCRIPT_BRIDGE_NAME)._clearMatches = function() {
  window.\(JAVASCRIPT_BRIDGE_NAME)._searchResultCount = 0;
  window.\(JAVASCRIPT_BRIDGE_NAME)._currentHighlight = 0;
  window.\(JAVASCRIPT_BRIDGE_NAME)._isDoneCounting = false;
  window.\(JAVASCRIPT_BRIDGE_NAME)._clearMatchesForElement(document.body);
}

window.\(JAVASCRIPT_BRIDGE_NAME)._findNext = function(forward) {
  if (window.\(JAVASCRIPT_BRIDGE_NAME)._searchResultCount <= 0) return;

  var idx = window.\(JAVASCRIPT_BRIDGE_NAME)._currentHighlight + (forward ? +1 : -1);
  idx =
    idx < 0
      ? window.\(JAVASCRIPT_BRIDGE_NAME)._searchResultCount - 1
      : idx >= window.\(JAVASCRIPT_BRIDGE_NAME)._searchResultCount
      ? 0
      : idx;
  window.\(JAVASCRIPT_BRIDGE_NAME)._currentHighlight = idx;

  var scrollTo = document.getElementById("\(JAVASCRIPT_BRIDGE_NAME)_SEARCH_WORD_" + idx);
  if (scrollTo) {
    var highlights = document.getElementsByClassName("\(JAVASCRIPT_BRIDGE_NAME)_Highlight");
    for (var i = 0; i < highlights.length; i++) {
      var span = highlights[i];
      span.style.backgroundColor = "#FFFF00";
    }
    scrollTo.style.backgroundColor = "#FF9732";

    scrollTo.scrollIntoView({
      behavior: "auto",
      block: "center"
    });

    window.webkit.messageHandlers["onFindResultReceived"].postMessage(
        {
            'activeMatchOrdinal': window.\(JAVASCRIPT_BRIDGE_NAME)._currentHighlight,
            'numberOfMatches': window.\(JAVASCRIPT_BRIDGE_NAME)._searchResultCount,
            'isDoneCounting': window.\(JAVASCRIPT_BRIDGE_NAME)._isDoneCounting
        }
    );
  }
}
"""
