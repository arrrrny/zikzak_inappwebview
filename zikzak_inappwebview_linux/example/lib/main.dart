import 'package:flutter/material.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';
import 'package:zikzak_inappwebview_linux/zikzak_inappwebview_linux.dart';

void main() {
  // Ensure the Linux implementation is registered
  LinuxInAppWebViewPlatform.registerWith();
  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Linux InAppWebView Example')),
      body: Column(
        children: [
          Expanded(
            child: Builder(
              builder: (context) {
                return LinuxInAppWebViewWidget(
                  PlatformInAppWebViewWidgetCreationParams(
                    initialUrlRequest: URLRequest(
                      url: WebUri("https://flutter.dev"),
                    ),
                    onWebViewCreated: (controller) {
                      print("WebView created");
                    },
                    onLoadStop: (controller, url) {
                      print("Page loaded: $url");
                    },
                  ),
                ).build(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
