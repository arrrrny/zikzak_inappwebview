import 'package:zikzak_inappwebview_internal_annotations/zikzak_inappwebview_internal_annotations.dart';
import '../in_app_webview/platform_webview.dart';
import 'permission_resource_type.dart';
import 'permission_response_action.dart';

part 'permission_response.g.dart';

///Class that represents the response used by the [PlatformWebViewCreationParams.onPermissionRequest] event.
@ExchangeableObject()
class PermissionResponse_ {
  ///Resources granted to be accessed by origin.
  ///
  ///**NOTE for iOS**: not used. The [action] taken is based on the [PermissionRequest.resources].
  List<PermissionResourceType_> resources;

  ///Indicate the [PermissionResponseAction] to take in response of a permission request.
  PermissionResponseAction_? action;

  PermissionResponse_({
    this.resources = const [],
    this.action = PermissionResponseAction_.DENY,
  });
}
