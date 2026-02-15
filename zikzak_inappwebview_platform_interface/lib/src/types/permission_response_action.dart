import 'package:zikzak_inappwebview_internal_annotations/zikzak_inappwebview_internal_annotations.dart';

import 'permission_response.dart';

part 'permission_response_action.g.dart';

///Class used by [PermissionResponse] class.
@ExchangeableEnum()
class PermissionResponseAction_ {
  // ignore: unused_field
  final int _value;
  const PermissionResponseAction_._internal(this._value);

  ///Denies the request.
  static const DENY = const PermissionResponseAction_._internal(0);

  ///Grants origin the permission to access the given resources.
  static const GRANT = const PermissionResponseAction_._internal(1);

  ///Prompt the user for permission for the requested resource.
  static const PROMPT = const PermissionResponseAction_._internal(2);
}
