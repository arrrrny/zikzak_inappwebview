///Class that represents the constants that specify how long the credential will be kept.
enum URLCredentialPersistence {
  ///The credential should not be stored.
  NONE,

  ///The credential should be stored only for this session
  FOR_SESSION,

  ///The credential should be stored in the keychain.
  PERMANENT,

  ///The credential should be stored permanently in the keychain,
  ///and in addition should be distributed to other devices based on the owning Apple ID.
  SYNCHRONIZABLE,
}
