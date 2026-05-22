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
        .target(
            name: "zikzak_inappwebview_macos",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework"),
            ]
        )
    ]
)
