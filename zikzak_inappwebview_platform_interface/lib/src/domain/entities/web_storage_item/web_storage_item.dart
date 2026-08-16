import 'package:zorphy_annotation/zorphy_annotation.dart';

part 'web_storage_item.zorphy.dart';
part 'web_storage_item.g.dart';

///Class that represents a single web storage item of the JavaScript `window.sessionStorage` and `window.localStorage` objects.
@Zorphy(
  kind: ZorphyKind.valueObject,
  generateJson: true,
  generateCompareTo: true,
)
abstract class $WebStorageItem {
  ///Item key.
  String? get key;

  ///Item value.
  dynamic get value;
}
