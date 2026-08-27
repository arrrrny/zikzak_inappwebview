// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'ui_event_attribution.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class UIEventAttribution {
  UIEventAttribution({
    required int this.sourceIdentifier,
    required WebUri this.destinationURL,
    required String this.sourceDescription,
    required String this.purchaser,
  });

  factory UIEventAttribution.fromJson(Map<String, dynamic> json) =>
      _$UIEventAttributionFromJson(json);

  final int sourceIdentifier;

  @JsonKey(toJson: _destinationURLToJson, fromJson: _destinationURLFromJson)
  final WebUri destinationURL;

  final String sourceDescription;

  final String purchaser;

  UIEventAttribution copyWith({
    int? sourceIdentifier,
    WebUri? destinationURL,
    String? sourceDescription,
    String? purchaser,
  }) {
    return UIEventAttribution(
      sourceIdentifier: sourceIdentifier ?? this.sourceIdentifier,
      destinationURL: destinationURL ?? this.destinationURL,
      sourceDescription: sourceDescription ?? this.sourceDescription,
      purchaser: purchaser ?? this.purchaser,
    );
  }

  UIEventAttribution copyWithUIEventAttribution({
    int? sourceIdentifier,
    WebUri? destinationURL,
    String? sourceDescription,
    String? purchaser,
  }) {
    return copyWith(
      sourceIdentifier: sourceIdentifier,
      destinationURL: destinationURL,
      sourceDescription: sourceDescription,
      purchaser: purchaser,
    );
  }

  UIEventAttribution patchWithUIEventAttribution([
    UIEventAttributionPatch? patchInput,
  ]) {
    final _patcher = patchInput ?? UIEventAttributionPatch();
    final _patchMap = _patcher.patchMap;
    return UIEventAttribution(
      sourceIdentifier:
          _patchMap.containsKey(UIEventAttribution$.sourceIdentifier)
          ? (_patchMap[UIEventAttribution$.sourceIdentifier] is Function)
                ? _patchMap[UIEventAttribution$.sourceIdentifier](
                    this.sourceIdentifier,
                  )
                : (_patchMap[UIEventAttribution$.sourceIdentifier] is Patch)
                ? _patchMap[UIEventAttribution$.sourceIdentifier].applyTo(
                    this.sourceIdentifier,
                  )
                : _patchMap[UIEventAttribution$.sourceIdentifier]
          : this.sourceIdentifier,
      destinationURL: _patchMap.containsKey(UIEventAttribution$.destinationURL)
          ? (_patchMap[UIEventAttribution$.destinationURL] is Function)
                ? _patchMap[UIEventAttribution$.destinationURL](
                    this.destinationURL,
                  )
                : (_patchMap[UIEventAttribution$.destinationURL] is Patch)
                ? _patchMap[UIEventAttribution$.destinationURL].applyTo(
                    this.destinationURL,
                  )
                : _patchMap[UIEventAttribution$.destinationURL]
          : this.destinationURL,
      sourceDescription:
          _patchMap.containsKey(UIEventAttribution$.sourceDescription)
          ? (_patchMap[UIEventAttribution$.sourceDescription] is Function)
                ? _patchMap[UIEventAttribution$.sourceDescription](
                    this.sourceDescription,
                  )
                : (_patchMap[UIEventAttribution$.sourceDescription] is Patch)
                ? _patchMap[UIEventAttribution$.sourceDescription].applyTo(
                    this.sourceDescription,
                  )
                : _patchMap[UIEventAttribution$.sourceDescription]
          : this.sourceDescription,
      purchaser: _patchMap.containsKey(UIEventAttribution$.purchaser)
          ? (_patchMap[UIEventAttribution$.purchaser] is Function)
                ? _patchMap[UIEventAttribution$.purchaser](this.purchaser)
                : (_patchMap[UIEventAttribution$.purchaser] is Patch)
                ? _patchMap[UIEventAttribution$.purchaser].applyTo(
                    this.purchaser,
                  )
                : _patchMap[UIEventAttribution$.purchaser]
          : this.purchaser,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UIEventAttribution &&
        sourceIdentifier == other.sourceIdentifier &&
        destinationURL == other.destinationURL &&
        sourceDescription == other.sourceDescription &&
        purchaser == other.purchaser;
  }

  @override
  int get hashCode {
    return Object.hash(
      this.sourceIdentifier,
      this.destinationURL,
      this.sourceDescription,
      this.purchaser,
    );
  }

  @override
  String toString() {
    return 'UIEventAttribution(' +
        'sourceIdentifier: ${sourceIdentifier}' +
        ', ' +
        'destinationURL: ${destinationURL}' +
        ', ' +
        'sourceDescription: ${sourceDescription}' +
        ', ' +
        'purchaser: ${purchaser})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$UIEventAttributionToJson(this);
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

extension UIEventAttributionPropertyHelpers on UIEventAttribution {
  bool get hasSourceDescription {
    return this.sourceDescription.isNotEmpty;
  }

  bool get noSourceDescription {
    return this.sourceDescription.isEmpty;
  }

  bool get hasPurchaser {
    return this.purchaser.isNotEmpty;
  }

  bool get noPurchaser {
    return this.purchaser.isEmpty;
  }
}

extension UIEventAttributionSerialization on UIEventAttribution {
  Map<String, dynamic> toJson() {
    return _$UIEventAttributionToJson(this);
  }
}

enum UIEventAttribution$ {
  sourceIdentifier,
  destinationURL,
  sourceDescription,
  purchaser,
}

class UIEventAttributionPatch
    extends PatchBase<UIEventAttribution, UIEventAttribution$> {
  UIEventAttribution applyTo(UIEventAttribution entity) {
    return entity.patchWithUIEventAttribution(this);
  }

  UIEventAttributionPatch withSourceIdentifier(int? value) {
    patchMap[UIEventAttribution$.sourceIdentifier] = value;
    return this;
  }

  UIEventAttributionPatch withDestinationURL(WebUri? value) {
    patchMap[UIEventAttribution$.destinationURL] = value;
    return this;
  }

  UIEventAttributionPatch withSourceDescription(String? value) {
    patchMap[UIEventAttribution$.sourceDescription] = value;
    return this;
  }

  UIEventAttributionPatch withPurchaser(String? value) {
    patchMap[UIEventAttribution$.purchaser] = value;
    return this;
  }
}

/// Field descriptors for [UIEventAttribution] query construction
abstract final class UIEventAttributionFields {
  static const sourceIdentifier = Field<UIEventAttribution, int>(
    'sourceIdentifier',
    _$sourceIdentifier,
  );

  static const destinationURL = Field<UIEventAttribution, WebUri>(
    'destinationURL',
    _$destinationURL,
  );

  static const sourceDescription = Field<UIEventAttribution, String>(
    'sourceDescription',
    _$sourceDescription,
  );

  static const purchaser = Field<UIEventAttribution, String>(
    'purchaser',
    _$purchaser,
  );

  static int _$sourceIdentifier(UIEventAttribution e) {
    return e.sourceIdentifier;
  }

  static WebUri _$destinationURL(UIEventAttribution e) {
    return e.destinationURL;
  }

  static String _$sourceDescription(UIEventAttribution e) {
    return e.sourceDescription;
  }

  static String _$purchaser(UIEventAttribution e) {
    return e.purchaser;
  }
}

extension UIEventAttributionCompareE on UIEventAttribution {
  Map<String, dynamic> compareToUIEventAttribution(UIEventAttribution other) {
    final Map<String, dynamic> diff = {};

    if (sourceIdentifier != other.sourceIdentifier) {
      diff['sourceIdentifier'] = () => other.sourceIdentifier;
    }

    if (destinationURL != other.destinationURL) {
      diff['destinationURL'] = () => other.destinationURL;
    }

    if (sourceDescription != other.sourceDescription) {
      diff['sourceDescription'] = () => other.sourceDescription;
    }

    if (purchaser != other.purchaser) {
      diff['purchaser'] = () => other.purchaser;
    }
    return diff;
  }
}
