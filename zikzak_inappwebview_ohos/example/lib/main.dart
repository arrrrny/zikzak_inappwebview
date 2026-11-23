import 'package:flutter/material.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

void main() => runApp(const MaterialApp(home: ArkWebExample()));

class ArkWebExample extends StatefulWidget {
  const ArkWebExample({super.key});
  @override
  State<ArkWebExample> createState() => _ArkWebExampleState();
}

class _ArkWebExampleState extends State<ArkWebExample> {
  late final view = PlatformInAppWebViewWidget(
    PlatformInAppWebViewWidgetCreationParams(
      initialUrlRequest: URLRequest(url: WebUri('https://example.com/')),
      initialSettings: InAppWebViewSettings(javaScriptEnabled: true),
    ),
  );
  @override
  void dispose() {
    view.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Zikzak ArkWeb')),
    body: Builder(builder: view.build),
  );
}
