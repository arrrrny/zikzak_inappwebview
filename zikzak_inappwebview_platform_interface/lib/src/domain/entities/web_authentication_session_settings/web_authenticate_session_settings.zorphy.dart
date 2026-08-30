// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'web_authenticate_session_settings.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class WebAuthenticationSessionSettings {
  WebAuthenticationSessionSettings({
    bool? prefersEphemeralWebBrowserSession,
    Map<String, String>? this.additionalHeaderFields,
  }) : this.prefersEphemeralWebBrowserSession =
           prefersEphemeralWebBrowserSession ?? false;

  factory WebAuthenticationSessionSettings.fromJson(
    Map<String, dynamic> json,
  ) => _$WebAuthenticationSessionSettingsFromJson(json);

  @JsonKey(defaultValue: false)
  final bool? prefersEphemeralWebBrowserSession;

  @JsonKey(
    toJson: _additionalHeaderFieldsToJson,
    fromJson: _additionalHeaderFieldsFromJson,
  )
  final Map<String, String>? additionalHeaderFields;

  WebAuthenticationSessionSettings copyWith({
    bool? prefersEphemeralWebBrowserSession,
    Map<String, String>? additionalHeaderFields,
  }) {
    return WebAuthenticationSessionSettings(
      prefersEphemeralWebBrowserSession:
          prefersEphemeralWebBrowserSession ??
          this.prefersEphemeralWebBrowserSession,
      additionalHeaderFields:
          additionalHeaderFields ?? this.additionalHeaderFields,
    );
  }

  WebAuthenticationSessionSettings copyWithWebAuthenticationSessionSettings({
    bool? prefersEphemeralWebBrowserSession,
    Map<String, String>? additionalHeaderFields,
  }) {
    return copyWith(
      prefersEphemeralWebBrowserSession: prefersEphemeralWebBrowserSession,
      additionalHeaderFields: additionalHeaderFields,
    );
  }

  WebAuthenticationSessionSettings patchWithWebAuthenticationSessionSettings([
    WebAuthenticationSessionSettingsPatch? patchInput,
  ]) {
    final _patcher = patchInput ?? WebAuthenticationSessionSettingsPatch();
    final _patchMap = _patcher.patchMap;
    return WebAuthenticationSessionSettings(
      prefersEphemeralWebBrowserSession:
          _patchMap.containsKey(
            WebAuthenticationSessionSettings$.prefersEphemeralWebBrowserSession,
          )
          ? ((_patchMap[WebAuthenticationSessionSettings$
                            .prefersEphemeralWebBrowserSession]
                        is Function)
                    ? _patchMap[WebAuthenticationSessionSettings$
                          .prefersEphemeralWebBrowserSession](
                        this.prefersEphemeralWebBrowserSession,
                      )
                    : (_patchMap[WebAuthenticationSessionSettings$
                              .prefersEphemeralWebBrowserSession]
                          is Patch)
                    ? _patchMap[WebAuthenticationSessionSettings$
                              .prefersEphemeralWebBrowserSession]
                          .applyTo(this.prefersEphemeralWebBrowserSession)
                    : _patchMap[WebAuthenticationSessionSettings$
                          .prefersEphemeralWebBrowserSession])
                as bool?
          : this.prefersEphemeralWebBrowserSession,
      additionalHeaderFields:
          _patchMap.containsKey(
            WebAuthenticationSessionSettings$.additionalHeaderFields,
          )
          ? ((_patchMap[WebAuthenticationSessionSettings$
                            .additionalHeaderFields]
                        is Function)
                    ? _patchMap[WebAuthenticationSessionSettings$
                          .additionalHeaderFields](this.additionalHeaderFields)
                    : (_patchMap[WebAuthenticationSessionSettings$
                              .additionalHeaderFields]
                          is Patch)
                    ? _patchMap[WebAuthenticationSessionSettings$
                              .additionalHeaderFields]
                          .applyTo(this.additionalHeaderFields)
                    : _patchMap[WebAuthenticationSessionSettings$
                          .additionalHeaderFields])
                as Map<String, String>?
          : this.additionalHeaderFields,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WebAuthenticationSessionSettings &&
        prefersEphemeralWebBrowserSession ==
            other.prefersEphemeralWebBrowserSession &&
        additionalHeaderFields == other.additionalHeaderFields;
  }

  @override
  int get hashCode {
    return Object.hash(
      this.prefersEphemeralWebBrowserSession,
      this.additionalHeaderFields,
    );
  }

  @override
  String toString() {
    return 'WebAuthenticationSessionSettings(' +
        'prefersEphemeralWebBrowserSession: ${prefersEphemeralWebBrowserSession}' +
        ', ' +
        'additionalHeaderFields: ${additionalHeaderFields})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$WebAuthenticationSessionSettingsToJson(
      this,
    );
    _sanitizeJson(data);
    return data;
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

extension WebAuthenticationSessionSettingsPropertyHelpers
    on WebAuthenticationSessionSettings {
  bool get hasPrefersEphemeralWebBrowserSession {
    return this.prefersEphemeralWebBrowserSession != null;
  }

  bool get noPrefersEphemeralWebBrowserSession {
    return this.prefersEphemeralWebBrowserSession == null;
  }

  bool get prefersEphemeralWebBrowserSessionRequired {
    return this.prefersEphemeralWebBrowserSession ??
        (throw StateError(
          'prefersEphemeralWebBrowserSession is required but was null',
        ));
  }

  Map<String, String> get additionalHeaderFieldsRequired {
    return this.additionalHeaderFields ??
        (throw StateError('additionalHeaderFields is required but was null'));
  }

  bool get hasAdditionalHeaderFields {
    return this.additionalHeaderFields?.isNotEmpty ?? false;
  }

  bool get noAdditionalHeaderFields {
    return this.additionalHeaderFields?.isEmpty ?? true;
  }
}

extension WebAuthenticationSessionSettingsSerialization
    on WebAuthenticationSessionSettings {
  Map<String, dynamic> toJson() {
    return _$WebAuthenticationSessionSettingsToJson(this);
  }
}

enum WebAuthenticationSessionSettings$ {
  prefersEphemeralWebBrowserSession,
  additionalHeaderFields,
}

class WebAuthenticationSessionSettingsPatch
    extends
        PatchBase<
          WebAuthenticationSessionSettings,
          WebAuthenticationSessionSettings$
        > {
  WebAuthenticationSessionSettings applyTo(
    WebAuthenticationSessionSettings entity,
  ) {
    return entity.patchWithWebAuthenticationSessionSettings(this);
  }

  WebAuthenticationSessionSettingsPatch withPrefersEphemeralWebBrowserSession(
    bool? value,
  ) {
    patchMap[WebAuthenticationSessionSettings$
            .prefersEphemeralWebBrowserSession] =
        value;
    return this;
  }

  WebAuthenticationSessionSettingsPatch withAdditionalHeaderFields(
    Map<String, String>? value,
  ) {
    patchMap[WebAuthenticationSessionSettings$.additionalHeaderFields] = value;
    return this;
  }
}

/// Field descriptors for [WebAuthenticationSessionSettings] query construction
abstract final class WebAuthenticationSessionSettingsFields {
  static const prefersEphemeralWebBrowserSession =
      Field<WebAuthenticationSessionSettings, bool?>(
        'prefersEphemeralWebBrowserSession',
        _$prefersEphemeralWebBrowserSession,
      );

  static const additionalHeaderFields =
      Field<WebAuthenticationSessionSettings, Map<String, String>?>(
        'additionalHeaderFields',
        _$additionalHeaderFields,
      );

  static bool? _$prefersEphemeralWebBrowserSession(
    WebAuthenticationSessionSettings e,
  ) {
    return e.prefersEphemeralWebBrowserSession;
  }

  static Map<String, String>? _$additionalHeaderFields(
    WebAuthenticationSessionSettings e,
  ) {
    return e.additionalHeaderFields;
  }
}

extension WebAuthenticationSessionSettingsCompareE
    on WebAuthenticationSessionSettings {
  Map<String, dynamic> compareToWebAuthenticationSessionSettings(
    WebAuthenticationSessionSettings other,
  ) {
    final Map<String, dynamic> diff = {};

    if (prefersEphemeralWebBrowserSession !=
        other.prefersEphemeralWebBrowserSession) {
      diff['prefersEphemeralWebBrowserSession'] = () =>
          other.prefersEphemeralWebBrowserSession;
    }

    if (additionalHeaderFields != other.additionalHeaderFields) {
      diff['additionalHeaderFields'] = () => other.additionalHeaderFields;
    }
    return diff;
  }
}
