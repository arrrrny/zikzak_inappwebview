// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'prewarming_token.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class PrewarmingToken {
  PrewarmingToken({required String this.id});

  factory PrewarmingToken.fromJson(Map<String, dynamic> json) =>
      _$PrewarmingTokenFromJson(json);

  final String id;

  PrewarmingToken copyWith({String? id}) {
    return PrewarmingToken(id: id ?? this.id);
  }

  PrewarmingToken copyWithPrewarmingToken({String? id}) {
    return copyWith(id: id);
  }

  PrewarmingToken patchWithPrewarmingToken([PrewarmingTokenPatch? patchInput]) {
    final _patcher = patchInput ?? PrewarmingTokenPatch();
    final _patchMap = _patcher.patchMap;
    return PrewarmingToken(
      id: _patchMap.containsKey(PrewarmingToken$.id)
          ? ((_patchMap[PrewarmingToken$.id] is Function)
                    ? _patchMap[PrewarmingToken$.id](this.id)
                    : (_patchMap[PrewarmingToken$.id] is Patch)
                    ? _patchMap[PrewarmingToken$.id].applyTo(this.id)
                    : _patchMap[PrewarmingToken$.id])
                as String
          : this.id,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PrewarmingToken && id == other.id;
  }

  @override
  int get hashCode {
    return Object.hash(id, 0);
  }

  @override
  String toString() {
    return 'PrewarmingToken(' + 'id: ${id})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$PrewarmingTokenToJson(this);
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

extension PrewarmingTokenPropertyHelpers on PrewarmingToken {
  bool get hasId {
    return this.id.isNotEmpty;
  }

  bool get noId {
    return this.id.isEmpty;
  }
}

extension PrewarmingTokenSerialization on PrewarmingToken {
  Map<String, dynamic> toJson() {
    return _$PrewarmingTokenToJson(this);
  }
}

enum PrewarmingToken$ { id }

class PrewarmingTokenPatch
    extends PatchBase<PrewarmingToken, PrewarmingToken$> {
  PrewarmingToken applyTo(PrewarmingToken entity) {
    return entity.patchWithPrewarmingToken(this);
  }

  PrewarmingTokenPatch withId(String? value) {
    patchMap[PrewarmingToken$.id] = value;
    return this;
  }
}

/// Field descriptors for [PrewarmingToken] query construction
abstract final class PrewarmingTokenFields {
  static const id = Field<PrewarmingToken, String>('id', _$id);

  static String _$id(PrewarmingToken e) {
    return e.id;
  }
}

extension PrewarmingTokenCompareE on PrewarmingToken {
  Map<String, dynamic> compareToPrewarmingToken(PrewarmingToken other) {
    final Map<String, dynamic> diff = {};

    if (id != other.id) {
      diff['id'] = () => other.id;
    }
    return diff;
  }
}
