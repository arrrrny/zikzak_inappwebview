//
//  PluginScriptsUtil.swift
//  zikzak_inappwebview
//
//  macOS port of the iOS PluginScriptsUtil constants. Only the JS sources
//  referenced from the macOS InAppWebView are included. See issue #197.
//

import Foundation

public class PluginScriptsUtil {
    public static let GET_SELECTED_TEXT_JS_SOURCE = """
    (function(){
        var txt;
        if (window.getSelection) {
          txt = window.getSelection().toString();
        } else if (window.document.getSelection) {
          txt = window.document.getSelection().toString();
        } else if (window.document.selection) {
          txt = window.document.selection.createRange().text;
        }
        return txt;
    })();
    """
}
