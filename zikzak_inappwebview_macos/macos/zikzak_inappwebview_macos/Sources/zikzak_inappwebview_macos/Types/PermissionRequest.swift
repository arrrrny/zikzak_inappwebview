//
//  PermissionRequest.swift
//  zikzak_inappwebview
//
//  Ported from iOS. Represents a media-capture / device-orientation permission
//  request originating from web content. Serialised to a map consumed by the
//  shared Dart PermissionRequest.fromMap, which drives the
//  PlatformWebViewCreationParams.onPermissionRequest callback.
//
//  `resources` holds WKMediaCaptureType.rawValue (Int) for camera/microphone,
//  or the string "deviceOrientationAndMotion" for the orientation/motion
//  delegate. The mapping back to PermissionResourceType on the Dart side is
//  platform-aware (see permission_resource_type.g.dart — macOS native values:
//  camera=0, microphone=1, cameraAndMicrophone=2).
//

import WebKit

public class PermissionRequest: NSObject {
    var origin: String
    var resources: [StringOrInt]
    var frame: WKFrameInfo

    public init(origin: String, resources: [StringOrInt], frame: WKFrameInfo) {
        self.origin = origin
        self.resources = resources
        self.frame = frame
    }

    public func toMap() -> [String: Any?] {
        return [
            "origin": origin,
            "resources": resources,
            "frame": frame.toMap(),
        ]
    }
}
