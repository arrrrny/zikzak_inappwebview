import Foundation
import FlutterMacOS
import WebKit

public class MyCookieManager: NSObject, FlutterPlugin {
    static var registrar: FlutterPluginRegistrar?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        
    }
    
    init(registrar: FlutterPluginRegistrar) {
        super.init()
        MyCookieManager.registrar = registrar
        let channel = FlutterMethodChannel(name: "wtf.zikzak/zikzak_inappwebview_cookiemanager", binaryMessenger: registrar.messenger)
        registrar.addMethodCallDelegate(self, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments = call.arguments as? [String: Any]
        switch call.method {
            case "setCookie":
                let url = arguments!["url"] as! String
                let name = arguments!["name"] as! String
                let value = arguments!["value"] as! String
                let path = arguments!["path"] as! String
                let domain = arguments!["domain"] as? String
                let expiresDate = arguments!["expiresDate"] as? Int64
                let maxAge = arguments!["maxAge"] as? Int64
                let isSecure = arguments!["isSecure"] as? Bool
                let isHttpOnly = arguments!["isHttpOnly"] as? Bool
                let sameSite = arguments!["sameSite"] as? String
                
                MyCookieManager.setCookie(url: url,
                                          name: name,
                                          value: value,
                                          path: path,
                                          domain: domain,
                                          expiresDate: expiresDate,
                                          maxAge: maxAge,
                                          isSecure: isSecure,
                                          isHttpOnly: isHttpOnly,
                                          sameSite: sameSite,
                                          result: result)
                break
            case "getCookies":
                let url = arguments!["url"] as! String
                MyCookieManager.getCookies(url: url, result: result)
                break
            case "getAllCookies":
                MyCookieManager.getAllCookies(result: result)
                break
            case "deleteCookie":
                let url = arguments!["url"] as! String
                let name = arguments!["name"] as! String
                let path = arguments!["path"] as! String
                let domain = arguments!["domain"] as? String
                MyCookieManager.deleteCookie(url: url, name: name, path: path, domain: domain, result: result)
                break
            case "deleteCookies":
                let url = arguments!["url"] as! String
                let path = arguments!["path"] as! String
                let domain = arguments!["domain"] as? String
                MyCookieManager.deleteCookies(url: url, path: path, domain: domain, result: result)
                break
            case "deleteAllCookies":
                MyCookieManager.deleteAllCookies(result: result)
                break
            default:
                result(FlutterMethodNotImplemented)
                break
        }
    }
    
    public static func setCookie(url: String,
                          name: String,
                          value: String,
                          path: String,
                          domain: String?,
                          expiresDate: Int64?,
                          maxAge: Int64?,
                          isSecure: Bool?,
                          isHttpOnly: Bool?,
                          sameSite: String?,
                          result: @escaping FlutterResult) {
        var properties: [HTTPCookiePropertyKey: Any] = [:]
        properties[.originURL] = url
        properties[.name] = name
        properties[.value] = value
        properties[.path] = path
        
        if domain != nil {
            properties[.domain] = domain
        }
        if expiresDate != nil {
            properties[.expires] = Date(timeIntervalSince1970: Double(expiresDate!)/1000)
        }
        if let maxAge = maxAge {
            properties[.maximumAge] = String(maxAge)
        }
        if isSecure != nil && isSecure! {
            properties[.secure] = "TRUE"
        }
        if isHttpOnly != nil && isHttpOnly! {
            properties[.discard] = "TRUE"
        }
        if sameSite != nil {
            switch sameSite {
            case "Lax":
                properties[.sameSitePolicy] = HTTPCookieStringPolicy.sameSiteLax
            case "Strict":
                properties[.sameSitePolicy] = HTTPCookieStringPolicy.sameSiteStrict
            case "None":
                properties[.sameSitePolicy] = "None"
            default:
                break
            }
        }
        
        let cookie = HTTPCookie(properties: properties)!
        WKWebsiteDataStore.default().httpCookieStore.setCookie(cookie, completionHandler: {() in
            result(true)
        })
    }
    
    public static func getCookies(url: String, result: @escaping FlutterResult) {
        WKWebsiteDataStore.default().httpCookieStore.getAllCookies { (cookies) in
            var cookieList: [[String: Any]] = []
            for cookie in cookies {
                if let cookieUrl = URL(string: url), cookie.domain.starts(with: ".") ? cookieUrl.host?.hasSuffix(cookie.domain) ?? false : cookieUrl.host == cookie.domain {
                        var cookieMap: [String: Any] = [:]
                    cookieMap["name"] = cookie.name
                    cookieMap["value"] = cookie.value
                    cookieMap["expiresDate"] = Int64(cookie.expiresDate?.timeIntervalSince1970 ?? -1) * 1000
                    cookieMap["isSessionOnly"] = cookie.isSessionOnly
                    cookieMap["domain"] = cookie.domain
                    cookieMap["sameSite"] = "Lax" // Default
                    
                    if let sameSite = cookie.sameSitePolicy {
                        if sameSite == .sameSiteLax {
                                cookieMap["sameSite"] = "Lax"
                        } else if sameSite == .sameSiteStrict {
                                cookieMap["sameSite"] = "Strict"
                        } else if sameSite.rawValue == "None" {
                                cookieMap["sameSite"] = "None"
                        }
                    }
                    
                    cookieMap["isSecure"] = cookie.isSecure
                    cookieMap["isHttpOnly"] = cookie.isHTTPOnly
                    cookieMap["path"] = cookie.path
                    
                    cookieList.append(cookieMap)
                }
            }
            result(cookieList)
        }
    }
    
    public static func getAllCookies(result: @escaping FlutterResult) {
        WKWebsiteDataStore.default().httpCookieStore.getAllCookies { (cookies) in
            var cookieList: [[String: Any]] = []
            for cookie in cookies {
                var cookieMap: [String: Any] = [:]
                cookieMap["name"] = cookie.name
                cookieMap["value"] = cookie.value
                cookieMap["expiresDate"] = Int64(cookie.expiresDate?.timeIntervalSince1970 ?? -1) * 1000
                cookieMap["isSessionOnly"] = cookie.isSessionOnly
                cookieMap["domain"] = cookie.domain
                cookieMap["sameSite"] = "Lax" // Default
                
                if let sameSite = cookie.sameSitePolicy {
                    if sameSite == .sameSiteLax {
                            cookieMap["sameSite"] = "Lax"
                    } else if sameSite == .sameSiteStrict {
                            cookieMap["sameSite"] = "Strict"
                    } else if sameSite.rawValue == "None" {
                            cookieMap["sameSite"] = "None"
                    }
                }
                
                cookieMap["isSecure"] = cookie.isSecure
                cookieMap["isHttpOnly"] = cookie.isHTTPOnly
                cookieMap["path"] = cookie.path
                
                cookieList.append(cookieMap)
            }
            result(cookieList)
        }
    }
    
    public static func deleteCookie(url: String, name: String, path: String, domain: String?, result: @escaping FlutterResult) {
        WKWebsiteDataStore.default().httpCookieStore.getAllCookies { (cookies) in
            for cookie in cookies {
                var domain = domain
                if domain == nil {
                    if let cookieUrl = URL(string: url) {
                        domain = cookieUrl.host
                    }
                }
                if domain != nil && cookie.domain.contains(domain!) && cookie.name == name && cookie.path == path {
                    WKWebsiteDataStore.default().httpCookieStore.delete(cookie, completionHandler: {
                        result(true)
                    })
                    return
                }
            }
            result(false)
        }
    }
    
    public static func deleteCookies(url: String, path: String, domain: String?, result: @escaping FlutterResult) {
        WKWebsiteDataStore.default().httpCookieStore.getAllCookies { (cookies) in
            for cookie in cookies {
                var domain = domain
                if domain == nil {
                    if let cookieUrl = URL(string: url) {
                        domain = cookieUrl.host
                    }
                }
                if domain != nil && cookie.domain.contains(domain!) && cookie.path == path {
                    WKWebsiteDataStore.default().httpCookieStore.delete(cookie, completionHandler: nil)
                }
            }
            result(true)
        }
    }
    
    public static func deleteAllCookies(result: @escaping FlutterResult) {
        let websiteDataTypes = Set([WKWebsiteDataTypeCookies])
        let date = Date(timeIntervalSince1970: 0)
        WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes, modifiedSince: date, completionHandler:{
            result(true)
        })
    }
}
