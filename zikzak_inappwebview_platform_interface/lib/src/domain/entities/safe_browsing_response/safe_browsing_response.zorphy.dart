// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'safe_browsing_response.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class SafeBrowsingResponse {
  SafeBrowsingResponse({bool? report, SafeBrowsingResponseAction? action})
    : this.report = report ?? true,
      this.action = action ?? SafeBrowsingResponseAction.SHOW_INTERSTITIAL;

  factory SafeBrowsingResponse.fromJson(Map<String, dynamic> json) =>
      _$SafeBrowsingResponseFromJson(json);

  @JsonKey(defaultValue: true)
  final bool? report;

  @JsonKey(
    defaultValue: SafeBrowsingResponseAction.SHOW_INTERSTITIAL,
    toJson: _actionToJson,
    fromJson: _actionFromJson,
  )
  final SafeBrowsingResponseAction? action;

  SafeBrowsingResponse copyWith({
    bool? report,
    SafeBrowsingResponseAction? action,
  }) {
    return SafeBrowsingResponse(
      report: report ?? this.report,
      action: action ?? this.action,
    );
  }

  SafeBrowsingResponse copyWithSafeBrowsingResponse({
    bool? report,
    SafeBrowsingResponseAction? action,
  }) {
    return copyWith(report: report, action: action);
  }

  SafeBrowsingResponse patchWithSafeBrowsingResponse([
    SafeBrowsingResponsePatch? patchInput,
  ]) {
    final _patcher = patchInput ?? SafeBrowsingResponsePatch();
    final _patchMap = _patcher.patchMap;
    return SafeBrowsingResponse(
      report: _patchMap.containsKey(SafeBrowsingResponse$.report)
          ? ((_patchMap[SafeBrowsingResponse$.report] is Function)
                    ? _patchMap[SafeBrowsingResponse$.report](this.report)
                    : (_patchMap[SafeBrowsingResponse$.report] is Patch)
                    ? _patchMap[SafeBrowsingResponse$.report].applyTo(
                        this.report,
                      )
                    : _patchMap[SafeBrowsingResponse$.report])
                as bool?
          : this.report,
      action: _patchMap.containsKey(SafeBrowsingResponse$.action)
          ? ((_patchMap[SafeBrowsingResponse$.action] is Function)
                    ? _patchMap[SafeBrowsingResponse$.action](this.action)
                    : (_patchMap[SafeBrowsingResponse$.action] is Patch)
                    ? _patchMap[SafeBrowsingResponse$.action].applyTo(
                        this.action,
                      )
                    : _patchMap[SafeBrowsingResponse$.action])
                as SafeBrowsingResponseAction?
          : this.action,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SafeBrowsingResponse &&
        report == other.report &&
        action == other.action;
  }

  @override
  int get hashCode {
    return Object.hash(this.report, this.action);
  }

  @override
  String toString() {
    return 'SafeBrowsingResponse(' +
        'report: ${report}' +
        ', ' +
        'action: ${action})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$SafeBrowsingResponseToJson(this);
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

extension SafeBrowsingResponsePropertyHelpers on SafeBrowsingResponse {
  bool get hasReport {
    return this.report != null;
  }

  bool get noReport {
    return this.report == null;
  }

  bool get reportRequired {
    return this.report ?? (throw StateError('report is required but was null'));
  }

  bool get hasAction {
    return this.action != null;
  }

  bool get noAction {
    return this.action == null;
  }

  SafeBrowsingResponseAction get actionRequired {
    return this.action ?? (throw StateError('action is required but was null'));
  }

  bool get isActionBACK_TO_SAFETY {
    return this.action == SafeBrowsingResponseAction.BACK_TO_SAFETY;
  }

  bool get isActionPROCEED {
    return this.action == SafeBrowsingResponseAction.PROCEED;
  }

  bool get isActionSHOW_INTERSTITIAL {
    return this.action == SafeBrowsingResponseAction.SHOW_INTERSTITIAL;
  }
}

extension SafeBrowsingResponseSerialization on SafeBrowsingResponse {
  Map<String, dynamic> toJson() {
    return _$SafeBrowsingResponseToJson(this);
  }
}

enum SafeBrowsingResponse$ { report, action }

class SafeBrowsingResponsePatch
    extends PatchBase<SafeBrowsingResponse, SafeBrowsingResponse$> {
  SafeBrowsingResponse applyTo(SafeBrowsingResponse entity) {
    return entity.patchWithSafeBrowsingResponse(this);
  }

  SafeBrowsingResponsePatch withReport(bool? value) {
    patchMap[SafeBrowsingResponse$.report] = value;
    return this;
  }

  SafeBrowsingResponsePatch withAction(SafeBrowsingResponseAction? value) {
    patchMap[SafeBrowsingResponse$.action] = value;
    return this;
  }
}

/// Field descriptors for [SafeBrowsingResponse] query construction
abstract final class SafeBrowsingResponseFields {
  static const report = Field<SafeBrowsingResponse, bool?>('report', _$report);

  static const action =
      Field<SafeBrowsingResponse, SafeBrowsingResponseAction?>(
        'action',
        _$action,
      );

  static bool? _$report(SafeBrowsingResponse e) {
    return e.report;
  }

  static SafeBrowsingResponseAction? _$action(SafeBrowsingResponse e) {
    return e.action;
  }
}

extension SafeBrowsingResponseCompareE on SafeBrowsingResponse {
  Map<String, dynamic> compareToSafeBrowsingResponse(
    SafeBrowsingResponse other,
  ) {
    final Map<String, dynamic> diff = {};

    if (report != other.report) {
      diff['report'] = () => other.report;
    }

    if (action != other.action) {
      diff['action'] = () => other.action;
    }
    return diff;
  }
}
