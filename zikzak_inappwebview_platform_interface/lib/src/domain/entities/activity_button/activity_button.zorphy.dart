// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'activity_button.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class ActivityButton {
  ActivityButton({
    required UIImage this.templateImage,
    required String this.extensionIdentifier,
  });

  factory ActivityButton.fromJson(Map<String, dynamic> json) =>
      _$ActivityButtonFromJson(json);

  @JsonKey(toJson: _templateImageToJson, fromJson: _templateImageFromJson)
  final UIImage templateImage;

  final String extensionIdentifier;

  ActivityButton copyWith({
    UIImage? templateImage,
    String? extensionIdentifier,
  }) {
    return ActivityButton(
      templateImage: templateImage ?? this.templateImage,
      extensionIdentifier: extensionIdentifier ?? this.extensionIdentifier,
    );
  }

  ActivityButton copyWithActivityButton({
    UIImage? templateImage,
    String? extensionIdentifier,
  }) {
    return copyWith(
      templateImage: templateImage,
      extensionIdentifier: extensionIdentifier,
    );
  }

  ActivityButton patchWithActivityButton([ActivityButtonPatch? patchInput]) {
    final _patcher = patchInput ?? ActivityButtonPatch();
    final _patchMap = _patcher.patchMap;
    return ActivityButton(
      templateImage: _patchMap.containsKey(ActivityButton$.templateImage)
          ? ((_patchMap[ActivityButton$.templateImage] is Function)
                    ? _patchMap[ActivityButton$.templateImage](
                        this.templateImage,
                      )
                    : (_patchMap[ActivityButton$.templateImage] is Patch)
                    ? _patchMap[ActivityButton$.templateImage].applyTo(
                        this.templateImage,
                      )
                    : _patchMap[ActivityButton$.templateImage])
                as UIImage
          : this.templateImage,
      extensionIdentifier:
          _patchMap.containsKey(ActivityButton$.extensionIdentifier)
          ? ((_patchMap[ActivityButton$.extensionIdentifier] is Function)
                    ? _patchMap[ActivityButton$.extensionIdentifier](
                        this.extensionIdentifier,
                      )
                    : (_patchMap[ActivityButton$.extensionIdentifier] is Patch)
                    ? _patchMap[ActivityButton$.extensionIdentifier].applyTo(
                        this.extensionIdentifier,
                      )
                    : _patchMap[ActivityButton$.extensionIdentifier])
                as String
          : this.extensionIdentifier,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ActivityButton &&
        templateImage == other.templateImage &&
        extensionIdentifier == other.extensionIdentifier;
  }

  @override
  int get hashCode {
    return Object.hash(this.templateImage, this.extensionIdentifier);
  }

  @override
  String toString() {
    return 'ActivityButton(' +
        'templateImage: ${templateImage}' +
        ', ' +
        'extensionIdentifier: ${extensionIdentifier})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$ActivityButtonToJson(this);
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

extension ActivityButtonPropertyHelpers on ActivityButton {
  bool get hasExtensionIdentifier {
    return this.extensionIdentifier.isNotEmpty;
  }

  bool get noExtensionIdentifier {
    return this.extensionIdentifier.isEmpty;
  }
}

extension ActivityButtonSerialization on ActivityButton {
  Map<String, dynamic> toJson() {
    return _$ActivityButtonToJson(this);
  }
}

enum ActivityButton$ { templateImage, extensionIdentifier }

class ActivityButtonPatch extends PatchBase<ActivityButton, ActivityButton$> {
  ActivityButton applyTo(ActivityButton entity) {
    return entity.patchWithActivityButton(this);
  }

  ActivityButtonPatch withTemplateImage(UIImage? value) {
    patchMap[ActivityButton$.templateImage] = value;
    return this;
  }

  ActivityButtonPatch withTemplateImagePatch(UIImagePatch patch) {
    patchMap[ActivityButton$.templateImage] = patch;
    return this;
  }

  ActivityButtonPatch withTemplateImagePatchFunc(
    UIImagePatch Function(UIImagePatch) patch,
  ) {
    patchMap[ActivityButton$.templateImage] = (dynamic current) {
      var currentPatch = UIImagePatch();
      return patch(currentPatch).applyTo(current as UIImage);
    };
    return this;
  }

  ActivityButtonPatch withExtensionIdentifier(String? value) {
    patchMap[ActivityButton$.extensionIdentifier] = value;
    return this;
  }
}

/// Field descriptors for [ActivityButton] query construction
abstract final class ActivityButtonFields {
  static const templateImage = Field<ActivityButton, UIImage>(
    'templateImage',
    _$templateImage,
  );

  static const extensionIdentifier = Field<ActivityButton, String>(
    'extensionIdentifier',
    _$extensionIdentifier,
  );

  static UIImage _$templateImage(ActivityButton e) {
    return e.templateImage;
  }

  static String _$extensionIdentifier(ActivityButton e) {
    return e.extensionIdentifier;
  }
}

extension ActivityButtonCompareE on ActivityButton {
  Map<String, dynamic> compareToActivityButton(ActivityButton other) {
    final Map<String, dynamic> diff = {};

    if (templateImage != other.templateImage) {
      diff['templateImage'] = () => other.templateImage;
    }

    if (extensionIdentifier != other.extensionIdentifier) {
      diff['extensionIdentifier'] = () => other.extensionIdentifier;
    }
    return diff;
  }
}
