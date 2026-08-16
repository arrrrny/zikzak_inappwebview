// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'renderer_priority_policy.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class RendererPriorityPolicy {
  RendererPriorityPolicy({
    RendererPriority? this.rendererRequestedPriority,
    required bool this.waivedWhenNotVisible,
  });

  factory RendererPriorityPolicy.fromJson(Map<String, dynamic> json) =>
      _$RendererPriorityPolicyFromJson(json);

  @JsonKey(
    toJson: _rendererRequestedPriorityToJson,
    fromJson: _rendererRequestedPriorityFromJson,
  )
  final RendererPriority? rendererRequestedPriority;

  final bool waivedWhenNotVisible;

  RendererPriorityPolicy copyWith({
    RendererPriority? rendererRequestedPriority,
    bool? waivedWhenNotVisible,
  }) {
    return RendererPriorityPolicy(
      rendererRequestedPriority:
          rendererRequestedPriority ?? this.rendererRequestedPriority,
      waivedWhenNotVisible: waivedWhenNotVisible ?? this.waivedWhenNotVisible,
    );
  }

  RendererPriorityPolicy copyWithRendererPriorityPolicy({
    RendererPriority? rendererRequestedPriority,
    bool? waivedWhenNotVisible,
  }) {
    return copyWith(
      rendererRequestedPriority: rendererRequestedPriority,
      waivedWhenNotVisible: waivedWhenNotVisible,
    );
  }

  RendererPriorityPolicy patchWithRendererPriorityPolicy([
    RendererPriorityPolicyPatch? patchInput,
  ]) {
    final _patcher = patchInput ?? RendererPriorityPolicyPatch();
    final _patchMap = _patcher.patchMap;
    return RendererPriorityPolicy(
      rendererRequestedPriority:
          _patchMap.containsKey(
            RendererPriorityPolicy$.rendererRequestedPriority,
          )
          ? (_patchMap[RendererPriorityPolicy$.rendererRequestedPriority]
                    is Function)
                ? _patchMap[RendererPriorityPolicy$.rendererRequestedPriority](
                    this.rendererRequestedPriority,
                  )
                : (_patchMap[RendererPriorityPolicy$.rendererRequestedPriority]
                      is Patch)
                ? _patchMap[RendererPriorityPolicy$.rendererRequestedPriority]
                      .applyTo(this.rendererRequestedPriority)
                : _patchMap[RendererPriorityPolicy$.rendererRequestedPriority]
          : this.rendererRequestedPriority,
      waivedWhenNotVisible:
          _patchMap.containsKey(RendererPriorityPolicy$.waivedWhenNotVisible)
          ? (_patchMap[RendererPriorityPolicy$.waivedWhenNotVisible]
                    is Function)
                ? _patchMap[RendererPriorityPolicy$.waivedWhenNotVisible](
                    this.waivedWhenNotVisible,
                  )
                : (_patchMap[RendererPriorityPolicy$.waivedWhenNotVisible]
                      is Patch)
                ? _patchMap[RendererPriorityPolicy$.waivedWhenNotVisible]
                      .applyTo(this.waivedWhenNotVisible)
                : _patchMap[RendererPriorityPolicy$.waivedWhenNotVisible]
          : this.waivedWhenNotVisible,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RendererPriorityPolicy &&
        rendererRequestedPriority == other.rendererRequestedPriority &&
        waivedWhenNotVisible == other.waivedWhenNotVisible;
  }

  @override
  int get hashCode {
    return Object.hash(
      this.rendererRequestedPriority,
      this.waivedWhenNotVisible,
    );
  }

  @override
  String toString() {
    return 'RendererPriorityPolicy(' +
        'rendererRequestedPriority: ${rendererRequestedPriority}' +
        ', ' +
        'waivedWhenNotVisible: ${waivedWhenNotVisible})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$RendererPriorityPolicyToJson(this);
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

extension RendererPriorityPolicyPropertyHelpers on RendererPriorityPolicy {
  bool get hasRendererRequestedPriority {
    return this.rendererRequestedPriority != null;
  }

  bool get noRendererRequestedPriority {
    return this.rendererRequestedPriority == null;
  }

  RendererPriority get rendererRequestedPriorityRequired {
    return this.rendererRequestedPriority ??
        (throw StateError(
          'rendererRequestedPriority is required but was null',
        ));
  }

  bool get isRendererRequestedPriorityRENDERER_PRIORITY_WAIVED {
    return this.rendererRequestedPriority ==
        RendererPriority.RENDERER_PRIORITY_WAIVED;
  }

  bool get isRendererRequestedPriorityRENDERER_PRIORITY_BOUND {
    return this.rendererRequestedPriority ==
        RendererPriority.RENDERER_PRIORITY_BOUND;
  }

  bool get isRendererRequestedPriorityRENDERER_PRIORITY_IMPORTANT {
    return this.rendererRequestedPriority ==
        RendererPriority.RENDERER_PRIORITY_IMPORTANT;
  }
}

extension RendererPriorityPolicySerialization on RendererPriorityPolicy {
  Map<String, dynamic> toJson() {
    return _$RendererPriorityPolicyToJson(this);
  }
}

enum RendererPriorityPolicy$ { rendererRequestedPriority, waivedWhenNotVisible }

class RendererPriorityPolicyPatch
    extends PatchBase<RendererPriorityPolicy, RendererPriorityPolicy$> {
  RendererPriorityPolicy applyTo(RendererPriorityPolicy entity) {
    return entity.patchWithRendererPriorityPolicy(this);
  }

  RendererPriorityPolicyPatch withRendererRequestedPriority(
    RendererPriority? value,
  ) {
    patchMap[RendererPriorityPolicy$.rendererRequestedPriority] = value;
    return this;
  }

  RendererPriorityPolicyPatch withWaivedWhenNotVisible(bool? value) {
    patchMap[RendererPriorityPolicy$.waivedWhenNotVisible] = value;
    return this;
  }
}

/// Field descriptors for [RendererPriorityPolicy] query construction
abstract final class RendererPriorityPolicyFields {
  static const rendererRequestedPriority =
      Field<RendererPriorityPolicy, RendererPriority?>(
        'rendererRequestedPriority',
        _$rendererRequestedPriority,
      );

  static const waivedWhenNotVisible = Field<RendererPriorityPolicy, bool>(
    'waivedWhenNotVisible',
    _$waivedWhenNotVisible,
  );

  static RendererPriority? _$rendererRequestedPriority(
    RendererPriorityPolicy e,
  ) {
    return e.rendererRequestedPriority;
  }

  static bool _$waivedWhenNotVisible(RendererPriorityPolicy e) {
    return e.waivedWhenNotVisible;
  }
}

extension RendererPriorityPolicyCompareE on RendererPriorityPolicy {
  Map<String, dynamic> compareToRendererPriorityPolicy(
    RendererPriorityPolicy other,
  ) {
    final Map<String, dynamic> diff = {};

    if (rendererRequestedPriority != other.rendererRequestedPriority) {
      diff['rendererRequestedPriority'] = () => other.rendererRequestedPriority;
    }

    if (waivedWhenNotVisible != other.waivedWhenNotVisible) {
      diff['waivedWhenNotVisible'] = () => other.waivedWhenNotVisible;
    }
    return diff;
  }
}
