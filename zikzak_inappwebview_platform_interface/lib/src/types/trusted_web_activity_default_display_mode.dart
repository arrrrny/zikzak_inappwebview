import 'package:zorphy_annotation/zorphy_annotation.dart';

import '../domain/entities/trusted_web_activity_display_mode/trusted_web_activity_display_mode.dart';

///Class that represents the default display mode of a Trusted Web Activity.
///The system UI (status bar, navigation bar) is shown, and the browser toolbar is hidden while the user is on a verified origin.
///
///Hand-written (migration skip/fork — the concrete display-mode classes are
///polymorphic subtypes of the Zorphy [TrustedWebActivityDisplayMode] base;
///Zorphy value objects cannot implement each other).
class TrustedWebActivityDefaultDisplayMode
    implements TrustedWebActivityDisplayMode {
  static final _type = "DEFAULT_MODE";

  TrustedWebActivityDefaultDisplayMode();

  Map<String, dynamic> _toMapMergeWith() {
    return {"type": _type};
  }

  ///Converts instance to a map.
  Map<String, dynamic> toMap() {
    return {..._toMapMergeWith()};
  }

  ///Converts instance to a map.
  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  TrustedWebActivityDefaultDisplayMode copyWith() {
    return TrustedWebActivityDefaultDisplayMode();
  }

  @override
  TrustedWebActivityDefaultDisplayMode copyWithTrustedWebActivityDisplayMode() {
    return copyWith();
  }

  /// Returns a copy of this entity with [field] set to [value].
  ///
  /// Required by the Zorphy [TrustedWebActivityDisplayMode] contract, which
  /// every implementation of the interface must satisfy. The default display
  /// mode carries no fields, so every [field] name is rejected — the same
  /// shape the generated base uses for a fieldless value object.
  @override
  TrustedWebActivityDefaultDisplayMode copyWithField<T>(
    Field<TrustedWebActivityDisplayMode, T> field,
    T value,
  ) {
    throw ArgumentError.value(
      field.name,
      'field',
      'TrustedWebActivityDefaultDisplayMode has no settable fields',
    );
  }

  @override
  Map<String, dynamic> toJsonLean() {
    return toMap();
  }

  @override
  String toString() {
    return 'TrustedWebActivityDefaultDisplayMode{}';
  }
}
