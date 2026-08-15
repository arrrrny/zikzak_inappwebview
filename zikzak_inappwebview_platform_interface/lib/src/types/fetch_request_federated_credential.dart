import '../web_uri.dart';
import 'fetch_request_credential.dart';

///Class that represents a [FederatedCredential](https://developer.mozilla.org/en-US/docs/Web/API/FederatedCredential) type of credentials.
///
///Hand-written (migration skip/hierarchy — see PROGRESS.md migration map):
///part of the polymorphic credential hierarchy (wire `type` dispatch), kept
///as a plain Dart class with an identical public API and wire format.
class FetchRequestFederatedCredential extends FetchRequestCredential {
  ///Credential's identifier.
  dynamic id;

  ///The name associated with a credential. It should be a human-readable, public name.
  String? name;

  ///Credential's federated identity protocol.
  String? protocol;

  ///Credential's federated identity provider.
  String? provider;

  ///URL pointing to an image for an icon. This image is intended for display in a credential chooser. The URL must be accessible without authentication.
  WebUri? iconURL;

  FetchRequestFederatedCredential({
    type,
    this.id,
    this.name,
    this.protocol,
    this.provider,
    this.iconURL,
  }) : super(type: type);

  ///Gets a possible [FetchRequestFederatedCredential] instance from a [Map] value.
  static FetchRequestFederatedCredential? fromMap(Map<String, dynamic>? map) {
    if (map == null) {
      return null;
    }
    final instance = FetchRequestFederatedCredential(
      iconURL: map['iconURL'] != null ? WebUri(map['iconURL']) : null,
      id: map['id'],
      name: map['name'],
      protocol: map['protocol'],
      provider: map['provider'],
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
      "protocol": protocol,
      "provider": provider,
    };
  }

  ///Converts instance to a map.
  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'FetchRequestFederatedCredential{type: $type, iconURL: $iconURL, id: $id, name: $name, protocol: $protocol, provider: $provider}';
  }
}
