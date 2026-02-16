import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';

import 'main.dart';

class InAppWebViewExampleScreen extends StatefulWidget {
  const InAppWebViewExampleScreen({super.key});

  @override
  State<InAppWebViewExampleScreen> createState() =>
      _InAppWebViewExampleScreenState();
}

class _InAppWebViewExampleScreenState extends State<InAppWebViewExampleScreen> {
  var webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  InAppWebViewSettings settings = InAppWebViewSettings(
      javaScriptEnabled: true,
      domStorageEnabled: true,
      databaseEnabled: true,
      isFindInteractionEnabled: true,
      isElementFullscreenEnabled: true,
      upgradeKnownHostsToHTTPS: true);

  FindInteractionController? findInteractionController;

  PullToRefreshController? pullToRefreshController;

  late ContextMenu contextMenu;
  String url = "";
  double progress = 0;
  final urlController = TextEditingController();
  final int _windowId = 12345;

  @override
  void initState() {
    super.initState();

    findInteractionController = FindInteractionController();

    contextMenu = ContextMenu(
        menuItems: [
          ContextMenuItem(
              id: 1,
              title: "Special",
              action: () async {
                debugPrint("Menu item Special clicked!");
                debugPrint(
                    (await webViewController?.getSelectedText()).toString());
                await webViewController?.clearFocus();
              })
        ],
        settings: ContextMenuSettings(hideDefaultSystemContextMenuItems: false),
        onCreateContextMenu: (hitTestResult) async {
          debugPrint("onCreateContextMenu");
          debugPrint(hitTestResult.extra.toString());
          debugPrint((await webViewController?.getSelectedText()).toString());
        },
        onHideContextMenu: () {
          debugPrint("onHideContextMenu");
        },
        onContextMenuActionItemClicked: (contextMenuItemClicked) async {
          var id = contextMenuItemClicked.id;
          debugPrint(
              "onContextMenuActionItemClicked: $id ${contextMenuItemClicked.title}");
        });

    pullToRefreshController = kIsWeb ||
            ![TargetPlatform.iOS, TargetPlatform.android]
                .contains(defaultTargetPlatform)
        ? null
        : PullToRefreshController(
            settings: PullToRefreshSettings(
              color: Colors.blue,
            ),
            onRefresh: () async {
              if (defaultTargetPlatform == TargetPlatform.android) {
                webViewController?.reload();
              } else if (defaultTargetPlatform == TargetPlatform.iOS ||
                  defaultTargetPlatform == TargetPlatform.macOS) {
                webViewController?.loadUrl(
                    urlRequest:
                        URLRequest(url: await webViewController?.getUrl()));
              }
            },
          );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("InAppWebView"), actions: [
          IconButton(
            icon: const Icon(Icons.find_in_page),
            onPressed: () {
              findInteractionController?.presentFindNavigator();
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  var currentSettings = settings;
                  return StatefulBuilder(
                    builder: (context, setState) {
                      return AlertDialog(
                        title: const Text("Settings"),
                        content: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SwitchListTile(
                                title: const Text("Find Interaction"),
                                value:
                                    currentSettings.isFindInteractionEnabled ??
                                        false,
                                onChanged: (value) async {
                                  currentSettings.isFindInteractionEnabled =
                                      value;
                                  await webViewController?.setSettings(
                                      settings: currentSettings);
                                  setState(() {
                                    settings = currentSettings;
                                  });
                                },
                              ),
                              SwitchListTile(
                                title: const Text("Element Fullscreen"),
                                subtitle: const Text("iOS 15.4+"),
                                value: currentSettings
                                        .isElementFullscreenEnabled ??
                                    false,
                                onChanged: (value) async {
                                  currentSettings.isElementFullscreenEnabled =
                                      value;
                                  await webViewController?.setSettings(
                                      settings: currentSettings);
                                  setState(() {
                                    settings = currentSettings;
                                  });
                                },
                              ),
                              SwitchListTile(
                                title: const Text("HTTPS Only"),
                                subtitle: const Text("Requires Restart"),
                                value:
                                    currentSettings.upgradeKnownHostsToHTTPS ??
                                        false,
                                onChanged: (value) {
                                  setState(() {
                                    currentSettings.upgradeKnownHostsToHTTPS =
                                        value;
                                    settings = currentSettings;
                                  });
                                  this.setState(() {
                                    webViewKey = GlobalKey();
                                  });
                                },
                              ),
                              ListTile(
                                title: const Text("Clear All Data"),
                                onTap: () async {
                                  await WebStorageManager.instance()
                                      .deleteAllData();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Data cleared"),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("Close"),
                          )
                        ],
                      );
                    },
                  );
                },
              );
            },
          )
        ]),
        drawer: myDrawer(context: context),
        body: SafeArea(
            child: Column(children: <Widget>[
          TextField(
            decoration: const InputDecoration(prefixIcon: Icon(Icons.search)),
            controller: urlController,
            keyboardType: TextInputType.text,
            onSubmitted: (value) {
              var url = WebUri(value);
              if (url.scheme.isEmpty) {
                url = WebUri((!kIsWeb
                        ? "https://www.google.com/search?q="
                        : "https://www.bing.com/search?q=") +
                    value);
              }
              webViewController?.loadUrl(urlRequest: URLRequest(url: url));
            },
          ),
          Expanded(
            child: Stack(
              children: [
                InAppWebView(
                  key: webViewKey,
                  windowId: _windowId,
                  findInteractionController: findInteractionController,
                  webViewEnvironment: webViewEnvironment,
                  initialUrlRequest:
                      URLRequest(url: WebUri('https://flutter.dev')),
                  // initialUrlRequest:
                  // URLRequest(url: WebUri(Uri.base.toString().replaceFirst("/#/", "/") + 'page.html')),
                  // initialFile: "assets/index.html",
                  initialUserScripts: UnmodifiableListView<UserScript>([]),
                  initialSettings: settings,
                  contextMenu: contextMenu,
                  pullToRefreshController: pullToRefreshController,
                  onWebViewCreated: (controller) async {
                    webViewController = controller;
                  },
                  onLoadStart: (controller, url) async {
                    // debugPrint("Starting to load: $url");
                    if (mounted) {
                      setState(() {
                        this.url = url.toString();
                        urlController.text = this.url;
                      });
                    }
                  },
                  onPermissionRequest: (controller, request) async {
                    return PermissionResponse(
                        resources: request.resources,
                        action: PermissionResponseAction.GRANT);
                  },
                  shouldOverrideUrlLoading:
                      (controller, navigationAction) async {
                    var uri = navigationAction.request.url!;

                    if (![
                      "http",
                      "https",
                      "file",
                      "chrome",
                      "data",
                      "javascript",
                      "about"
                    ].contains(uri.scheme)) {
                      if (await canLaunchUrl(uri)) {
                        // Launch the App
                        await launchUrl(
                          uri,
                        );
                        // and cancel the request
                        return NavigationActionPolicy.CANCEL;
                      }
                    }

                    return NavigationActionPolicy.ALLOW;
                  },
                  onLoadStop: (controller, url) async {
                    pullToRefreshController?.endRefreshing();
                    debugPrint("Page loaded successfully: $url");
                    if (mounted) {
                      setState(() {
                        this.url = url.toString();
                        urlController.text = this.url;
                      });
                    }
                  },
                  onReceivedError: (controller, request, error) {
                    pullToRefreshController?.endRefreshing();
                    debugPrint("WebView Error: ${error.description}");
                    debugPrint("Error Type: ${error.type}");
                    debugPrint("Failed URL: ${request.url}");
                  },
                  onProgressChanged: (controller, progress) {
                    if (progress == 100) {
                      pullToRefreshController?.endRefreshing();
                    }
                    if (mounted) {
                      setState(() {
                        this.progress = progress / 100;
                        urlController.text = url;
                      });
                    }
                  },
                  onUpdateVisitedHistory: (controller, url, isReload) {
                    if (mounted) {
                      setState(() {
                        this.url = url.toString();
                        urlController.text = this.url;
                      });
                    }
                  },
                  onConsoleMessage: (controller, consoleMessage) {
                    debugPrint("Console: ${consoleMessage.message}");
                  },
                  onReceivedHttpError: (controller, request, errorResponse) {
                    debugPrint(
                        "HTTP Error: ${errorResponse.statusCode} - ${errorResponse.reasonPhrase}");
                    debugPrint("Failed URL: ${request.url}");
                  },
                ),
                progress < 1.0
                    ? LinearProgressIndicator(value: progress)
                    : Container(),
              ],
            ),
          ),
          OverflowBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                child: const Icon(Icons.arrow_back),
                onPressed: () {
                  webViewController?.goBack();
                },
              ),
              ElevatedButton(
                child: const Icon(Icons.arrow_forward),
                onPressed: () {
                  webViewController?.goForward();
                },
              ),
              ElevatedButton(
                child: const Icon(Icons.refresh),
                onPressed: () {
                  webViewController?.reload();
                },
              ),
              ElevatedButton(
                child: const Icon(Icons.fullscreen),
                onPressed: () {
                  webViewController?.evaluateJavascript(source: """
                  var element = document.documentElement;
                  if (element.requestFullscreen) {
                    element.requestFullscreen();
                  } else if (element.webkitRequestFullscreen) {
                    element.webkitRequestFullscreen();
                  }
                  void(0);
                  """);
                },
              ),
              ElevatedButton(
                child: const Icon(Icons.code),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      var scriptController = TextEditingController(
                          text: "console.log('Hello from World!')");
                      var worldController =
                          TextEditingController(text: "myWorld");
                      return AlertDialog(
                        title: const Text("Run in World"),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: scriptController,
                              decoration:
                                  const InputDecoration(labelText: "Script"),
                              maxLines: 3,
                            ),
                            TextField(
                              controller: worldController,
                              decoration: const InputDecoration(
                                  labelText: "World Name"),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () {
                              var script = scriptController.text;
                              var worldName = worldController.text;
                              webViewController?.evaluateJavascript(
                                source: script,
                                contentWorld:
                                    ContentWorld.world(name: worldName),
                              );
                              Navigator.of(context).pop();
                            },
                            child: const Text("Run"),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ])));
  }
}
