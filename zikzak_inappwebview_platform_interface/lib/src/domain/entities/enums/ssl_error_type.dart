



///Class that represents the SSL Primary error associated to the server SSL certificate.
///Used by the [ServerTrustChallenge] class.
enum SslErrorType {
  ///The certificate is not yet valid.
  NOT_YET_VALID,
  ///The certificate has expired.
  EXPIRED,
  ///Hostname mismatch.
  IDMISMATCH,
  ///The certificate authority is not trusted.
  UNTRUSTED,
  ///The date of the certificate is invalid.
  DATE_INVALID,
  ///Indicates an invalid setting or result. A generic error occurred.
  INVALID,
  ///The user specified that the certificate should not be trusted.
  ///
  ///This value indicates that the user explicitly chose to not trust a certificate in the chain,
  ///usually by clicking the appropriate button in a certificate trust panel.
  ///Your app should not trust the chain.
  ///The Keychain Access utility refers to this value as "Never Trust."
  DENY,
  ///Indicates the evaluation succeeded and the certificate is implicitly trusted, but user intent was not explicitly specified.
  ///
  ///This value indicates that evaluation reached an (implicitly trusted) anchor certificate without any evaluation failures,
  ///but never encountered any explicitly stated user-trust preference.
  ///This is the most common return value.
  ///The Keychain Access utility refers to this value as the “Use System Policy,” which is the default user setting.
  ///
  ///When receiving this value, most apps should trust the chain.
  UNSPECIFIED,
  ///Trust is denied, but recovery may be possible.
  ///
  ///This value indicates that you should not trust the chain as is,
  ///but that the chain could be trusted with some minor change to the evaluation context,
  ///such as ignoring expired certificates or adding another anchor to the set of trusted anchors.
  ///
  ///The way you handle this depends on the situation.
  ///For example, if you are performing signature validation and you know when the message was originally received,
  ///you should check again using that date to see if the message was valid when you originally received it.
  RECOVERABLE_TRUST_FAILURE,
  ///Trust is denied and no simple fix is available.
  ///
  ///This value indicates that evaluation failed because a certificate in the chain is defective.
  ///This usually represents a fundamental defect in the certificate data, such as an invalid encoding for a critical subjectAltName extension,
  ///an unsupported critical extension, or some other critical portion of the certificate that couldn’t be interpreted.
  ///Changing parameter values and reevaluating is unlikely to succeed unless you provide different certificates.
  FATAL_TRUST_FAILURE,
  ///Indicates a failure other than that of trust evaluation.
  ///
  ///This value indicates that evaluation failed for some other reason.
  ///This can be caused by either a revoked certificate or by OS-level errors that are unrelated to the certificates themselves.
  OTHER_ERROR,
}
