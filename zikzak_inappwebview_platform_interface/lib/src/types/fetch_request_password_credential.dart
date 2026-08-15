import '../web_uri.dart';
import 'fetch_request_credential.dart';

///Class that represents a [PasswordCredential](https://developer.mozilla.org/en-US/docs/Web/API/PasswordCredential) type of credentials.
///
///Hand-written (migration skip/hierarchy — see PROGRESS.md migration map):
///part of the polymorphic credential hierarchy (wire `type` dispatch), kept
///as a plain Dart class with an identical public API and wire format.
class FetchRequestPasswordCredential extends FetchRequestCredential {
  ///Credential's identifier.
  dynamic id;

  ///The name associated with a credential. It should be a human-readable, public name.
  String? name;

  ///The password of the credential.
  String? password;

  ///URL pointing to an image for an icon. This image is intended for display in a credential chooser. The URL must be accessible without authentication.
  WebUri? iconURL;

  FetchRequestPasswordCredential({
    type,
    this.id,
    this.name,
    this.password,
    this.iconURL,
  }) : super(type: type);

  ///Gets a possible [FetchRequestPasswordCredential] instance from a [Map] value.
  static FetchRequestPasswordCredential? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = FetchRequestPasswordCredential(
      iconURL: map['iconURL'] != null ? WebUri(map['iconURL']) : null,
      id: map['id'],
      name: map['name'],
      password: map['password'],
    );
    instance.type = map['type'];
    return instance;
  }

  ///Converts instance to a map.
  Map<String, dynamic> toMap() {
    return {
      "type": type,
      "iconURL": iconURL?.toString(),
      "id": id,
      "name": name,
      "password": password,
    };
  }

  ///Converts instance to a map.
  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'FetchRequestPasswordCredential{type: $type, iconURL: $iconURL, id: $id, name: $name, password: $password}';
  }
}
