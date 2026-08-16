// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'web_message.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class WebMessage {
  WebMessage({
    dynamic this.data,
    WebMessageType? type,
    List<IWebMessagePort>? this.ports,
  }) : this.type = type ?? WebMessageType.STRING;

  factory WebMessage.fromJson(Map<String, dynamic> json) =>
      _$WebMessageFromJson(json);

  final dynamic data;

  @JsonKey(
    defaultValue: WebMessageType.STRING,
    toJson: _typeToJson,
    fromJson: _typeFromJson,
  )
  final WebMessageType type;

  @JsonKey(toJson: _portsToJson, fromJson: _portsFromJson)
  final List<IWebMessagePort>? ports;

  WebMessage copyWith({
    dynamic data,
    WebMessageType? type,
    List<IWebMessagePort>? ports,
  }) {
    return WebMessage(
      data: data ?? this.data,
      type: type ?? this.type,
      ports: ports ?? this.ports,
    );
  }

  WebMessage copyWithWebMessage({
    dynamic data,
    WebMessageType? type,
    List<IWebMessagePort>? ports,
  }) {
    return copyWith(data: data, type: type, ports: ports);
  }

  WebMessage patchWithWebMessage([WebMessagePatch? patchInput]) {
    final _patcher = patchInput ?? WebMessagePatch();
    final _patchMap = _patcher.patchMap;
    return WebMessage(
      data: _patchMap.containsKey(WebMessage$.data)
          ? (_patchMap[WebMessage$.data] is Function)
                ? _patchMap[WebMessage$.data](this.data)
                : (_patchMap[WebMessage$.data] is Patch)
                ? _patchMap[WebMessage$.data].applyTo(this.data)
                : _patchMap[WebMessage$.data]
          : this.data,
      type: _patchMap.containsKey(WebMessage$.type)
          ? (_patchMap[WebMessage$.type] is Function)
                ? _patchMap[WebMessage$.type](this.type)
                : (_patchMap[WebMessage$.type] is Patch)
                ? _patchMap[WebMessage$.type].applyTo(this.type)
                : _patchMap[WebMessage$.type]
          : this.type,
      ports: _patchMap.containsKey(WebMessage$.ports)
          ? (_patchMap[WebMessage$.ports] is Function)
                ? _patchMap[WebMessage$.ports](this.ports)
                : (_patchMap[WebMessage$.ports] is Patch)
                ? _patchMap[WebMessage$.ports].applyTo(this.ports)
                : _patchMap[WebMessage$.ports]
          : this.ports,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WebMessage &&
        data == other.data &&
        type == other.type &&
        ports == other.ports;
  }

  @override
  int get hashCode {
    return Object.hash(this.data, this.type, this.ports);
  }

  @override
  String toString() {
    return 'WebMessage(' +
        'data: ${data}' +
        ', ' +
        'type: ${type}' +
        ', ' +
        'ports: ${ports})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$WebMessageToJson(this);
    return _sanitizeJson(data);
  }

  dynamic _sanitizeJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      json.remove('__typename');
      return json..forEach((key, value) {
        json[key] = _sanitizeJson(value);
      });
    } else if (json is List) {
      return json.map((e) => _sanitizeJson(e)).toList();
    }
    return json;
  }
}

extension WebMessagePropertyHelpers on WebMessage {
  bool get isTypeSTRING {
    return this.type == WebMessageType.STRING;
  }

  bool get isTypeARRAY_BUFFER {
    return this.type == WebMessageType.ARRAY_BUFFER;
  }

  List<IWebMessagePort> get portsRequired {
    return this.ports ?? (throw StateError('ports is required but was null'));
  }

  bool get hasPorts {
    return this.ports?.isNotEmpty ?? false;
  }

  bool get noPorts {
    return this.ports?.isEmpty ?? true;
  }
}

extension WebMessageSerialization on WebMessage {
  Map<String, dynamic> toJson() {
    return _$WebMessageToJson(this);
  }
}

enum WebMessage$ { data, type, ports }

class WebMessagePatch extends PatchBase<WebMessage, WebMessage$> {
  WebMessage applyTo(WebMessage entity) {
    return entity.patchWithWebMessage(this);
  }

  WebMessagePatch withData(dynamic value) {
    patchMap[WebMessage$.data] = value;
    return this;
  }

  WebMessagePatch withType(WebMessageType? value) {
    patchMap[WebMessage$.type] = value;
    return this;
  }

  WebMessagePatch withPorts(List<IWebMessagePort>? value) {
    patchMap[WebMessage$.ports] = value;
    return this;
  }
}

/// Field descriptors for [WebMessage] query construction
abstract final class WebMessageFields {
  static const data = Field<WebMessage, dynamic>('data', _$data);

  static const type = Field<WebMessage, WebMessageType>('type', _$type);

  static const ports = Field<WebMessage, List<IWebMessagePort>?>(
    'ports',
    _$ports,
  );

  static dynamic _$data(WebMessage e) {
    return e.data;
  }

  static WebMessageType _$type(WebMessage e) {
    return e.type;
  }

  static List<IWebMessagePort>? _$ports(WebMessage e) {
    return e.ports;
  }
}

extension WebMessageCompareE on WebMessage {
  Map<String, dynamic> compareToWebMessage(WebMessage other) {
    final Map<String, dynamic> diff = {};

    if (data != other.data) {
      diff['data'] = () => other.data;
    }

    if (type != other.type) {
      diff['type'] = () => other.type;
    }

    if (ports != other.ports) {
      diff['ports'] = () => other.ports;
    }
    return diff;
  }
}
