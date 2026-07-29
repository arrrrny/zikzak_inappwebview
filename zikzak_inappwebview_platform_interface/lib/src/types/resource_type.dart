///The type of a captured network resource.
///
///Used by the Network Capture API to classify intercepted requests.
///
///**NOTE**: with the default JavaScript-injection-based capture engine,
///only [ResourceType.xhr] and [ResourceType.fetch] requests can be observed.
///The other values exist for forward compatibility with capture engines
///that can observe subresource loads (e.g. a CDP-based engine).
class ResourceType {
  final String _value;
  final String _nativeValue;
  const ResourceType._internal(this._value, this._nativeValue);

  ///`XMLHttpRequest` call.
  static const xhr = ResourceType._internal('xhr', 'xhr');

  ///`fetch()` call.
  static const fetch = ResourceType._internal('fetch', 'fetch');

  ///Main frame or sub-frame document navigation.
  static const document = ResourceType._internal('document', 'document');

  ///`<script>` resource.
  static const script = ResourceType._internal('script', 'script');

  ///Stylesheet resource.
  static const stylesheet = ResourceType._internal('stylesheet', 'stylesheet');

  ///Image resource.
  static const image = ResourceType._internal('image', 'image');

  ///Font resource.
  static const font = ResourceType._internal('font', 'font');

  ///Audio/video resource.
  static const media = ResourceType._internal('media', 'media');

  ///Any other resource type.
  static const other = ResourceType._internal('other', 'other');

  ///Set of all values of [ResourceType].
  static final Set<ResourceType> values = [
    ResourceType.xhr,
    ResourceType.fetch,
    ResourceType.document,
    ResourceType.script,
    ResourceType.stylesheet,
    ResourceType.image,
    ResourceType.font,
    ResourceType.media,
    ResourceType.other,
  ].toSet();

  ///Gets a possible [ResourceType] instance from [String] value.
  static ResourceType? fromValue(String? value) {
    if (value != null) {
      try {
        return ResourceType.values.firstWhere(
          (element) => element.toValue() == value,
        );
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  ///Gets a possible [ResourceType] instance from a native value.
  static ResourceType? fromNativeValue(String? value) => fromValue(value);

  ///Gets [String] value.
  String toValue() => _value;

  ///Gets [String] native value.
  String toNativeValue() => _nativeValue;

  @override
  int get hashCode => _value.hashCode;

  @override
  bool operator ==(value) => value == _value;

  @override
  String toString() => _value;
}
