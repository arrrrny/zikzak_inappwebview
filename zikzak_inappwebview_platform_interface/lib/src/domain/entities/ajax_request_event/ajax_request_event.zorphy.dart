// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'ajax_request_event.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class AjaxRequestEvent {
  AjaxRequestEvent({
    AjaxRequestEventType? this.type,
    bool? this.lengthComputable,
    int? this.loaded,
    int? this.total,
  });

  factory AjaxRequestEvent.fromJson(Map<String, dynamic> json) =>
      _$AjaxRequestEventFromJson(json);

  @JsonKey(toJson: _typeToJson, fromJson: _typeFromJson)
  final AjaxRequestEventType? type;

  final bool? lengthComputable;

  final int? loaded;

  final int? total;

  AjaxRequestEvent copyWith({
    AjaxRequestEventType? type,
    bool? lengthComputable,
    int? loaded,
    int? total,
  }) {
    return AjaxRequestEvent(
      type: type ?? this.type,
      lengthComputable: lengthComputable ?? this.lengthComputable,
      loaded: loaded ?? this.loaded,
      total: total ?? this.total,
    );
  }

  AjaxRequestEvent copyWithAjaxRequestEvent({
    AjaxRequestEventType? type,
    bool? lengthComputable,
    int? loaded,
    int? total,
  }) {
    return copyWith(
      type: type,
      lengthComputable: lengthComputable,
      loaded: loaded,
      total: total,
    );
  }

  AjaxRequestEvent patchWithAjaxRequestEvent([
    AjaxRequestEventPatch? patchInput,
  ]) {
    final _patcher = patchInput ?? AjaxRequestEventPatch();
    final _patchMap = _patcher.patchMap;
    return AjaxRequestEvent(
      type: _patchMap.containsKey(AjaxRequestEvent$.type)
          ? (_patchMap[AjaxRequestEvent$.type] is Function)
                ? _patchMap[AjaxRequestEvent$.type](this.type)
                : (_patchMap[AjaxRequestEvent$.type] is Patch)
                ? _patchMap[AjaxRequestEvent$.type].applyTo(this.type)
                : _patchMap[AjaxRequestEvent$.type]
          : this.type,
      lengthComputable:
          _patchMap.containsKey(AjaxRequestEvent$.lengthComputable)
          ? (_patchMap[AjaxRequestEvent$.lengthComputable] is Function)
                ? _patchMap[AjaxRequestEvent$.lengthComputable](
                    this.lengthComputable,
                  )
                : (_patchMap[AjaxRequestEvent$.lengthComputable] is Patch)
                ? _patchMap[AjaxRequestEvent$.lengthComputable].applyTo(
                    this.lengthComputable,
                  )
                : _patchMap[AjaxRequestEvent$.lengthComputable]
          : this.lengthComputable,
      loaded: _patchMap.containsKey(AjaxRequestEvent$.loaded)
          ? (_patchMap[AjaxRequestEvent$.loaded] is Function)
                ? _patchMap[AjaxRequestEvent$.loaded](this.loaded)
                : (_patchMap[AjaxRequestEvent$.loaded] is Patch)
                ? _patchMap[AjaxRequestEvent$.loaded].applyTo(this.loaded)
                : _patchMap[AjaxRequestEvent$.loaded]
          : this.loaded,
      total: _patchMap.containsKey(AjaxRequestEvent$.total)
          ? (_patchMap[AjaxRequestEvent$.total] is Function)
                ? _patchMap[AjaxRequestEvent$.total](this.total)
                : (_patchMap[AjaxRequestEvent$.total] is Patch)
                ? _patchMap[AjaxRequestEvent$.total].applyTo(this.total)
                : _patchMap[AjaxRequestEvent$.total]
          : this.total,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AjaxRequestEvent &&
        type == other.type &&
        lengthComputable == other.lengthComputable &&
        loaded == other.loaded &&
        total == other.total;
  }

  @override
  int get hashCode {
    return Object.hash(
      this.type,
      this.lengthComputable,
      this.loaded,
      this.total,
    );
  }

  @override
  String toString() {
    return 'AjaxRequestEvent(' +
        'type: ${type}' +
        ', ' +
        'lengthComputable: ${lengthComputable}' +
        ', ' +
        'loaded: ${loaded}' +
        ', ' +
        'total: ${total})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$AjaxRequestEventToJson(this);
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

extension AjaxRequestEventPropertyHelpers on AjaxRequestEvent {
  bool get hasType {
    return this.type != null;
  }

  bool get noType {
    return this.type == null;
  }

  AjaxRequestEventType get typeRequired {
    return this.type ?? (throw StateError('type is required but was null'));
  }

  bool get isTypeLOADSTART {
    return this.type == AjaxRequestEventType.LOADSTART;
  }

  bool get isTypeLOAD {
    return this.type == AjaxRequestEventType.LOAD;
  }

  bool get isTypeLOADEND {
    return this.type == AjaxRequestEventType.LOADEND;
  }

  bool get isTypePROGRESS {
    return this.type == AjaxRequestEventType.PROGRESS;
  }

  bool get isTypeERROR {
    return this.type == AjaxRequestEventType.ERROR;
  }

  bool get isTypeABORT {
    return this.type == AjaxRequestEventType.ABORT;
  }

  bool get isTypeTIMEOUT {
    return this.type == AjaxRequestEventType.TIMEOUT;
  }

  bool get hasLengthComputable {
    return this.lengthComputable != null;
  }

  bool get noLengthComputable {
    return this.lengthComputable == null;
  }

  bool get lengthComputableRequired {
    return this.lengthComputable ??
        (throw StateError('lengthComputable is required but was null'));
  }

  bool get hasLoaded {
    return this.loaded != null;
  }

  bool get noLoaded {
    return this.loaded == null;
  }

  int get loadedRequired {
    return this.loaded ?? (throw StateError('loaded is required but was null'));
  }

  bool get hasTotal {
    return this.total != null;
  }

  bool get noTotal {
    return this.total == null;
  }

  int get totalRequired {
    return this.total ?? (throw StateError('total is required but was null'));
  }
}

extension AjaxRequestEventSerialization on AjaxRequestEvent {
  Map<String, dynamic> toJson() {
    return _$AjaxRequestEventToJson(this);
  }
}

enum AjaxRequestEvent$ { type, lengthComputable, loaded, total }

class AjaxRequestEventPatch
    extends PatchBase<AjaxRequestEvent, AjaxRequestEvent$> {
  AjaxRequestEvent applyTo(AjaxRequestEvent entity) {
    return entity.patchWithAjaxRequestEvent(this);
  }

  AjaxRequestEventPatch withType(AjaxRequestEventType? value) {
    patchMap[AjaxRequestEvent$.type] = value;
    return this;
  }

  AjaxRequestEventPatch withLengthComputable(bool? value) {
    patchMap[AjaxRequestEvent$.lengthComputable] = value;
    return this;
  }

  AjaxRequestEventPatch withLoaded(int? value) {
    patchMap[AjaxRequestEvent$.loaded] = value;
    return this;
  }

  AjaxRequestEventPatch withTotal(int? value) {
    patchMap[AjaxRequestEvent$.total] = value;
    return this;
  }
}

/// Field descriptors for [AjaxRequestEvent] query construction
abstract final class AjaxRequestEventFields {
  static const type = Field<AjaxRequestEvent, AjaxRequestEventType?>(
    'type',
    _$type,
  );

  static const lengthComputable = Field<AjaxRequestEvent, bool?>(
    'lengthComputable',
    _$lengthComputable,
  );

  static const loaded = Field<AjaxRequestEvent, int?>('loaded', _$loaded);

  static const total = Field<AjaxRequestEvent, int?>('total', _$total);

  static AjaxRequestEventType? _$type(AjaxRequestEvent e) {
    return e.type;
  }

  static bool? _$lengthComputable(AjaxRequestEvent e) {
    return e.lengthComputable;
  }

  static int? _$loaded(AjaxRequestEvent e) {
    return e.loaded;
  }

  static int? _$total(AjaxRequestEvent e) {
    return e.total;
  }
}

extension AjaxRequestEventCompareE on AjaxRequestEvent {
  Map<String, dynamic> compareToAjaxRequestEvent(AjaxRequestEvent other) {
    final Map<String, dynamic> diff = {};

    if (type != other.type) {
      diff['type'] = () => other.type;
    }

    if (lengthComputable != other.lengthComputable) {
      diff['lengthComputable'] = () => other.lengthComputable;
    }

    if (loaded != other.loaded) {
      diff['loaded'] = () => other.loaded;
    }

    if (total != other.total) {
      diff['total'] = () => other.total;
    }
    return diff;
  }
}
