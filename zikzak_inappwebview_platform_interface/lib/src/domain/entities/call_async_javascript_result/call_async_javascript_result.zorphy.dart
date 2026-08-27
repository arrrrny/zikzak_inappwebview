// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'call_async_javascript_result.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class CallAsyncJavaScriptResult {
  CallAsyncJavaScriptResult({dynamic this.value, String? this.error});

  factory CallAsyncJavaScriptResult.fromJson(Map<String, dynamic> json) =>
      _$CallAsyncJavaScriptResultFromJson(json);

  final dynamic value;

  final String? error;

  CallAsyncJavaScriptResult copyWith({dynamic value, String? error}) {
    return CallAsyncJavaScriptResult(
      value: value ?? this.value,
      error: error ?? this.error,
    );
  }

  CallAsyncJavaScriptResult copyWithCallAsyncJavaScriptResult({
    dynamic value,
    String? error,
  }) {
    return copyWith(value: value, error: error);
  }

  CallAsyncJavaScriptResult patchWithCallAsyncJavaScriptResult([
    CallAsyncJavaScriptResultPatch? patchInput,
  ]) {
    final _patcher = patchInput ?? CallAsyncJavaScriptResultPatch();
    final _patchMap = _patcher.patchMap;
    return CallAsyncJavaScriptResult(
      value: _patchMap.containsKey(CallAsyncJavaScriptResult$.value)
          ? ((_patchMap[CallAsyncJavaScriptResult$.value] is Function)
                    ? _patchMap[CallAsyncJavaScriptResult$.value](this.value)
                    : (_patchMap[CallAsyncJavaScriptResult$.value] is Patch)
                    ? _patchMap[CallAsyncJavaScriptResult$.value].applyTo(
                        this.value,
                      )
                    : _patchMap[CallAsyncJavaScriptResult$.value])
                as dynamic
          : this.value,
      error: _patchMap.containsKey(CallAsyncJavaScriptResult$.error)
          ? ((_patchMap[CallAsyncJavaScriptResult$.error] is Function)
                    ? _patchMap[CallAsyncJavaScriptResult$.error](this.error)
                    : (_patchMap[CallAsyncJavaScriptResult$.error] is Patch)
                    ? _patchMap[CallAsyncJavaScriptResult$.error].applyTo(
                        this.error,
                      )
                    : _patchMap[CallAsyncJavaScriptResult$.error])
                as String?
          : this.error,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CallAsyncJavaScriptResult &&
        value == other.value &&
        error == other.error;
  }

  @override
  int get hashCode {
    return Object.hash(this.value, this.error);
  }

  @override
  String toString() {
    return 'CallAsyncJavaScriptResult(' +
        'value: ${value}' +
        ', ' +
        'error: ${error})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$CallAsyncJavaScriptResultToJson(this);
    _sanitizeJson(data);
    return data;
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

extension CallAsyncJavaScriptResultPropertyHelpers
    on CallAsyncJavaScriptResult {
  bool get hasError {
    return this.error?.isNotEmpty == true;
  }

  bool get noError {
    return this.error?.isEmpty ?? true;
  }

  String get errorRequired {
    return this.error ?? (throw StateError('error is required but was null'));
  }
}

extension CallAsyncJavaScriptResultSerialization on CallAsyncJavaScriptResult {
  Map<String, dynamic> toJson() {
    return _$CallAsyncJavaScriptResultToJson(this);
  }
}

enum CallAsyncJavaScriptResult$ { value, error }

class CallAsyncJavaScriptResultPatch
    extends PatchBase<CallAsyncJavaScriptResult, CallAsyncJavaScriptResult$> {
  CallAsyncJavaScriptResult applyTo(CallAsyncJavaScriptResult entity) {
    return entity.patchWithCallAsyncJavaScriptResult(this);
  }

  CallAsyncJavaScriptResultPatch withValue(dynamic value) {
    patchMap[CallAsyncJavaScriptResult$.value] = value;
    return this;
  }

  CallAsyncJavaScriptResultPatch withError(String? value) {
    patchMap[CallAsyncJavaScriptResult$.error] = value;
    return this;
  }
}

/// Field descriptors for [CallAsyncJavaScriptResult] query construction
abstract final class CallAsyncJavaScriptResultFields {
  static const value = Field<CallAsyncJavaScriptResult, dynamic>(
    'value',
    _$value,
  );

  static const error = Field<CallAsyncJavaScriptResult, String?>(
    'error',
    _$error,
  );

  static dynamic _$value(CallAsyncJavaScriptResult e) {
    return e.value;
  }

  static String? _$error(CallAsyncJavaScriptResult e) {
    return e.error;
  }
}

extension CallAsyncJavaScriptResultCompareE on CallAsyncJavaScriptResult {
  Map<String, dynamic> compareToCallAsyncJavaScriptResult(
    CallAsyncJavaScriptResult other,
  ) {
    final Map<String, dynamic> diff = {};

    if (value != other.value) {
      diff['value'] = () => other.value;
    }

    if (error != other.error) {
      diff['error'] = () => other.error;
    }
    return diff;
  }
}
