import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';

import 'main.dart';

class MyInAppBrowser extends InAppBrowser {
  MyInAppBrowser(
      {super.windowId,
      super.initialUserScripts,
      super.pullToRefreshController})
      : super(
          webViewEnvironment: webViewEnvironment,
        );

  @override
  Future onBrowserCreated() async {
    debugPrint("\n\nBrowser Created!\n\n");
  }

  @override
  Future onLoadStart(WebUri? url) async {}

  @override
  Future onLoadStop(WebUri? url) async {
    pullToRefreshController?.endRefreshing();
  }

  @override
  Future<PermissionResponse> onPermissionRequest(
      PermissionRequest permissionRequest) async {
    return PermissionResponse(
        resources: permissionRequest.resources,
        action: PermissionResponseAction.GRANT);
  }

  @override
  void onReceivedError(WebResourceRequest request, WebResourceError error) {
    pullToRefreshController?.endRefreshing();
  }

  @override
  void onProgressChanged(int progress) {
    if (progress == 100) {
      pullToRefreshController?.endRefreshing();
    }
  }

  @override
  void onExit() {
    debugPrint("\n\nBrowser closed!\n\n");
  }

  @override
  Future<NavigationActionPolicy> shouldOverrideUrlLoading(
      NavigationAction navigationAction) async {
    debugPrint("\n\nOverride ${navigationAction.request.url}\n\n");
    return NavigationActionPolicy.ALLOW;
  }

  @override
  void onMainWindowWillClose() {
    close();
  }
}

class InAppBrowserExampleScreen extends StatefulWidget {
  const InAppBrowserExampleScreen({super.key});

  @override
  State<InAppBrowserExampleScreen> createState() =>
      _InAppBrowserExampleScreenState();
}

class _InAppBrowserExampleScreenState extends State<InAppBrowserExampleScreen> {
  late final MyInAppBrowser browser;

  @override
  void initState() {
    super.initState();

    PullToRefreshController? pullToRefreshController = kIsWeb ||
            ![TargetPlatform.iOS, TargetPlatform.android]
                .contains(defaultTargetPlatform)
        ? null
        : PullToRefreshController(
            settings: PullToRefreshSettings(
              color: Colors.black,
            ),
            onRefresh: () async {
              if (Platform.isAndroid) {
                browser.webViewController?.reload();
              } else if (Platform.isIOS) {
                browser.webViewController?.loadUrl(
                    urlRequest: URLRequest(
                        url: await browser.webViewController?.getUrl()));
              }
            },
          );

    browser = MyInAppBrowser(pullToRefreshController: pullToRefreshController);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text(
          "InAppBrowser",
        )),
        drawer: myDrawer(context: context),
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              ElevatedButton(
                  onPressed: () async {
                    await browser.openUrlRequest(
                      urlRequest:
                          URLRequest(url: WebUri("https://flutter.dev")),
                      settings: InAppBrowserClassSettings(
                        browserSettings: InAppBrowserSettings(
                            toolbarTopBackgroundColor: Colors.blue,
                            presentationStyle: ModalPresentationStyle.POPOVER),
                        webViewSettings: InAppWebViewSettings(
                          isInspectable: kDebugMode,
                          useShouldOverrideUrlLoading: true,
                          useOnLoadResource: true,
                        ),
                      ),
                    );
                  },
                  child: const Text("Open In-App Browser")),
              Container(height: 40),
              ElevatedButton(
                  onPressed: () async {
                    await InAppBrowser.openWithSystemBrowser(
                        url: WebUri("https://flutter.dev/"));
                  },
                  child: const Text("Open System Browser")),
            ])));
  }
}
