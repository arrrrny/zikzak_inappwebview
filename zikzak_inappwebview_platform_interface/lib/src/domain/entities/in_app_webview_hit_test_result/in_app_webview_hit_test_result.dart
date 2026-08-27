import 'package:zorphy_annotation/zorphy_annotation.dart';

import '../enums/in_app_webview_hit_test_result_type.dart';

part 'in_app_webview_hit_test_result.zorphy.dart';
part 'in_app_webview_hit_test_result.g.dart';

///Class that represents the hit result for hitting an HTML elements.
@Zorphy(
  kind: ZorphyKind.valueObject,
  generateJson: true,
  generateCompareTo: true,
)
abstract class $InAppWebViewHitTestResult {
  ///The type of the hit test result.
  @JsonKey(fromJson: _typeFromJson, toJson: _typeToJson)
  InAppWebViewHitTestResultType? get type;

  ///Additional type-dependant information about the result.
  String? get extra;
}

InAppWebViewHitTestResultType? _typeFromJson(Object? value) =>
    inAppWebViewHitTestResultTypeFromWire(value);

Object? _typeToJson(InAppWebViewHitTestResultType? value) =>
    inAppWebViewHitTestResultTypeToWire(value);
