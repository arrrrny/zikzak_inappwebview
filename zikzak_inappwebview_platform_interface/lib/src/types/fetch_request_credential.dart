import 'fetch_request_credential_default.dart';
import 'fetch_request_federated_credential.dart';
import 'fetch_request_password_credential.dart';

///Class that is an interface for [FetchRequestCredentialDefault], [FetchRequestFederatedCredential] and [FetchRequestPasswordCredential] classes.
///
///Hand-written (migration skip/hierarchy — see PROGRESS.md migration map):
///this is a polymorphic base class whose subclasses dispatch on the wire
///`type` key, which Zorphy value objects cannot express. It is now a plain
///Dart class with an identical public API and wire format.
class FetchRequestCredential {
  ///Type of credentials.
  String? type;

  FetchRequestCredential({this.type});

  ///Gets a possible [FetchRequestCredential] instance from a [Map] value.
  static FetchRequestCredential? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = FetchRequestCredential(type: map['type']);
    return instance;
  }

  ///Converts instance to a map.
  Map<String, dynamic> toMap() {
    return {"type": type};
  }

  ///Converts instance to a map.
  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'FetchRequestCredential{type: $type}';
  }
}
