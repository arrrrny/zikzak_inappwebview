import Cocoa
import FlutterMacOS

@objcMembers
public class PrintJobSettings: ISettings<PrintJobController> {

    public var handledByClient = false
    public var jobName: String?
    public var animated = true
    public var _orientation: NSNumber?
    public var orientation: Int? {
        get {
            return _orientation?.intValue
        }
        set {
            if let newValue = newValue {
                _orientation = NSNumber.init(value: newValue)
            } else {
                _orientation = nil
            }
        }
    }
    public var _duplexMode: NSNumber?
    public var duplexMode: Int? {
        get {
            return _duplexMode?.intValue
        }
        set {
            if let newValue = newValue {
                _duplexMode = NSNumber.init(value: newValue)
            } else {
                _duplexMode = nil
            }
        }
    }
    public var margins: NSEdgeInsets?

    override init() {
        super.init()
    }

    override func parse(settings: [String: Any?]) -> PrintJobSettings {
        let _ = super.parse(settings: settings)
        if let marginsMap = settings["margins"] as? [String: Double] {
            margins = NSEdgeInsets.fromMap(map: marginsMap)
        }
        return self
    }

    override func getRealSettings(obj: PrintJobController?) -> [String: Any?] {
        let realOptions: [String: Any?] = toMap()
        return realOptions
    }
}
