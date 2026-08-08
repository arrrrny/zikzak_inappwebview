import Foundation

public class SslError: NSObject {
    var errorType: SecTrustResultType?
    var message: String?
    
    public init(errorType: SecTrustResultType?) {
        self.errorType = errorType
        var sslErrorMessage: String? = nil
        switch errorType {
            case .deny:
                sslErrorMessage = "Indicates a user-configured deny; do not proceed."
            case .fatalTrustFailure:
                sslErrorMessage = "Indicates a trust failure which cannot be overridden by the user."
            case .invalid:
                sslErrorMessage = "Indicates an invalid setting or result."
            case .otherError:
                sslErrorMessage = "Indicates a failure other than that of trust evaluation."
            case .recoverableTrustFailure:
                sslErrorMessage = "Indicates a trust policy failure which can be overridden by the user."
            case .unspecified:
                sslErrorMessage = "Indicates the evaluation succeeded and the certificate is implicitly trusted, but user intent was not explicitly specified."
            default:
                sslErrorMessage = nil
        }
        self.message = sslErrorMessage
    }
    
    public func toMap () -> [String:Any?] {
        return [
            "code": errorType?.rawValue,
            "message": message
        ]
    }
}
