import 'package:zorphy_annotation/zorphy_annotation.dart';

part 'webview_package_info.zorphy.dart';
part 'webview_package_info.g.dart';

///Class that represents a `WebView` package info.
@Zorphy(
  kind: ZorphyKind.valueObject,
  generateJson: true,
  generateCompareTo: true,
)
abstract class $WebViewPackageInfo {
  ///The version name of this WebView package.
  String? get versionName;
  ///The name of this WebView package.
  String? get packageName;
}
