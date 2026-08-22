import 'package:zorphy_annotation/zorphy_annotation.dart';

part 'call_async_javascript_result.zorphy.dart';
part 'call_async_javascript_result.g.dart';

///Class that represents either a success or a failure, including an associated value in each case for [PlatformInAppWebViewController.callAsyncJavaScript].
@Zorphy(
  kind: ZorphyKind.valueObject,
  generateJson: true,
  generateCompareTo: true,
)
abstract class $CallAsyncJavaScriptResult {
  ///It contains the success value.
  dynamic get value;

  ///It contains the failure value.
  String? get error;
}
