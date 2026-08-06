import Cocoa
import FlutterMacOS

public enum PrintJobState: Int {
    case created = 1
    case started = 3
    case completed = 5
    case failed = 6
    case canceled = 7
}

public class PrintJobController: NSObject, Disposable {
    static let METHOD_CHANNEL_NAME_PREFIX = "wtf.zikzak/zikzak_inappwebview_printjobcontroller_"
    var id: String
    var plugin: InAppWebViewFlutterPlugin?
    var printOperation: NSPrintOperation?
    var printInfo: NSPrintInfo?
    var settings: PrintJobSettings?
    var jobName: String?
    var channelDelegate: PrintJobChannelDelegate?
    var state = PrintJobState.created
    var creationTime = Int64(Date().timeIntervalSince1970 * 1000)
    var webView: InAppWebView?

    public init(plugin: InAppWebViewFlutterPlugin, id: String, printOperation: NSPrintOperation? = nil, settings: PrintJobSettings? = nil, webView: InAppWebView? = nil) {
        self.id = id
        self.plugin = plugin
        super.init()
        self.printOperation = printOperation
        self.settings = settings
        self.webView = webView
        self.printInfo = printOperation?.printInfo
        self.jobName = self.printInfo?.jobName
        if let registrar = plugin.registrar {
            let channel = FlutterMethodChannel(name: PrintJobController.METHOD_CHANNEL_NAME_PREFIX + id,
                                               binaryMessenger: registrar.messenger())
            self.channelDelegate = PrintJobChannelDelegate(printJobController: self, channel: channel)
        }
    }

    public func present(animated: Bool, completionHandler: ((Bool, Error?) -> Void)? = nil) {
        guard let printOperation = printOperation else {
            completionHandler?(false, nil)
            return
        }

        printOperation.showsPrintPanel = animated
        printOperation.showsProgressPanel = true
        state = .started

        DispatchQueue.main.async { [weak self] in
            let completed = printOperation.run()
            if completed {
                self?.state = .completed
            } else {
                self?.state = .canceled
            }
            self?.channelDelegate?.onComplete(completed: completed, error: nil)
            completionHandler?(completed, nil)
        }
    }

    public func getInfo() -> PrintJobInfo? {
        guard let _ = printOperation else {
            return nil
        }
        return PrintJobInfo.init(fromPrintJobController: self)
    }

    public func dispose() {
        channelDelegate?.dispose()
        channelDelegate = nil
        printOperation = nil
        printInfo = nil
        webView = nil
        plugin?.printJobManager?.jobs[id] = nil
        plugin = nil
    }
}
