// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'cookie.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class Cookie {
  Cookie({
    required String this.name,
    dynamic this.value,
    int? this.expiresDate,
    bool? this.isSessionOnly,
    String? this.domain,
    HTTPCookieSameSitePolicy? this.sameSite,
    bool? this.isSecure,
    bool? this.isHttpOnly,
    String? this.path,
  });

  factory Cookie.fromJson(Map<String, dynamic> json) => _$CookieFromJson(json);

  final String name;

  final dynamic value;

  final int? expiresDate;

  final bool? isSessionOnly;

  final String? domain;

  @JsonKey(toJson: _sameSiteToJson, fromJson: _sameSiteFromJson)
  final HTTPCookieSameSitePolicy? sameSite;

  final bool? isSecure;

  final bool? isHttpOnly;

  final String? path;

  Cookie copyWith({
    String? name,
    dynamic value,
    int? expiresDate,
    bool? isSessionOnly,
    String? domain,
    HTTPCookieSameSitePolicy? sameSite,
    bool? isSecure,
    bool? isHttpOnly,
    String? path,
  }) {
    return Cookie(
      name: name ?? this.name,
      value: value ?? this.value,
      expiresDate: expiresDate ?? this.expiresDate,
      isSessionOnly: isSessionOnly ?? this.isSessionOnly,
      domain: domain ?? this.domain,
      sameSite: sameSite ?? this.sameSite,
      isSecure: isSecure ?? this.isSecure,
      isHttpOnly: isHttpOnly ?? this.isHttpOnly,
      path: path ?? this.path,
    );
  }

  Cookie copyWithCookie({
    String? name,
    dynamic value,
    int? expiresDate,
    bool? isSessionOnly,
    String? domain,
    HTTPCookieSameSitePolicy? sameSite,
    bool? isSecure,
    bool? isHttpOnly,
    String? path,
  }) {
    return copyWith(
      name: name,
      value: value,
      expiresDate: expiresDate,
      isSessionOnly: isSessionOnly,
      domain: domain,
      sameSite: sameSite,
      isSecure: isSecure,
      isHttpOnly: isHttpOnly,
      path: path,
    );
  }

  Cookie patchWithCookie([CookiePatch? patchInput]) {
    final _patcher = patchInput ?? CookiePatch();
    final _patchMap = _patcher.patchMap;
    return Cookie(
      name: _patchMap.containsKey(Cookie$.name_)
          ? (_patchMap[Cookie$.name_] is Function)
                ? _patchMap[Cookie$.name_](this.name)
                : (_patchMap[Cookie$.name_] is Patch)
                ? _patchMap[Cookie$.name_].applyTo(this.name)
                : _patchMap[Cookie$.name_]
          : this.name,
      value: _patchMap.containsKey(Cookie$.value)
          ? (_patchMap[Cookie$.value] is Function)
                ? _patchMap[Cookie$.value](this.value)
                : (_patchMap[Cookie$.value] is Patch)
                ? _patchMap[Cookie$.value].applyTo(this.value)
                : _patchMap[Cookie$.value]
          : this.value,
      expiresDate: _patchMap.containsKey(Cookie$.expiresDate)
          ? (_patchMap[Cookie$.expiresDate] is Function)
                ? _patchMap[Cookie$.expiresDate](this.expiresDate)
                : (_patchMap[Cookie$.expiresDate] is Patch)
                ? _patchMap[Cookie$.expiresDate].applyTo(this.expiresDate)
                : _patchMap[Cookie$.expiresDate]
          : this.expiresDate,
      isSessionOnly: _patchMap.containsKey(Cookie$.isSessionOnly)
          ? (_patchMap[Cookie$.isSessionOnly] is Function)
                ? _patchMap[Cookie$.isSessionOnly](this.isSessionOnly)
                : (_patchMap[Cookie$.isSessionOnly] is Patch)
                ? _patchMap[Cookie$.isSessionOnly].applyTo(this.isSessionOnly)
                : _patchMap[Cookie$.isSessionOnly]
          : this.isSessionOnly,
      domain: _patchMap.containsKey(Cookie$.domain)
          ? (_patchMap[Cookie$.domain] is Function)
                ? _patchMap[Cookie$.domain](this.domain)
                : (_patchMap[Cookie$.domain] is Patch)
                ? _patchMap[Cookie$.domain].applyTo(this.domain)
                : _patchMap[Cookie$.domain]
          : this.domain,
      sameSite: _patchMap.containsKey(Cookie$.sameSite)
          ? (_patchMap[Cookie$.sameSite] is Function)
                ? _patchMap[Cookie$.sameSite](this.sameSite)
                : (_patchMap[Cookie$.sameSite] is Patch)
                ? _patchMap[Cookie$.sameSite].applyTo(this.sameSite)
                : _patchMap[Cookie$.sameSite]
          : this.sameSite,
      isSecure: _patchMap.containsKey(Cookie$.isSecure)
          ? (_patchMap[Cookie$.isSecure] is Function)
                ? _patchMap[Cookie$.isSecure](this.isSecure)
                : (_patchMap[Cookie$.isSecure] is Patch)
                ? _patchMap[Cookie$.isSecure].applyTo(this.isSecure)
                : _patchMap[Cookie$.isSecure]
          : this.isSecure,
      isHttpOnly: _patchMap.containsKey(Cookie$.isHttpOnly)
          ? (_patchMap[Cookie$.isHttpOnly] is Function)
                ? _patchMap[Cookie$.isHttpOnly](this.isHttpOnly)
                : (_patchMap[Cookie$.isHttpOnly] is Patch)
                ? _patchMap[Cookie$.isHttpOnly].applyTo(this.isHttpOnly)
                : _patchMap[Cookie$.isHttpOnly]
          : this.isHttpOnly,
      path: _patchMap.containsKey(Cookie$.path)
          ? (_patchMap[Cookie$.path] is Function)
                ? _patchMap[Cookie$.path](this.path)
                : (_patchMap[Cookie$.path] is Patch)
                ? _patchMap[Cookie$.path].applyTo(this.path)
                : _patchMap[Cookie$.path]
          : this.path,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Cookie &&
        name == other.name &&
        value == other.value &&
        expiresDate == other.expiresDate &&
        isSessionOnly == other.isSessionOnly &&
        domain == other.domain &&
        sameSite == other.sameSite &&
        isSecure == other.isSecure &&
        isHttpOnly == other.isHttpOnly &&
        path == other.path;
  }

  @override
  int get hashCode {
    return Object.hash(
      this.name,
      this.value,
      this.expiresDate,
      this.isSessionOnly,
      this.domain,
      this.sameSite,
      this.isSecure,
      this.isHttpOnly,
      this.path,
    );
  }

  @override
  String toString() {
    return 'Cookie(' +
        'name: ${name}' +
        ', ' +
        'value: ${value}' +
        ', ' +
        'expiresDate: ${expiresDate}' +
        ', ' +
        'isSessionOnly: ${isSessionOnly}' +
        ', ' +
        'domain: ${domain}' +
        ', ' +
        'sameSite: ${sameSite}' +
        ', ' +
        'isSecure: ${isSecure}' +
        ', ' +
        'isHttpOnly: ${isHttpOnly}' +
        ', ' +
        'path: ${path})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$CookieToJson(this);
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

extension CookiePropertyHelpers on Cookie {
  bool get hasName {
    return this.name.isNotEmpty;
  }

  bool get noName {
    return this.name.isEmpty;
  }

  bool get hasExpiresDate {
    return this.expiresDate != null;
  }

  bool get noExpiresDate {
    return this.expiresDate == null;
  }

  int get expiresDateRequired {
    return this.expiresDate ??
        (throw StateError('expiresDate is required but was null'));
  }

  bool get hasIsSessionOnly {
    return this.isSessionOnly != null;
  }

  bool get noIsSessionOnly {
    return this.isSessionOnly == null;
  }

  bool get isSessionOnlyRequired {
    return this.isSessionOnly ??
        (throw StateError('isSessionOnly is required but was null'));
  }

  bool get hasDomain {
    return this.domain?.isNotEmpty == true;
  }

  bool get noDomain {
    return this.domain?.isEmpty ?? true;
  }

  String get domainRequired {
    return this.domain ?? (throw StateError('domain is required but was null'));
  }

  bool get hasSameSite {
    return this.sameSite != null;
  }

  bool get noSameSite {
    return this.sameSite == null;
  }

  HTTPCookieSameSitePolicy get sameSiteRequired {
    return this.sameSite ??
        (throw StateError('sameSite is required but was null'));
  }

  bool get isSameSiteLAX {
    return this.sameSite == HTTPCookieSameSitePolicy.LAX;
  }

  bool get isSameSiteSTRICT {
    return this.sameSite == HTTPCookieSameSitePolicy.STRICT;
  }

  bool get isSameSiteNONE {
    return this.sameSite == HTTPCookieSameSitePolicy.NONE;
  }

  bool get hasIsSecure {
    return this.isSecure != null;
  }

  bool get noIsSecure {
    return this.isSecure == null;
  }

  bool get isSecureRequired {
    return this.isSecure ??
        (throw StateError('isSecure is required but was null'));
  }

  bool get hasIsHttpOnly {
    return this.isHttpOnly != null;
  }

  bool get noIsHttpOnly {
    return this.isHttpOnly == null;
  }

  bool get isHttpOnlyRequired {
    return this.isHttpOnly ??
        (throw StateError('isHttpOnly is required but was null'));
  }

  bool get hasPath {
    return this.path?.isNotEmpty == true;
  }

  bool get noPath {
    return this.path?.isEmpty ?? true;
  }

  String get pathRequired {
    return this.path ?? (throw StateError('path is required but was null'));
  }
}

extension CookieSerialization on Cookie {
  Map<String, dynamic> toJson() {
    return _$CookieToJson(this);
  }
}

enum Cookie$ {
  name_,
  value,
  expiresDate,
  isSessionOnly,
  domain,
  sameSite,
  isSecure,
  isHttpOnly,
  path,
}

class CookiePatch extends PatchBase<Cookie, Cookie$> {
  Cookie applyTo(Cookie entity) {
    return entity.patchWithCookie(this);
  }

  CookiePatch withName(String? value) {
    patchMap[Cookie$.name_] = value;
    return this;
  }

  CookiePatch withValue(dynamic value) {
    patchMap[Cookie$.value] = value;
    return this;
  }

  CookiePatch withExpiresDate(int? value) {
    patchMap[Cookie$.expiresDate] = value;
    return this;
  }

  CookiePatch withIsSessionOnly(bool? value) {
    patchMap[Cookie$.isSessionOnly] = value;
    return this;
  }

  CookiePatch withDomain(String? value) {
    patchMap[Cookie$.domain] = value;
    return this;
  }

  CookiePatch withSameSite(HTTPCookieSameSitePolicy? value) {
    patchMap[Cookie$.sameSite] = value;
    return this;
  }

  CookiePatch withIsSecure(bool? value) {
    patchMap[Cookie$.isSecure] = value;
    return this;
  }

  CookiePatch withIsHttpOnly(bool? value) {
    patchMap[Cookie$.isHttpOnly] = value;
    return this;
  }

  CookiePatch withPath(String? value) {
    patchMap[Cookie$.path] = value;
    return this;
  }
}

/// Field descriptors for [Cookie] query construction
abstract final class CookieFields {
  static const name = Field<Cookie, String>('name', _$name);

  static const value = Field<Cookie, dynamic>('value', _$value);

  static const expiresDate = Field<Cookie, int?>('expiresDate', _$expiresDate);

  static const isSessionOnly = Field<Cookie, bool?>(
    'isSessionOnly',
    _$isSessionOnly,
  );

  static const domain = Field<Cookie, String?>('domain', _$domain);

  static const sameSite = Field<Cookie, HTTPCookieSameSitePolicy?>(
    'sameSite',
    _$sameSite,
  );

  static const isSecure = Field<Cookie, bool?>('isSecure', _$isSecure);

  static const isHttpOnly = Field<Cookie, bool?>('isHttpOnly', _$isHttpOnly);

  static const path = Field<Cookie, String?>('path', _$path);

  static String _$name(Cookie e) {
    return e.name;
  }

  static dynamic _$value(Cookie e) {
    return e.value;
  }

  static int? _$expiresDate(Cookie e) {
    return e.expiresDate;
  }

  static bool? _$isSessionOnly(Cookie e) {
    return e.isSessionOnly;
  }

  static String? _$domain(Cookie e) {
    return e.domain;
  }

  static HTTPCookieSameSitePolicy? _$sameSite(Cookie e) {
    return e.sameSite;
  }

  static bool? _$isSecure(Cookie e) {
    return e.isSecure;
  }

  static bool? _$isHttpOnly(Cookie e) {
    return e.isHttpOnly;
  }

  static String? _$path(Cookie e) {
    return e.path;
  }
}

extension CookieCompareE on Cookie {
  Map<String, dynamic> compareToCookie(Cookie other) {
    final Map<String, dynamic> diff = {};

    if (name != other.name) {
      diff['name'] = () => other.name;
    }

    if (value != other.value) {
      diff['value'] = () => other.value;
    }

    if (expiresDate != other.expiresDate) {
      diff['expiresDate'] = () => other.expiresDate;
    }

    if (isSessionOnly != other.isSessionOnly) {
      diff['isSessionOnly'] = () => other.isSessionOnly;
    }

    if (domain != other.domain) {
      diff['domain'] = () => other.domain;
    }

    if (sameSite != other.sameSite) {
      diff['sameSite'] = () => other.sameSite;
    }

    if (isSecure != other.isSecure) {
      diff['isSecure'] = () => other.isSecure;
    }

    if (isHttpOnly != other.isHttpOnly) {
      diff['isHttpOnly'] = () => other.isHttpOnly;
    }

    if (path != other.path) {
      diff['path'] = () => other.path;
    }
    return diff;
  }
}
