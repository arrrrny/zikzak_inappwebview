#import "include/ZikzakExceptionCatcher.h"

NSException * _Nullable ZikzakCatchException(void (^_Nonnull block)(void)) {
    @try {
        block();
        return nil;
    }
    @catch (NSException *exception) {
        return exception;
    }
}
