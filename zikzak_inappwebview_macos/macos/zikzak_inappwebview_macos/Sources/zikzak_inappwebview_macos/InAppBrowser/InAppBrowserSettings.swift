import AppKit

@objcMembers
public class InAppBrowserSettings: ISettings<InAppBrowserWebViewController> {

    var hidden = false

    override init() {
        super.init()
    }

    override func getRealSettings(obj: InAppBrowserWebViewController?) -> [String: Any?] {
        var realOptions: [String: Any?] = toMap()
        if let controller = obj {
            realOptions["hidden"] = !(controller.window?.isVisible ?? true)
        }
        return realOptions
    }
}
