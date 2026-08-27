// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'context_menu_settings.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class ContextMenuSettings {
  ContextMenuSettings({bool? hideDefaultSystemContextMenuItems})
    : this.hideDefaultSystemContextMenuItems =
          hideDefaultSystemContextMenuItems ?? false;

  factory ContextMenuSettings.fromJson(Map<String, dynamic> json) =>
      _$ContextMenuSettingsFromJson(json);

  @JsonKey(defaultValue: false)
  final bool hideDefaultSystemContextMenuItems;

  ContextMenuSettings copyWith({bool? hideDefaultSystemContextMenuItems}) {
    return ContextMenuSettings(
      hideDefaultSystemContextMenuItems:
          hideDefaultSystemContextMenuItems ??
          this.hideDefaultSystemContextMenuItems,
    );
  }

  ContextMenuSettings copyWithContextMenuSettings({
    bool? hideDefaultSystemContextMenuItems,
  }) {
    return copyWith(
      hideDefaultSystemContextMenuItems: hideDefaultSystemContextMenuItems,
    );
  }

  ContextMenuSettings patchWithContextMenuSettings([
    ContextMenuSettingsPatch? patchInput,
  ]) {
    final _patcher = patchInput ?? ContextMenuSettingsPatch();
    final _patchMap = _patcher.patchMap;
    return ContextMenuSettings(
      hideDefaultSystemContextMenuItems:
          _patchMap.containsKey(
            ContextMenuSettings$.hideDefaultSystemContextMenuItems,
          )
          ? (_patchMap[ContextMenuSettings$.hideDefaultSystemContextMenuItems]
                    is Function)
                ? _patchMap[ContextMenuSettings$
                      .hideDefaultSystemContextMenuItems](
                    this.hideDefaultSystemContextMenuItems,
                  )
                : (_patchMap[ContextMenuSettings$
                          .hideDefaultSystemContextMenuItems]
                      is Patch)
                ? _patchMap[ContextMenuSettings$
                          .hideDefaultSystemContextMenuItems]
                      .applyTo(this.hideDefaultSystemContextMenuItems)
                : _patchMap[ContextMenuSettings$
                      .hideDefaultSystemContextMenuItems]
          : this.hideDefaultSystemContextMenuItems,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ContextMenuSettings &&
        hideDefaultSystemContextMenuItems ==
            other.hideDefaultSystemContextMenuItems;
  }

  @override
  int get hashCode {
    return Object.hash(hideDefaultSystemContextMenuItems, 0);
  }

  @override
  String toString() {
    return 'ContextMenuSettings(' +
        'hideDefaultSystemContextMenuItems: ${hideDefaultSystemContextMenuItems})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$ContextMenuSettingsToJson(this);
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

extension ContextMenuSettingsPropertyHelpers on ContextMenuSettings {}

extension ContextMenuSettingsSerialization on ContextMenuSettings {
  Map<String, dynamic> toJson() {
    return _$ContextMenuSettingsToJson(this);
  }
}

enum ContextMenuSettings$ { hideDefaultSystemContextMenuItems }

class ContextMenuSettingsPatch
    extends PatchBase<ContextMenuSettings, ContextMenuSettings$> {
  ContextMenuSettings applyTo(ContextMenuSettings entity) {
    return entity.patchWithContextMenuSettings(this);
  }

  ContextMenuSettingsPatch withHideDefaultSystemContextMenuItems(bool? value) {
    patchMap[ContextMenuSettings$.hideDefaultSystemContextMenuItems] = value;
    return this;
  }
}

/// Field descriptors for [ContextMenuSettings] query construction
abstract final class ContextMenuSettingsFields {
  static const hideDefaultSystemContextMenuItems =
      Field<ContextMenuSettings, bool>(
        'hideDefaultSystemContextMenuItems',
        _$hideDefaultSystemContextMenuItems,
      );

  static bool _$hideDefaultSystemContextMenuItems(ContextMenuSettings e) {
    return e.hideDefaultSystemContextMenuItems;
  }
}

extension ContextMenuSettingsCompareE on ContextMenuSettings {
  Map<String, dynamic> compareToContextMenuSettings(ContextMenuSettings other) {
    final Map<String, dynamic> diff = {};

    if (hideDefaultSystemContextMenuItems !=
        other.hideDefaultSystemContextMenuItems) {
      diff['hideDefaultSystemContextMenuItems'] = () =>
          other.hideDefaultSystemContextMenuItems;
    }
    return diff;
  }
}
