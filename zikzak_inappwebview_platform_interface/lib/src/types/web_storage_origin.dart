import 'package:zikzak_inappwebview_internal_annotations/zikzak_inappwebview_internal_annotations.dart';

import '../web_storage/platform_web_storage_manager.dart';

part 'web_storage_origin.g.dart';

///Class that encapsulates information about the amount of storage currently used by an origin for the JavaScript storage APIs.
///An origin comprises the host, scheme and port of a URI. See [PlatformWebStorageManager] for details.
@ExchangeableObject()
class WebStorageOrigin_ {
  ///The string representation of this origin.
  String? origin;

  ///The quota for this origin, for the Web SQL Database API, in bytes.
  int? quota;

  ///The total amount of storage currently being used by this origin, for all JavaScript storage APIs, in bytes.
  int? usage;

  WebStorageOrigin_({this.origin, this.quota, this.usage});
}
