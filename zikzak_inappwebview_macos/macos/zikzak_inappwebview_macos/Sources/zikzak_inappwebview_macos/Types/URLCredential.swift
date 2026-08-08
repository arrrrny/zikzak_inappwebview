import Foundation

extension URLCredential {
    public func toMap () -> [String:Any?] {
        var x509Certificates: [Data] = []
        if certificates != nil {
            for certificate in certificates {
                x509Certificates.append((certificate as! SecCertificate).data)
            }
        }
        return [
            "password": password,
            "username": user,
            "certificates": x509Certificates,
            "persistence": persistence.rawValue
        ]
    }
}
