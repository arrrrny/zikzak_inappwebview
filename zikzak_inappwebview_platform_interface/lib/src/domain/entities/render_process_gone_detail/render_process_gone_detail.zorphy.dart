// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'render_process_gone_detail.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class RenderProcessGoneDetail {
  RenderProcessGoneDetail({
    required bool this.didCrash,
    RendererPriority? this.rendererPriorityAtExit,
  });

  factory RenderProcessGoneDetail.fromJson(Map<String, dynamic> json) =>
      _$RenderProcessGoneDetailFromJson(json);

  final bool didCrash;

  @JsonKey(
    toJson: _rendererPriorityAtExitToJson,
    fromJson: _rendererPriorityAtExitFromJson,
  )
  final RendererPriority? rendererPriorityAtExit;

  RenderProcessGoneDetail copyWith({
    bool? didCrash,
    RendererPriority? rendererPriorityAtExit,
  }) {
    return RenderProcessGoneDetail(
      didCrash: didCrash ?? this.didCrash,
      rendererPriorityAtExit:
          rendererPriorityAtExit ?? this.rendererPriorityAtExit,
    );
  }

  RenderProcessGoneDetail copyWithRenderProcessGoneDetail({
    bool? didCrash,
    RendererPriority? rendererPriorityAtExit,
  }) {
    return copyWith(
      didCrash: didCrash,
      rendererPriorityAtExit: rendererPriorityAtExit,
    );
  }

  RenderProcessGoneDetail patchWithRenderProcessGoneDetail([
    RenderProcessGoneDetailPatch? patchInput,
  ]) {
    final _patcher = patchInput ?? RenderProcessGoneDetailPatch();
    final _patchMap = _patcher.patchMap;
    return RenderProcessGoneDetail(
      didCrash: _patchMap.containsKey(RenderProcessGoneDetail$.didCrash)
          ? (_patchMap[RenderProcessGoneDetail$.didCrash] is Function)
                ? _patchMap[RenderProcessGoneDetail$.didCrash](this.didCrash)
                : (_patchMap[RenderProcessGoneDetail$.didCrash] is Patch)
                ? _patchMap[RenderProcessGoneDetail$.didCrash].applyTo(
                    this.didCrash,
                  )
                : _patchMap[RenderProcessGoneDetail$.didCrash]
          : this.didCrash,
      rendererPriorityAtExit:
          _patchMap.containsKey(RenderProcessGoneDetail$.rendererPriorityAtExit)
          ? (_patchMap[RenderProcessGoneDetail$.rendererPriorityAtExit]
                    is Function)
                ? _patchMap[RenderProcessGoneDetail$.rendererPriorityAtExit](
                    this.rendererPriorityAtExit,
                  )
                : (_patchMap[RenderProcessGoneDetail$.rendererPriorityAtExit]
                      is Patch)
                ? _patchMap[RenderProcessGoneDetail$.rendererPriorityAtExit]
                      .applyTo(this.rendererPriorityAtExit)
                : _patchMap[RenderProcessGoneDetail$.rendererPriorityAtExit]
          : this.rendererPriorityAtExit,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RenderProcessGoneDetail &&
        didCrash == other.didCrash &&
        rendererPriorityAtExit == other.rendererPriorityAtExit;
  }

  @override
  int get hashCode {
    return Object.hash(this.didCrash, this.rendererPriorityAtExit);
  }

  @override
  String toString() {
    return 'RenderProcessGoneDetail(' +
        'didCrash: ${didCrash}' +
        ', ' +
        'rendererPriorityAtExit: ${rendererPriorityAtExit})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$RenderProcessGoneDetailToJson(this);
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

extension RenderProcessGoneDetailPropertyHelpers on RenderProcessGoneDetail {
  bool get hasRendererPriorityAtExit {
    return this.rendererPriorityAtExit != null;
  }

  bool get noRendererPriorityAtExit {
    return this.rendererPriorityAtExit == null;
  }

  RendererPriority get rendererPriorityAtExitRequired {
    return this.rendererPriorityAtExit ??
        (throw StateError('rendererPriorityAtExit is required but was null'));
  }

  bool get isRendererPriorityAtExitRENDERER_PRIORITY_WAIVED {
    return this.rendererPriorityAtExit ==
        RendererPriority.RENDERER_PRIORITY_WAIVED;
  }

  bool get isRendererPriorityAtExitRENDERER_PRIORITY_BOUND {
    return this.rendererPriorityAtExit ==
        RendererPriority.RENDERER_PRIORITY_BOUND;
  }

  bool get isRendererPriorityAtExitRENDERER_PRIORITY_IMPORTANT {
    return this.rendererPriorityAtExit ==
        RendererPriority.RENDERER_PRIORITY_IMPORTANT;
  }
}

extension RenderProcessGoneDetailSerialization on RenderProcessGoneDetail {
  Map<String, dynamic> toJson() {
    return _$RenderProcessGoneDetailToJson(this);
  }
}

enum RenderProcessGoneDetail$ { didCrash, rendererPriorityAtExit }

class RenderProcessGoneDetailPatch
    extends PatchBase<RenderProcessGoneDetail, RenderProcessGoneDetail$> {
  RenderProcessGoneDetail applyTo(RenderProcessGoneDetail entity) {
    return entity.patchWithRenderProcessGoneDetail(this);
  }

  RenderProcessGoneDetailPatch withDidCrash(bool? value) {
    patchMap[RenderProcessGoneDetail$.didCrash] = value;
    return this;
  }

  RenderProcessGoneDetailPatch withRendererPriorityAtExit(
    RendererPriority? value,
  ) {
    patchMap[RenderProcessGoneDetail$.rendererPriorityAtExit] = value;
    return this;
  }
}

/// Field descriptors for [RenderProcessGoneDetail] query construction
abstract final class RenderProcessGoneDetailFields {
  static const didCrash = Field<RenderProcessGoneDetail, bool>(
    'didCrash',
    _$didCrash,
  );

  static const rendererPriorityAtExit =
      Field<RenderProcessGoneDetail, RendererPriority?>(
        'rendererPriorityAtExit',
        _$rendererPriorityAtExit,
      );

  static bool _$didCrash(RenderProcessGoneDetail e) {
    return e.didCrash;
  }

  static RendererPriority? _$rendererPriorityAtExit(RenderProcessGoneDetail e) {
    return e.rendererPriorityAtExit;
  }
}

extension RenderProcessGoneDetailCompareE on RenderProcessGoneDetail {
  Map<String, dynamic> compareToRenderProcessGoneDetail(
    RenderProcessGoneDetail other,
  ) {
    final Map<String, dynamic> diff = {};

    if (didCrash != other.didCrash) {
      diff['didCrash'] = () => other.didCrash;
    }

    if (rendererPriorityAtExit != other.rendererPriorityAtExit) {
      diff['rendererPriorityAtExit'] = () => other.rendererPriorityAtExit;
    }
    return diff;
  }
}
