import Cocoa

public class PrintAttributes: NSObject {
    var orientation: Int?
    var duplex: Int?
    var margins: NSEdgeInsets?

    public init(fromPrintJobController: PrintJobController) {
        super.init()
        if let printInfo = fromPrintJobController.printInfo {
            orientation = printInfo.orientation.rawValue
            duplex = fromPrintJobController.settings?.duplexMode
            margins = NSEdgeInsets(
                top: printInfo.topMargin,
                left: printInfo.leftMargin,
                bottom: printInfo.bottomMargin,
                right: printInfo.rightMargin
            )
        }
    }

    public func toMap() -> [String: Any?] {
        return [
            "margins": margins?.toMap(),
            "orientation": orientation,
            "duplex": duplex,
            "outputType": nil,
            "footerHeight": nil,
            "headerHeight": nil,
            "paperRect": nil,
            "printableRect": nil,
            "maximumContentHeight": nil,
            "maximumContentWidth": nil
        ]
    }
}
