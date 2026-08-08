//
//  WebMessageChannelJS.swift
//  zikzak_inappwebview
//
//  macOS port of the iOS WebMessageChannelJS. Defines the JS variable that
//  holds the in-page MessageChannel map. See issue #197.
//

import Foundation

let WEB_MESSAGE_CHANNELS_VARIABLE_NAME = "window.\(JAVASCRIPT_BRIDGE_NAME)._webMessageChannels"
