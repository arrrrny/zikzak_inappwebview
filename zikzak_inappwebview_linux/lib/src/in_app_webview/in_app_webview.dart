import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

import '../find_interaction/find_interaction_controller.dart';
import 'in_app_webview_controller.dart';

class LinuxInAppWebViewWidget extends PlatformInAppWebViewWidget {
  LinuxInAppWebViewWidget(PlatformInAppWebViewWidgetCreationParams params)
      : super.implementation(params);

  @override
  Widget build(BuildContext context) {
    return _LinuxInAppWebView(params: params);
  }

  @override
  void dispose() {
    // nothing to dispose here, the widget disposes the controller
  }

  @override
  T controllerFromPlatform<T>(PlatformInAppWebViewController controller) {
    // ignore: unnecessary_cast
    return controller as T;
  }
}

class _LinuxInAppWebView extends StatefulWidget {
  final PlatformInAppWebViewWidgetCreationParams params;

  const _LinuxInAppWebView({required this.params});

  @override
  State<_LinuxInAppWebView> createState() => _LinuxInAppWebViewState();
}

class _LinuxInAppWebViewState extends State<_LinuxInAppWebView> {
  LinuxInAppWebViewController? _controller;
  int? _textureId;
  static const MethodChannel _sharedChannel = MethodChannel('zikzak_inappwebview_linux');

  @override
  void initState() {
    super.initState();
    _createWebView();
  }

  Future<void> _createWebView() async {
    // Generate a unique ID for the webview.
    // In MacOS implementation, platform view ID is provided by the platform.
    // Here we generate it to match our custom create logic.
    var id = DateTime.now().microsecondsSinceEpoch.toString();
    
    try {
        var textureId = await _sharedChannel.invokeMethod('create', {'id': id});
        if (textureId != null && mounted) {
           setState(() {
             _textureId = textureId;
           });
           // Use the ID we generated to create the controller, as the native side used it too.
           _onPlatformViewCreated(id);
        }
    } catch(e) {
        print("Error creating webview: $e");
    }
  }

  void _onPlatformViewCreated(String id) {
    _controller = LinuxInAppWebViewController(
      PlatformInAppWebViewControllerCreationParams(id: id, webviewParams: widget.params),
    );

    if (widget.params.findInteractionController != null) {
      var findInteractionController =
          widget.params.findInteractionController as LinuxFindInteractionController;
      findInteractionController.channel = MethodChannel(
          'wtf.zikzak/zikzak_inappwebview_find_interaction_$id');
      findInteractionController.setupMethodHandler();
    }

    if (widget.params.onWebViewCreated != null) {
      widget.params.onWebViewCreated!(_controller!);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _controller = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_textureId != null) {
        return Texture(textureId: _textureId!);
    }
    // Return a placeholder or empty container
    return Container(
        color: const Color(0xFFFFFFFF),
        child: const Center(child: Text("Linux InAppWebView (Implemented via Texture/Native)"))
    );
  }
}
