import FlutterMacOS

public class WebViewChannelDelegate: ChannelDelegate {
    
    public override init(channel: FlutterMethodChannel) {
        super.init(channel: channel)
    }
    
    public class ReceivedHttpAuthRequestCallback: BaseCallbackResult<HttpAuthResponse> {
        override init() {
            super.init()
            self.decodeResult = { (obj: Any?) in
                return HttpAuthResponse.fromMap(map: obj as? [String: Any?])
            }
        }
        deinit {
            self.defaultBehaviour(nil)
        }
    }
    
    public func onReceivedHttpAuthRequest(
        challenge: HttpAuthenticationChallenge, callback: ReceivedHttpAuthRequestCallback
    ) {
        if channel == nil {
            callback.defaultBehaviour(nil)
            return
        }
        DispatchQueue.global(qos: .background).async {
            let arguments = challenge.toMap()
            DispatchQueue.main.async { [weak self] in
                if self?.channel == nil {
                    callback.defaultBehaviour(nil)
                    return
                }
                self?.channel?.invokeMethod(
                    "onReceivedHttpAuthRequest", arguments: arguments, callback: callback)
            }
        }
    }
    
    public class ReceivedServerTrustAuthRequestCallback: BaseCallbackResult<ServerTrustAuthResponse> {
        override init() {
            super.init()
            self.decodeResult = { (obj: Any?) in
                return ServerTrustAuthResponse.fromMap(map: obj as? [String: Any?])
            }
        }
        deinit {
            self.defaultBehaviour(nil)
        }
    }
    
    public func onReceivedServerTrustAuthRequest(
        challenge: ServerTrustChallenge, callback: ReceivedServerTrustAuthRequestCallback
    ) {
        if channel == nil {
            callback.defaultBehaviour(nil)
            return
        }
        DispatchQueue.global(qos: .background).async {
            let arguments = challenge.toMap()
            DispatchQueue.main.async { [weak self] in
                if self?.channel == nil {
                    callback.defaultBehaviour(nil)
                    return
                }
                self?.channel?.invokeMethod(
                    "onReceivedServerTrustAuthRequest", arguments: arguments, callback: callback)
            }
        }
    }
    
    public class ReceivedClientCertRequestCallback: BaseCallbackResult<ClientCertResponse> {
        override init() {
            super.init()
            self.decodeResult = { (obj: Any?) in
                return ClientCertResponse.fromMap(map: obj as? [String: Any?])
            }
        }
        deinit {
            self.defaultBehaviour(nil)
        }
    }
    
    public func onReceivedClientCertRequest(
        challenge: ClientCertChallenge, callback: ReceivedClientCertRequestCallback
    ) {
        if channel == nil {
            callback.defaultBehaviour(nil)
            return
        }
        DispatchQueue.global(qos: .background).async {
            let arguments = challenge.toMap()
            DispatchQueue.main.async { [weak self] in
                if self?.channel == nil {
                    callback.defaultBehaviour(nil)
                    return
                }
                self?.channel?.invokeMethod(
                    "onReceivedClientCertRequest", arguments: arguments, callback: callback)
            }
        }
    }
}
