// Enum-like values that cross the channel on their own (not as a field of a
// larger object).
import 'package:flutter_inappwebview_platform_interface/flutter_inappwebview_platform_interface.dart' as u;
import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart' as z;

import 'support.dart';

void main() {
  registerParityCheck();

  test('encode: every value', () {
    void enumPair<U, Z>(String type, Iterable<U> uv, Iterable<Z> zv, Object? Function(U) ue, Object? Function(Z) ze) {
      for (final x in uv) {
        final name = (x as dynamic).name() as String;
        final y = zv.where((e) => (e as Enum).name == name);
        expectSame('$type.$name', ue(x), y.isEmpty ? '<missing>' : ze(y.first));
      }
    }

    enumPair<u.MediaCaptureState, z.MediaCaptureState>('MediaCaptureState', u.MediaCaptureState.values, z.MediaCaptureState.values, (e) => e.toNativeValue(), z.mediaCaptureStateToWire);
    enumPair<u.NavigationActionPolicy, z.NavigationActionPolicy>('NavigationActionPolicy', u.NavigationActionPolicy.values, z.NavigationActionPolicy.values, (e) => e.toNativeValue(), (e) => e.index);
    enumPair<u.NavigationResponseAction, z.NavigationResponseAction>('NavigationResponseAction', u.NavigationResponseAction.values, z.NavigationResponseAction.values, (e) => e.toNativeValue(), (e) => e.index);
    enumPair<u.AjaxRequestAction, z.AjaxRequestAction>('AjaxRequestAction', u.AjaxRequestAction.values, z.AjaxRequestAction.values, (e) => e.toNativeValue(), (e) => e.index);
    enumPair<u.UserScriptInjectionTime, z.UserScriptInjectionTime>('UserScriptInjectionTime', u.UserScriptInjectionTime.values, z.UserScriptInjectionTime.values, (e) => e.toNativeValue(), (e) => e.index);
    enumPair<u.MediaPlaybackState, z.MediaPlaybackState>('MediaPlaybackState', u.MediaPlaybackState.values, z.MediaPlaybackState.values, (e) => e.toNativeValue(), z.mediaPlaybackStateToWire);
    enumPair<u.WebArchiveFormat, z.WebArchiveFormat>('WebArchiveFormat', u.WebArchiveFormat.values, z.WebArchiveFormat.values, (e) => e.toNativeValue(), z.webArchiveFormatToWire);
    enumPair<u.FetchRequestAction, z.FetchRequestAction>('FetchRequestAction', u.FetchRequestAction.values, z.FetchRequestAction.values, (e) => e.toNativeValue(), (e) => e.index);
    // WebResourceErrorType.toNativeValue(): zikzak has no wire encoding for it
    // (only the decoder, covered by 'WebResourceError.type' in decode_test.dart).
  });

  test('decode: fromNativeValue round trip', () {
    // What native sends is upstream's native value; zikzak must decode it back
    // to the value of the same name.
    void roundTrip<U>(String type, Iterable<U> uv, Object? Function(U) native, Enum? Function(Object?) decode) {
      for (final x in uv) {
        final name = (x as dynamic).name() as String;
        final n = native(x);
        final got = decode(n);
        // Compared as names so a null or renamed value shows up as a DIFF.
        expectSame('$type.fromNative.$name', name, got?.name ?? '<null for $n>');
      }
    }

    roundTrip<u.MediaCaptureState>('MediaCaptureState', u.MediaCaptureState.values, (e) => e.toNativeValue(), z.mediaCaptureStateFromWire);
    roundTrip<u.MediaPlaybackState>('MediaPlaybackState', u.MediaPlaybackState.values, (e) => e.toNativeValue(), z.mediaPlaybackStateFromWire);
    roundTrip<u.WebArchiveFormat>('WebArchiveFormat', u.WebArchiveFormat.values, (e) => e.toNativeValue(), z.webArchiveFormatFromWire);
    // CacheModel.fromNativeValue: zikzak has no CacheModel (see
    // WebViewEnvironmentSettings in knownDifferences).
  });
}
