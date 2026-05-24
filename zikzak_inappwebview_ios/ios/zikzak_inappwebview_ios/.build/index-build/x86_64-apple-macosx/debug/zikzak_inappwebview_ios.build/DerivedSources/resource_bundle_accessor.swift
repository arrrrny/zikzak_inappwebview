import Foundation

extension Foundation.Bundle {
    static let module: Bundle = {
        let mainPath = Bundle.main.bundleURL.appendingPathComponent("zikzak_inappwebview_ios_zikzak_inappwebview_ios.bundle").path
        let buildPath = "/Users/ahmettok/Developer/zikzak_inappwebview/zikzak_inappwebview_ios/ios/zikzak_inappwebview_ios/.build/index-build/x86_64-apple-macosx/debug/zikzak_inappwebview_ios_zikzak_inappwebview_ios.bundle"

        let preferredBundle = Bundle(path: mainPath)

        guard let bundle = preferredBundle ?? Bundle(path: buildPath) else {
            // Users can write a function called fatalError themselves, we should be resilient against that.
            Swift.fatalError("could not load resource bundle: from \(mainPath) or \(buildPath)")
        }

        return bundle
    }()
}