import 'fetch_request_credential.dart';

///Class that represents the default credentials used by an [FetchRequest].
///
///Hand-written (migration skip/hierarchy — see PROGRESS.md migration map):
///part of the polymorphic credential hierarchy (wire `type` dispatch), kept
///as a plain Dart class with an identical public API and wire format.
class FetchRequestCredentialDefault extends FetchRequestCredential {
  ///The value of the credentials.
  String? value;

  FetchRequestCredentialDefault({this.value, String? type}) : super(type: type);

  ///Gets a possible [FetchRequestCredentialDefault] instance from a [Map] value.
  static FetchRequestCredentialDefault? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = FetchRequestCredentialDefault(value: map['value']);
    instance.type = map['type'];
    return instance;
  }

  ///Converts instance to a map.
  Map<String, dynamic> toMap() {
    return {"type": type, "value": value};
  }

  ///Converts instance to a map.
  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'FetchRequestCredentialDefault{type: $type, value: $value}';
  }
}
