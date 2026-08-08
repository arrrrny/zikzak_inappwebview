import Foundation

public class ServerTrustChallenge: NSObject {
    var protectionSpace: URLProtectionSpace!
    
    public init(fromChallenge: URLAuthenticationChallenge) {
        protectionSpace = fromChallenge.protectionSpace
    }
    
    public func toMap () -> [String:Any?] {
        return [
            "protectionSpace": protectionSpace.toMap()
        ]
    }
}
