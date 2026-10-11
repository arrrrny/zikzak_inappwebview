// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "zikzak_inappwebview_macos",
    platforms: [
        .macOS("12.0"),
    ],
    products: [
        .library(name: "zikzak-inappwebview-macos", targets: ["zikzak_inappwebview_macos"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework"),
    ],
    targets: [
        // #309: ObjC exception boundary (Swift cannot catch NSException).
        // Lets WeakScriptMessageHandler contain WebKit deserialization
        // exceptions and report them as a normal string error to Dart.
        .target(
            name: "ZikzakExceptionCatcher"
        ),
        .target(
            name: "zikzak_inappwebview_macos",
            dependencies: [
                "ZikzakExceptionCatcher",
                .product(name: "FlutterFramework", package: "FlutterFramework"),
            ]
        )
    ]
)
