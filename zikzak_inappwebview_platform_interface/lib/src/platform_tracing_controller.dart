import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'inappwebview_platform.dart';
import 'domain/entities/enums/tracing_mode.dart';
import 'domain/entities/tracing_settings/tracing_settings.dart';
import 'types/main.dart';
import 'types/disposable.dart';


/// Object specifying creation parameters for creating a [PlatformTracingController].
///
/// Platform specific implementations can add additional fields by extending
/// this class.
@immutable
class PlatformTracingControllerCreationParams {
  /// Used by the platform implementation to create a new [PlatformTracingController].
  const PlatformTracingControllerCreationParams();
}

///{@template zikzak_inappwebview_platform_interface.PlatformTracingController}
///Manages tracing of `WebView`s.
///In particular provides functionality for the app to enable/disable tracing of parts of code and to collect tracing data.
///This is useful for profiling performance issues, debugging and memory usage analysis in production and real life scenarios.
///
///The resulting trace data is sent back as a byte sequence in json format.
///This file can be loaded in "chrome://tracing" for further analysis.
///
///**Officially Supported Platforms/Implementations**:
///- Android native WebView ([Official API - TracingController](https://developer.android.com/reference/androidx/webkit/TracingController))
///{@endtemplate}
abstract class PlatformTracingController extends PlatformInterface
    implements Disposable {
  /// Creates a new [PlatformTracingController]
  factory PlatformTracingController(
    PlatformTracingControllerCreationParams params,
  ) {
    assert(
      InAppWebViewPlatform.instance != null,
      'A platform implementation for `zikzak_inappwebview` has not been set. Please '
      'ensure that an implementation of `InAppWebViewPlatform` has been set to '
      '`WebViewPlatform.instance` before use. For unit testing, '
      '`WebViewPlatform.instance` can be set with your own test implementation.',
    );
    final PlatformTracingController tracingController = InAppWebViewPlatform
        .instance!
        .createPlatformTracingController(params);
    PlatformInterface.verify(tracingController, _token);
    return tracingController;
  }

  /// Used by the platform implementation to create a new
  /// [PlatformTracingController].
  ///
  /// Should only be used by platform implementations because they can't extend
  /// a class that only contains a factory constructor.
  @protected
  PlatformTracingController.implementation(this.params) : super(token: _token);

  static final Object _token = Object();

  /// The parameters used to initialize the [PlatformTracingController].
  final PlatformTracingControllerCreationParams params;

  ///{@template zikzak_inappwebview_platform_interface.PlatformTracingController.start}
  ///Starts tracing all `WebView`s.
  ///Depending on the trace mode in trace config specifies how the trace events are recorded.
  ///For tracing modes [TracingMode.RECORD_UNTIL_FULL] and [TracingMode.RECORD_CONTINUOUSLY]
  ///the events are recorded using an internal buffer and flushed to the outputStream
  ///when [stop] is called.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView ([Official API - TracingController.start](https://developer.android.com/reference/android/webkit/TracingController#start(android.webkit.TracingConfig)))
  ///{@endtemplate}
  Future<void> start({required TracingSettings settings}) {
    throw UnimplementedError(
      'start is not implemented on the current platform',
    );
  }

  ///{@template zikzak_inappwebview_platform_interface.PlatformTracingController.stop}
  ///Stops tracing and flushes tracing data to the specified output stream.
  ///The data is sent to the specified output stream in json format typically in
  ///chunks.
  ///
  ///Returns `false` if the WebView framework was not tracing at the time of the call,
  ///`true` otherwise.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView ([Official API - TracingController.stop](https://developer.android.com/reference/android/webkit/TracingController#stop(java.io.OutputStream,%20java.util.concurrent.Executor)))
  ///{@endtemplate}
  Future<bool> stop({String? filePath}) {
    throw UnimplementedError('stop is not implemented on the current platform');
  }

  ///{@template zikzak_inappwebview_platform_interface.PlatformTracingController.isTracing}
  ///Returns whether the WebView framework is tracing.
  ///
  ///**Officially Supported Platforms/Implementations**:
  ///- Android native WebView ([Official API - TracingController.isTracing](https://developer.android.com/reference/android/webkit/TracingController#isTracing()))
  ///{@endtemplate}
  Future<bool> isTracing() {
    throw UnimplementedError(
      'isTracing is not implemented on the current platform',
    );
  }
}
