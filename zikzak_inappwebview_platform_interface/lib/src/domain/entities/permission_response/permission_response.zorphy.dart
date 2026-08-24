// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'permission_response.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class PermissionResponse {
  PermissionResponse({
    List<PermissionResourceType>? resources,
    PermissionResponseAction? action,
  }) : this.resources = resources ?? const [],
       this.action = action ?? PermissionResponseAction.DENY;

  factory PermissionResponse.fromJson(Map<String, dynamic> json) =>
      _$PermissionResponseFromJson(json);

  @JsonKey(
    defaultValue: const [],
    toJson: _resourcesToJson,
    fromJson: _resourcesFromJson,
  )
  final List<PermissionResourceType>? resources;

  @JsonKey(
    defaultValue: PermissionResponseAction.DENY,
    toJson: _actionToJson,
    fromJson: _actionFromJson,
  )
  final PermissionResponseAction? action;

  PermissionResponse copyWith({
    List<PermissionResourceType>? resources,
    PermissionResponseAction? action,
  }) {
    return PermissionResponse(
      resources: resources ?? this.resources,
      action: action ?? this.action,
    );
  }

  PermissionResponse copyWithPermissionResponse({
    List<PermissionResourceType>? resources,
    PermissionResponseAction? action,
  }) {
    return copyWith(resources: resources, action: action);
  }

  PermissionResponse patchWithPermissionResponse([
    PermissionResponsePatch? patchInput,
  ]) {
    final _patcher = patchInput ?? PermissionResponsePatch();
    final _patchMap = _patcher.patchMap;
    return PermissionResponse(
      resources: _patchMap.containsKey(PermissionResponse$.resources)
          ? ((_patchMap[PermissionResponse$.resources] is Function)
                    ? _patchMap[PermissionResponse$.resources](this.resources)
                    : (_patchMap[PermissionResponse$.resources] is Patch)
                    ? _patchMap[PermissionResponse$.resources].applyTo(
                        this.resources,
                      )
                    : _patchMap[PermissionResponse$.resources])
                as List<PermissionResourceType>?
          : this.resources,
      action: _patchMap.containsKey(PermissionResponse$.action)
          ? ((_patchMap[PermissionResponse$.action] is Function)
                    ? _patchMap[PermissionResponse$.action](this.action)
                    : (_patchMap[PermissionResponse$.action] is Patch)
                    ? _patchMap[PermissionResponse$.action].applyTo(this.action)
                    : _patchMap[PermissionResponse$.action])
                as PermissionResponseAction?
          : this.action,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PermissionResponse &&
        resources == other.resources &&
        action == other.action;
  }

  @override
  int get hashCode {
    return Object.hash(this.resources, this.action);
  }

  @override
  String toString() {
    return 'PermissionResponse(' +
        'resources: ${resources}' +
        ', ' +
        'action: ${action})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$PermissionResponseToJson(this);
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

extension PermissionResponsePropertyHelpers on PermissionResponse {
  List<PermissionResourceType> get resourcesRequired {
    return this.resources ??
        (throw StateError('resources is required but was null'));
  }

  bool get hasResources {
    return this.resources?.isNotEmpty ?? false;
  }

  bool get noResources {
    return this.resources?.isEmpty ?? true;
  }

  bool get hasAction {
    return this.action != null;
  }

  bool get noAction {
    return this.action == null;
  }

  PermissionResponseAction get actionRequired {
    return this.action ?? (throw StateError('action is required but was null'));
  }

  bool get isActionDENY {
    return this.action == PermissionResponseAction.DENY;
  }

  bool get isActionGRANT {
    return this.action == PermissionResponseAction.GRANT;
  }

  bool get isActionPROMPT {
    return this.action == PermissionResponseAction.PROMPT;
  }
}

extension PermissionResponseSerialization on PermissionResponse {
  Map<String, dynamic> toJson() {
    return _$PermissionResponseToJson(this);
  }
}

enum PermissionResponse$ { resources, action }

class PermissionResponsePatch
    extends PatchBase<PermissionResponse, PermissionResponse$> {
  PermissionResponse applyTo(PermissionResponse entity) {
    return entity.patchWithPermissionResponse(this);
  }

  PermissionResponsePatch withResources(List<PermissionResourceType>? value) {
    patchMap[PermissionResponse$.resources] = value;
    return this;
  }

  PermissionResponsePatch withAction(PermissionResponseAction? value) {
    patchMap[PermissionResponse$.action] = value;
    return this;
  }
}

/// Field descriptors for [PermissionResponse] query construction
abstract final class PermissionResponseFields {
  static const resources =
      Field<PermissionResponse, List<PermissionResourceType>?>(
        'resources',
        _$resources,
      );

  static const action = Field<PermissionResponse, PermissionResponseAction?>(
    'action',
    _$action,
  );

  static List<PermissionResourceType>? _$resources(PermissionResponse e) {
    return e.resources;
  }

  static PermissionResponseAction? _$action(PermissionResponse e) {
    return e.action;
  }
}

extension PermissionResponseCompareE on PermissionResponse {
  Map<String, dynamic> compareToPermissionResponse(PermissionResponse other) {
    final Map<String, dynamic> diff = {};

    if (resources != other.resources) {
      diff['resources'] = () => other.resources;
    }

    if (action != other.action) {
      diff['action'] = () => other.action;
    }
    return diff;
  }
}
