import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';

import 'main.dart';

class HeadlessInAppWebViewExampleScreen extends StatefulWidget {
  const HeadlessInAppWebViewExampleScreen({super.key});

  @override
  State<HeadlessInAppWebViewExampleScreen> createState() =>
      _HeadlessInAppWebViewExampleScreenState();
}

class _HeadlessInAppWebViewExampleScreenState
    extends State<HeadlessInAppWebViewExampleScreen> {
  HeadlessInAppWebView? headlessWebView;
  String url = "";
  String htmlResult = "";

  @override
  void initState() {
    super.initState();

    headlessWebView = HeadlessInAppWebView(
      webViewEnvironment: webViewEnvironment,
      initialUrlRequest:
          kIsWeb ? null : URLRequest(url: WebUri("https://flutter.dev")),
      initialData: kIsWeb
          ? InAppWebViewInitialData(
              data:
                  '<html><head><title>Test</title></head><body><h1>Hello from getHtml test</h1></body></html>')
          : null,
      initialSettings: InAppWebViewSettings(
        isInspectable: kDebugMode,
      ),
      onWebViewCreated: (controller) {
        debugPrint('HeadlessInAppWebView created!');
      },
      onConsoleMessage: (controller, consoleMessage) {
        debugPrint("CONSOLE MESSAGE: ${consoleMessage.message}");
      },
      onLoadStart: (controller, url) async {
        setState(() {
          this.url = url.toString();
        });
      },
      onLoadStop: (controller, url) async {
        setState(() {
          this.url = url.toString();
        });
      },
      onUpdateVisitedHistory: (controller, url, isReload) {
        setState(() {
          this.url = url.toString();
        });
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    headlessWebView?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text(
          "HeadlessInAppWebView",
        )),
        drawer: myDrawer(context: context),
        body: SafeArea(
            child: Column(children: <Widget>[
          Container(
            padding: const EdgeInsets.all(20.0),
            child: Text(
                "CURRENT URL\n${(url.length > 50) ? "${url.substring(0, 50)}..." : url}"),
          ),
          Center(
            child: ElevatedButton(
                onPressed: () async {
                  await headlessWebView?.dispose();
                  await headlessWebView?.run();
                },
                child: const Text("Run HeadlessInAppWebView")),
          ),
          Container(
            height: 10,
          ),
          Center(
            child: ElevatedButton(
                onPressed: () async {
                  if (headlessWebView?.isRunning() ?? false) {
                    await headlessWebView?.webViewController
                        ?.evaluateJavascript(
                            source: """console.log('Here is the message!');""");
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                          'HeadlessInAppWebView is not running. Click on "Run HeadlessInAppWebView"!'),
                    ));
                  }
                },
                child: const Text("Send console.log message")),
          ),
          Container(
            height: 10,
          ),
          Center(
            child: ElevatedButton(
                onPressed: () {
                  headlessWebView?.dispose();
                  setState(() {
                    url = "";
                    htmlResult = "";
                  });
                },
                child: const Text("Dispose HeadlessInAppWebView")),
          ),
          Container(height: 10),
          Center(
            child: ElevatedButton(
                onPressed: () async {
                  if (headlessWebView?.isRunning() ?? false) {
                    final html =
                        await headlessWebView?.webViewController?.getHtml();
                    setState(() {
                      htmlResult = html ?? 'null (getHtml returned null)';
                    });
                    debugPrint('getHtml result: $html');
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                          'HeadlessInAppWebView is not running. Click on "Run HeadlessInAppWebView"!'),
                    ));
                  }
                },
                child: const Text("Test getHtml()")),
          ),
          if (htmlResult.isNotEmpty) ...[
            Container(height: 10),
            Container(
              padding: const EdgeInsets.all(10.0),
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                color: htmlResult.contains('<html')
                    ? Colors.green.shade50
                    : Colors.red.shade50,
                border: Border.all(
                  color:
                      htmlResult.contains('<html') ? Colors.green : Colors.red,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    htmlResult.contains('<html')
                        ? '✅ getHtml() SUCCESS'
                        : '❌ getHtml() FAILED',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: htmlResult.contains('<html')
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    htmlResult.length > 500
                        ? '${htmlResult.substring(0, 500)}...'
                        : htmlResult,
                    style:
                        const TextStyle(fontSize: 12, fontFamily: 'monospace'),
                  ),
                ],
              ),
            ),
          ],
        ])));
  }
}
