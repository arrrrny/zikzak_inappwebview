#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Runs `block` synchronously and catches any NSException it throws.
/// Returns the caught NSException, or nil when the block completed normally.
///
/// #309: Swift code cannot catch Objective-C exceptions; this ObjC shim is the
/// exception boundary that lets the macOS script message handler deserialization
/// path convert a WebKit deserialization exception into a normal string error
/// instead of crashing the host process.
NSException * _Nullable ZikzakCatchException(void (^_Nonnull block)(void));

NS_ASSUME_NONNULL_END
