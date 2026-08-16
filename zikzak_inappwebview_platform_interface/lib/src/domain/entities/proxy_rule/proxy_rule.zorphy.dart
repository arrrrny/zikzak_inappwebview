// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'proxy_rule.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class ProxyRule {
  ProxyRule({required WebUri this.url, ProxySchemeFilter? this.schemeFilter});

  factory ProxyRule.fromJson(Map<String, dynamic> json) =>
      _$ProxyRuleFromJson(json);

  @JsonKey(toJson: _urlToJson, fromJson: _urlFromJson)
  final WebUri url;

  @JsonKey(toJson: _schemeFilterToJson, fromJson: _schemeFilterFromJson)
  final ProxySchemeFilter? schemeFilter;

  ProxyRule copyWith({WebUri? url, ProxySchemeFilter? schemeFilter}) {
    return ProxyRule(
      url: url ?? this.url,
      schemeFilter: schemeFilter ?? this.schemeFilter,
    );
  }

  ProxyRule copyWithProxyRule({WebUri? url, ProxySchemeFilter? schemeFilter}) {
    return copyWith(url: url, schemeFilter: schemeFilter);
  }

  ProxyRule patchWithProxyRule([ProxyRulePatch? patchInput]) {
    final _patcher = patchInput ?? ProxyRulePatch();
    final _patchMap = _patcher.patchMap;
    return ProxyRule(
      url: _patchMap.containsKey(ProxyRule$.url)
          ? (_patchMap[ProxyRule$.url] is Function)
                ? _patchMap[ProxyRule$.url](this.url)
                : (_patchMap[ProxyRule$.url] is Patch)
                ? _patchMap[ProxyRule$.url].applyTo(this.url)
                : _patchMap[ProxyRule$.url]
          : this.url,
      schemeFilter: _patchMap.containsKey(ProxyRule$.schemeFilter)
          ? (_patchMap[ProxyRule$.schemeFilter] is Function)
                ? _patchMap[ProxyRule$.schemeFilter](this.schemeFilter)
                : (_patchMap[ProxyRule$.schemeFilter] is Patch)
                ? _patchMap[ProxyRule$.schemeFilter].applyTo(this.schemeFilter)
                : _patchMap[ProxyRule$.schemeFilter]
          : this.schemeFilter,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProxyRule &&
        url == other.url &&
        schemeFilter == other.schemeFilter;
  }

  @override
  int get hashCode {
    return Object.hash(this.url, this.schemeFilter);
  }

  @override
  String toString() {
    return 'ProxyRule(' +
        'url: ${url}' +
        ', ' +
        'schemeFilter: ${schemeFilter})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$ProxyRuleToJson(this);
    return _sanitizeJson(data);
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

extension ProxyRulePropertyHelpers on ProxyRule {
  bool get hasSchemeFilter {
    return this.schemeFilter != null;
  }

  bool get noSchemeFilter {
    return this.schemeFilter == null;
  }

  ProxySchemeFilter get schemeFilterRequired {
    return this.schemeFilter ??
        (throw StateError('schemeFilter is required but was null'));
  }

  bool get isSchemeFilterMATCH_ALL_SCHEMES {
    return this.schemeFilter == ProxySchemeFilter.MATCH_ALL_SCHEMES;
  }

  bool get isSchemeFilterMATCH_HTTP {
    return this.schemeFilter == ProxySchemeFilter.MATCH_HTTP;
  }

  bool get isSchemeFilterMATCH_HTTPS {
    return this.schemeFilter == ProxySchemeFilter.MATCH_HTTPS;
  }
}

extension ProxyRuleSerialization on ProxyRule {
  Map<String, dynamic> toJson() {
    return _$ProxyRuleToJson(this);
  }
}

enum ProxyRule$ { url, schemeFilter }

class ProxyRulePatch extends PatchBase<ProxyRule, ProxyRule$> {
  ProxyRule applyTo(ProxyRule entity) {
    return entity.patchWithProxyRule(this);
  }

  ProxyRulePatch withUrl(WebUri? value) {
    patchMap[ProxyRule$.url] = value;
    return this;
  }

  ProxyRulePatch withSchemeFilter(ProxySchemeFilter? value) {
    patchMap[ProxyRule$.schemeFilter] = value;
    return this;
  }
}

/// Field descriptors for [ProxyRule] query construction
abstract final class ProxyRuleFields {
  static const url = Field<ProxyRule, WebUri>('url', _$url);

  static const schemeFilter = Field<ProxyRule, ProxySchemeFilter?>(
    'schemeFilter',
    _$schemeFilter,
  );

  static WebUri _$url(ProxyRule e) {
    return e.url;
  }

  static ProxySchemeFilter? _$schemeFilter(ProxyRule e) {
    return e.schemeFilter;
  }
}

extension ProxyRuleCompareE on ProxyRule {
  Map<String, dynamic> compareToProxyRule(ProxyRule other) {
    final Map<String, dynamic> diff = {};

    if (url != other.url) {
      diff['url'] = () => other.url;
    }

    if (schemeFilter != other.schemeFilter) {
      diff['schemeFilter'] = () => other.schemeFilter;
    }
    return diff;
  }
}
