import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';

import 'package:zikzak_inappwebview_example/chrome_safari_browser_example.screen.dart';
import 'package:zikzak_inappwebview_example/headless_in_app_webview.screen.dart';
import 'package:zikzak_inappwebview_example/in_app_webiew_example.screen.dart';
import 'package:zikzak_inappwebview_example/in_app_browser_example.screen.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';

final localhostServer = InAppLocalhostServer(documentRoot: 'assets');
WebViewEnvironment? webViewEnvironment;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Permission.camera.request();
  // await Permission.microphone.request();
  // await Permission.storage.request();

  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.windows) {
    final availableVersion = await WebViewEnvironment.getAvailableVersion();
    assert(availableVersion != null,
        'Failed to find an installed WebView2 runtime or non-stable Microsoft Edge installation.');

    webViewEnvironment = await WebViewEnvironment.create(
        settings: WebViewEnvironmentSettings(userDataFolder: 'custom_path'));
  }

  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    await InAppWebViewController.setWebContentsDebuggingEnabled(kDebugMode);
  }

  runApp(const MyApp());
}

PointerInterceptor myDrawer({required BuildContext context}) {
  var children = [
    ListTile(
      title: const Text('InAppWebView'),
      onTap: () {
        Navigator.pushReplacementNamed(context, '/');
      },
    ),
    ListTile(
      title: const Text('InAppBrowser'),
      onTap: () {
        Navigator.pushReplacementNamed(context, '/InAppBrowser');
      },
    ),
    ListTile(
      title: const Text('ChromeSafariBrowser'),
      onTap: () {
        Navigator.pushReplacementNamed(context, '/ChromeSafariBrowser');
      },
    ),
    ListTile(
      title: const Text('HeadlessInAppWebView'),
      onTap: () {
        Navigator.pushReplacementNamed(context, '/HeadlessInAppWebView');
      },
    ),
  ];
  if (kIsWeb) {
    children = [
      ListTile(
        title: const Text('InAppWebView'),
        onTap: () {
          Navigator.pushReplacementNamed(context, '/');
        },
      ),
      ListTile(
        title: const Text('HeadlessInAppWebView'),
        onTap: () {
          Navigator.pushReplacementNamed(context, '/HeadlessInAppWebView');
        },
      ),
    ];
  } else if (defaultTargetPlatform == TargetPlatform.macOS) {
    children = [
      ListTile(
        title: const Text('InAppWebView'),
        onTap: () {
          Navigator.pushReplacementNamed(context, '/');
        },
      ),
      ListTile(
        title: const Text('InAppBrowser'),
        onTap: () {
          Navigator.pushReplacementNamed(context, '/InAppBrowser');
        },
      ),
      ListTile(
        title: const Text('HeadlessInAppWebView'),
        onTap: () {
          Navigator.pushReplacementNamed(context, '/HeadlessInAppWebView');
        },
      ),
    ];
  } else if (defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.linux) {
    children = [
      ListTile(
        title: const Text('InAppWebView'),
        onTap: () {
          Navigator.pushReplacementNamed(context, '/');
        },
      ),
      ListTile(
        title: const Text('InAppBrowser'),
        onTap: () {
          Navigator.pushReplacementNamed(context, '/InAppBrowser');
        },
      ),
      ListTile(
        title: const Text('HeadlessInAppWebView'),
        onTap: () {
          Navigator.pushReplacementNamed(context, '/HeadlessInAppWebView');
        },
      ),
    ];
  }
  return PointerInterceptor(
    child: Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('zikzak_inappwebview example'),
          ),
          ...children
        ],
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return MaterialApp(initialRoute: '/', routes: {
        '/': (context) => const InAppWebViewExampleScreen(),
        '/HeadlessInAppWebView': (context) =>
            const HeadlessInAppWebViewExampleScreen(),
      });
    }
    if (defaultTargetPlatform == TargetPlatform.macOS) {
      return MaterialApp(initialRoute: '/', routes: {
        '/': (context) => const InAppWebViewExampleScreen(),
        '/InAppBrowser': (context) => const InAppBrowserExampleScreen(),
        '/HeadlessInAppWebView': (context) =>
            const HeadlessInAppWebViewExampleScreen(),
      });
    } else if (defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.linux) {
      return MaterialApp(initialRoute: '/', routes: {
        '/': (context) => const InAppWebViewExampleScreen(),
        '/InAppBrowser': (context) => const InAppBrowserExampleScreen(),
        '/HeadlessInAppWebView': (context) =>
            const HeadlessInAppWebViewExampleScreen(),
      });
    }
    return MaterialApp(initialRoute: '/', routes: {
      '/': (context) => const InAppWebViewExampleScreen(),
      '/InAppBrowser': (context) => const InAppBrowserExampleScreen(),
      '/ChromeSafariBrowser': (context) => ChromeSafariBrowserExampleScreen(),
      '/HeadlessInAppWebView': (context) => const HeadlessInAppWebViewExampleScreen(),
    });
  }
}
