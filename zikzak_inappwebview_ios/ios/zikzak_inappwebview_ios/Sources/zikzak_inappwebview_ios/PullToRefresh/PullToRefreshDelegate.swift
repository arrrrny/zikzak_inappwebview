//
//  PullToRefreshDelegate.swift
//  zikzak_inappwebview
//
//  Created by ARRRRNY on 04/03/21.
//

import UIKit

public protocol PullToRefreshDelegate {
    func enablePullToRefresh()
    func disablePullToRefresh()
    func isPullToRefreshEnabled() -> Bool
}
