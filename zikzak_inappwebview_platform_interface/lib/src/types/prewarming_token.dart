import 'package:zikzak_inappwebview_internal_annotations/zikzak_inappwebview_internal_annotations.dart';

import '../chrome_safari_browser/platform_chrome_safari_browser.dart';

part 'prewarming_token.g.dart';

///Class that represents the Prewarming Token returned by [PlatformChromeSafariBrowser.prewarmConnections].
@ExchangeableObject()
class PrewarmingToken_ {
  ///Prewarming Token id.
  final String id;

  PrewarmingToken_({required this.id});
}
