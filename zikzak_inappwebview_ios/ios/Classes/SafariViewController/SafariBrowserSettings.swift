//
//  SafariBrowserOptions.swift
//  zikzak_inappwebview
//
//  Created by Lorenzo on 26/09/18.
//

import Foundation

@objcMembers
public class SafariBrowserSettings: ISettings<SafariViewController> {
    
    var entersReaderIfAvailable = false
    var barCollapsingEnabled = false
    var dismissButtonStyle = 0 //done
    var preferredBarTintColor: String?
    var preferredControlTintColor: String?
    var presentationStyle = 0 //fullscreen
    var transitionStyle = 0 //coverVertical
    var activityButton: [String:Any?]?
    var eventAttribution: [String:Any?]?
    
    override init(){
        super.init()
    }
    
    override func parse(settings: [String: Any?]) -> SafariBrowserSettings {
        let _ = super.parse(settings: settings)
        activityButton = settings["activityButton"] as? [String : Any?]
        eventAttribution = settings["eventAttribution"] as? [String : Any?]
        return self
    }
    
    override func getRealSettings(obj: SafariViewController?) -> [String: Any?] {
        var realOptions: [String: Any?] = toMap()
        if let safariViewController = obj {
            realOptions["entersReaderIfAvailable"] = safariViewController.configuration.entersReaderIfAvailable
            realOptions["barCollapsingEnabled"] = safariViewController.configuration.barCollapsingEnabled
            realOptions["dismissButtonStyle"] = safariViewController.dismissButtonStyle.rawValue
            realOptions["preferredBarTintColor"] = safariViewController.preferredBarTintColor?.hexString
            realOptions["preferredControlTintColor"] = safariViewController.preferredControlTintColor?.hexString
            realOptions["presentationStyle"] = safariViewController.modalPresentationStyle.rawValue
            realOptions["transitionStyle"] = safariViewController.modalTransitionStyle.rawValue
        }
        return realOptions
    }
}
