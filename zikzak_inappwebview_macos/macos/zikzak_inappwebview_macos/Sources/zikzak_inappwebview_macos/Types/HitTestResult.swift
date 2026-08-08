//
//  HitTestResult.swift
//  zikzak_inappwebview
//
//  Ported from iOS to support macOS context-menu hit-test results.
//  https://github.com/arrrrny/zikzak_inappwebview/issues/196
//

import Foundation

/// Mirrors `Android.WebView.HitTestResult` / iOS `HitTestResult` so the Dart
/// side receives the same shape on every platform.
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
        guard let map = map else {
            return nil
        }
        let type = HitTestResultType.init(
            rawValue: map["type"] as? Int ?? HitTestResultType.unknownType.rawValue
        ) ?? HitTestResultType.unknownType
        return HitTestResult(type: type, extra: map["extra"] as? String)
    }

    public func toMap() -> [String: Any?] {
        return [
            "type": type.rawValue,
            "extra": extra,
        ]
    }
}
