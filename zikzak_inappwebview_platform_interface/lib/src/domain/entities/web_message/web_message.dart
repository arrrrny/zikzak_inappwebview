// Migrated from @ExchangeableObject codegen by zorphy_migrator — hand-written
// entity (the migrator flagged the custom @ExchangeableObjectConstructor as
// manual): fork default (type = STRING) preserved via @JsonKey defaultValue,
// the constructor assert (dev-time validation only) is dropped.

import 'package:zorphy_annotation/zorphy_annotation.dart';
import '../../../web_message/platform_web_message_port.dart';

part 'web_message.zorphy.dart';
part 'web_message.g.dart';

///The Dart representation of the HTML5 PostMessage event.
///See https://html.spec.whatwg.org/multipage/comms.html#the-messageevent-interfaces for definition of a MessageEvent in HTML5.
@Zorphy(
  kind: ZorphyKind.valueObject,
  generateJson: true,
  generateCompareTo: true,
)
abstract class $WebMessage {
  ///The data of the message.
  dynamic get data;

  ///The payload type of the message.
  @JsonKey(
    defaultValue: WebMessageType.STRING,
    fromJson: _typeFromJson,
    toJson: _typeToJson,
  )
  WebMessageType get type;

  ///The ports that are sent with the message.
  @JsonKey(fromJson: _portsFromJson, toJson: _portsToJson)
  List<IWebMessagePort>? get ports;
}

WebMessageType _typeFromJson(Object? value) {
  if (value is! int) return WebMessageType.STRING;
  return value >= 0 && value < WebMessageType.values.length
      ? WebMessageType.values[value]
      : WebMessageType.STRING;
}

Object? _typeToJson(WebMessageType type) => type.index;

List<IWebMessagePort>? _portsFromJson(Object? value) =>
    value is List ? List<IWebMessagePort>.from(value.map((e) => e)) : null;

Object? _portsToJson(List<IWebMessagePort>? ports) =>
    ports?.map((e) => e.toMap()).toList();

///The type corresponding to the [WebMessage].
enum WebMessageType {
  ///Indicates the payload of WebMessageCompat is String.
  STRING,

  ///Indicates the payload of WebMessageCompat is JavaScript ArrayBuffer.
  ///
  ///**NOTE**: available only if [WebViewFeature.WEB_MESSAGE_ARRAY_BUFFER] feature is supported.
  ARRAY_BUFFER,
}
