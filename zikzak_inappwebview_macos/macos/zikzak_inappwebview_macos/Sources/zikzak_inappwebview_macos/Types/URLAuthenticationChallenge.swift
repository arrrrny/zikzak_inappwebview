import Foundation

extension URLAuthenticationChallenge {
    public func toMap () -> [String:Any?] {
        return [
            "protectionSpace": protectionSpace.toMap(),
            "previousFailureCount": previousFailureCount,
            "failureResponse": failureResponse?.toMap(),
            "error": error?.localizedDescription,
            "proposedCredential": proposedCredential?.toMap(),
        ]
    }
}
