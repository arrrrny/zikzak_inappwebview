//
//  UIEventAttribution.swift
//  zikzak_inappwebview
//
//  Created by ARRRRNY on 26/10/22.
//

import Foundation

extension UIEventAttribution {
    public static func fromMap(map: [String:Any?]?) -> UIEventAttribution? {
        guard let map = map else {
            return nil
        }
        if let sourceIdentifier = map["sourceIdentifier"] as? UInt8,
           let destinationURLString = map["destinationURL"] as? String,
           let destinationURL = URL(string: destinationURLString),
           let sourceDescription = map["sourceDescription"] as? String,
           let purchaser = map["purchaser"] as? String {
            return UIEventAttribution(sourceIdentifier: sourceIdentifier,
                                      destinationURL: destinationURL,
                                      sourceDescription: sourceDescription,
                                      purchaser: purchaser)
        }
        return nil
    }
}
