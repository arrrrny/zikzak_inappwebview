import Cocoa

public class PrintJobInfo: NSObject {
    var state: PrintJobState
    var attributes: PrintAttributes
    var creationTime: Int64
    var label: String?

    public init(fromPrintJobController: PrintJobController) {
        state = fromPrintJobController.state
        creationTime = fromPrintJobController.creationTime
        attributes = PrintAttributes.init(fromPrintJobController: fromPrintJobController)
        super.init()
        if let jobName = fromPrintJobController.jobName {
            label = jobName
        }
    }

    public func toMap() -> [String: Any?] {
        return [
            "state": state.rawValue,
            "attributes": attributes.toMap(),
            "copies": nil,
            "numberOfPages": nil,
            "creationTime": creationTime,
            "label": label,
            "printer": [
                "id": nil
            ]
        ]
    }
}
