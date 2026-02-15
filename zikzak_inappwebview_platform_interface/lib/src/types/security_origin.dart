import 'package:zikzak_inappwebview_internal_annotations/zikzak_inappwebview_internal_annotations.dart';

part 'security_origin.g.dart';

///An object that identifies the origin of a particular resource.
@ExchangeableObject()
class SecurityOrigin_ {
  ///The security origin’s host.
  String host;

  ///The security origin's port.
  int port;

  ///The security origin's protocol.
  String protocol;

  SecurityOrigin_(
      {required this.host, required this.port, required this.protocol});
}
