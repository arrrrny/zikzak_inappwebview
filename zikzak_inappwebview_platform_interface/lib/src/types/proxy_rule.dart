import 'package:zikzak_inappwebview_internal_annotations/zikzak_inappwebview_internal_annotations.dart';

import '../web_uri.dart';
import 'proxy_scheme_filter.dart';

part 'proxy_rule.g.dart';

///Class that holds a scheme filter and a proxy URL.
@ExchangeableObject()
class ProxyRule_ {
  ///Represents the scheme filter.
  ProxySchemeFilter_? schemeFilter;

  ///Represents the proxy URL.
  WebUri url;

  ProxyRule_({required this.url, this.schemeFilter});
}
