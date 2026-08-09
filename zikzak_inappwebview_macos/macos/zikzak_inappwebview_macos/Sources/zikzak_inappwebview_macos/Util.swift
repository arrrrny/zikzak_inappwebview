import FlutterMacOS
import WebKit

public class Util {
    public static func getAbsPathAsset(plugin: InAppWebViewFlutterPlugin, assetFilePath: String) throws -> String {
        guard let key = plugin.registrar?.lookupKey(forAsset: assetFilePath),
              let assetAbsPath = Bundle.main.path(forResource: key, ofType: nil) else {
            throw NSError(domain: assetFilePath + " asset file cannot be found!", code: 0)
        }
        return assetAbsPath
    }
}
