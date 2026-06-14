import Flutter
import UIKit

//
//  LeakAvoider.swift
//  zikzak_inappwebview
//
//  Created by ARRRRNY on 15/12/2019.
//

public class LeakAvoider: NSObject {
    weak var delegate: FlutterMethodCallDelegate?

    init(delegate: FlutterMethodCallDelegate) {
        super.init()
        self.delegate = delegate
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        self.delegate?.handle(call, result: result)
    }

    deinit {
    }
}
