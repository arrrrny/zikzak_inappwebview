import 'package:zorphy_annotation/zorphy_annotation.dart';

import '../../../web_uri.dart';
import '../enums/proxy_scheme_filter.dart';

part 'proxy_rule.zorphy.dart';
part 'proxy_rule.g.dart';

///Class that holds a scheme filter and a proxy URL.
@Zorphy(
  kind: ZorphyKind.valueObject,
  generateJson: true,
  generateCompareTo: true,
)
abstract class $ProxyRule {
  ///Represents the proxy URL.
  @JsonKey(fromJson: _urlFromJson, toJson: _urlToJson)
  WebUri get url;
  ///Represents the scheme filter.
  @JsonKey(fromJson: _schemeFilterFromJson, toJson: _schemeFilterToJson)
  ProxySchemeFilter? get schemeFilter;
}
WebUri _urlFromJson(Object? value) => WebUri(value as String);

Object? _urlToJson(WebUri value) => value.toString();

ProxySchemeFilter? _schemeFilterFromJson(Object? value) => proxySchemeFilterFromWire(value);

Object? _schemeFilterToJson(ProxySchemeFilter? value) => proxySchemeFilterToWire(value);
