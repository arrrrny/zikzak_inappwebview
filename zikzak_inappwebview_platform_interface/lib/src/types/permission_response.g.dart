// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'permission_response.dart';

// **************************************************************************
// ExchangeableObjectGenerator
// **************************************************************************

///Class that represents the response used by the [PlatformWebViewCreationParams.onPermissionRequest] event.
class PermissionResponse {
  ///Indicate the [PermissionResponseAction] to take in response of a permission request.
  PermissionResponseAction? action;

  ///Resources granted to be accessed by origin.
  ///
  ///**NOTE for iOS**: not used. The [action] taken is based on the [PermissionRequest.resources].
  List<PermissionResourceType> resources;
  PermissionResponse({
    this.action = PermissionResponseAction.DENY,
    this.resources = const [],
  });

  ///Gets a possible [PermissionResponse] instance from a [Map] value.
  static PermissionResponse? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = PermissionResponse();
    instance.action = PermissionResponseAction.fromNativeValue(map['action']);
    instance.resources = List<PermissionResourceType>.from(
      map['resources'].map((e) => PermissionResourceType.fromNativeValue(e)!),
    );
    return instance;
  }

  ///Converts instance to a map.
  Map<String, dynamic> toMap() {
    return {
      "action": action?.toNativeValue(),
      "resources": resources.map((e) => e.toNativeValue()).toList(),
    };
  }

  ///Converts instance to a map.
  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'PermissionResponse{action: $action, resources: $resources}';
  }
}
