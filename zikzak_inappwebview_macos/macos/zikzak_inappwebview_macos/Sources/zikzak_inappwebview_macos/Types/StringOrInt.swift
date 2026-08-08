//
//  StringOrInt.swift
//  zikzak_inappwebview
//
//  Ported from iOS to support PermissionRequest.resources on macOS.
//  WKMediaCaptureType.rawValue is an Int, while device-orientation-and-motion
//  is represented as a String ("deviceOrientationAndMotion"), so the resources
//  array must hold either kind — mirroring the iOS contract consumed by the
//  shared Dart PermissionRequest.fromMap / PermissionResourceType.fromNativeValue.
//

import Foundation

public protocol StringOrInt {}

extension Int: StringOrInt {}
extension String: StringOrInt {}
