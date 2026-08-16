///Class that represents the constants used to specify interaction with the cached responses.
enum URLRequestCachePolicy {
  ///Use the caching logic defined in the protocol implementation, if any, for a particular URL load request.
  ///This is the default policy for URL load requests.
  USE_PROTOCOL_CACHE_POLICY,

  ///The URL load should be loaded only from the originating source.
  ///This policy specifies that no existing cache data should be used to satisfy a URL load request.
  ///
  ///**NOTE**: Always use this policy if you are making HTTP or HTTPS byte-range requests.
  RELOAD_IGNORING_LOCAL_CACHE_DATA,

  ///Use existing cache data, regardless or age or expiration date, loading from originating source only if there is no cached data.
  RETURN_CACHE_DATA_ELSE_LOAD,

  ///Use existing cache data, regardless or age or expiration date, and fail if no cached data is available.
  ///
  ///If there is no existing data in the cache corresponding to a URL load request,
  ///no attempt is made to load the data from the originating source, and the load is considered to have failed.
  ///This constant specifies a behavior that is similar to an “offline” mode.
  RETURN_CACHE_DATA_DONT_LOAD,

  ///Ignore local cache data, and instruct proxies and other intermediates to disregard their caches so far as the protocol allows.
  ///
  ///**NOTE**: Versions earlier than macOS 15, iOS 13, watchOS 6, and tvOS 13 don’t implement this constant.
  RELOAD_IGNORING_LOCAL_AND_REMOTE_CACHE_DATA,

  ///Use cache data if the origin source can validate it; otherwise, load from the origin.
  ///
  ///**NOTE**: Versions earlier than macOS 15, iOS 13, watchOS 6, and tvOS 13 don’t implement this constant.
  RELOAD_REVALIDATING_CACHE_DATA,
}
