import Foundation

extension NSEdgeInsets {
    public static func fromMap(map: [String: Double]) -> NSEdgeInsets {
        return NSEdgeInsets(
            top: map["top"]!,
            left: map["left"]!,
            bottom: map["bottom"]!,
            right: map["right"]!
        )
    }

    public func toMap() -> [String: Any?] {
        return [
            "top": top,
            "right": right,
            "bottom": bottom,
            "left": left
        ]
    }
}
