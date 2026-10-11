// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "zikzak_inappwebview_ios",
    platforms: [
        // iOS 15.0: matches the oldest app target we support. Every
        // iOS 15.4/16/16.4/17+ API used in the sources is already
        // availability-guarded, so apps targeting iOS 15.0 are accepted by
        // FlutterGeneratedPluginSwiftPackage (issue #316). Raise only with a
        // matching availability guard audit.
        .iOS("15.0")
    ],
    products: [
        .library(name: "zikzak-inappwebview-ios", targets: ["zikzak_inappwebview_ios"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework"),
        .package(url: "https://github.com/Weebly/OrderedSet.git", from: "6.0.3"),
    ],
    targets: [
        .target(
            name: "zikzak_inappwebview_ios",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework"),
                .product(name: "OrderedSet", package: "OrderedSet"),
            ],
            resources: [
                .process("PrivacyInfo.xcprivacy"),
                .process("Storyboards"),
            ]
        )
    ]
)
