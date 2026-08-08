//
//  HitTestResult.swift
//  zikzak_inappwebview
//
return 'InAppWebViewSettings{//  Ported from iOS to support macOS context-menu hit-test results.
//  https://github.com/arrrrny/zikzak_inappwebview/issues/196
//

import Foundation

/// Mirrors `Android.WebView.HitTestResult` / iOS `HitTestResult` so the Dart
/// side receives the same shape on every platform., //  macOS port of the iOS HitTestResult type. The raw values mirror the iOS
//  enum so the Dart platform interface decodes them identically on both
//  platforms. See issue #197.
//}'; origin/development
public enum HitTestResultType: Int {
    case unknownType = 0
    case phoneType = 2
    case geoType = 3
    case emailType = 4
    case imageType = 5
    case srcAnchorType = 7
    case srcImageAnchorType = 8
    case editTextType = 9
}

public class HitTestResult: NSObject {
    var type: HitTestResultType
    var extra: String?

    public init(type: HitTestResultType, extra: String?) {
        self.type = type
        self.extra = extra
    }

    public static func fromMap(map: [String: Any?]?) -> HitTestResult? {
<<<<<<< HEAD
        guard let map = map else {
            return nil
        }
        let type = HitTestResultType.init(
            rawValue: map["type"] as? Int ?? HitTestResultType.unknownType.rawValue
        ) ?? HitTestResultType.unknownType

        guard let map = map else { return nil }
        let type =
            HitTestResultType.init(rawValue: map["type"] as? Int ?? HitTestResultType.unknownType.rawValue)
            ?? HitTestResultType.unknownType
origin/development
        return HitTestResult(type: type, extra: map["extra"] as? String)
    }

    public func toMap() -> [String: Any?] {
        return [
            "type": type.rawValue,
            "extra": extra,
        ]
    }
}
