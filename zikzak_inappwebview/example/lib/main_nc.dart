import 'dart:async';
import 'package:flutter/material.dart';
import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';

void main() {
  print('NC_SMOKE: app start');
  runApp(MaterialApp(
    home: Scaffold(
      body: InAppWebView(
        onWebViewCreated: (c) async {
          print('NC_SMOKE: webview created');
          await Future.delayed(const Duration(seconds: 1));
          try {
            await c.loadData(
                data:
                    '<html><body><script>console.log("NC_SMOKE_JS_RAN");</script>hi</body></html>');
            print('NC_SMOKE: loadData called');
          } catch (e) {
            print('NC_SMOKE: loadData err $e');
          }
          Timer.periodic(const Duration(seconds: 5), (t) async {
            try {
              final url = await c.getUrl();
              final r = await c.evaluateJavascript(source: '2+2');
              final len = await c.evaluateJavascript(
                  source: 'document.documentElement.outerHTML.length');
              print('NC_SMOKE: tick=${t.tick} url=$url js=$r htmllen=$len');
              if (t.tick >= 4) t.cancel();
            } catch (e) {
              print('NC_SMOKE: poll err $e');
            }
          });
        },
        onLoadStop: (c, u) => print('NC_SMOKE: load stop $u'),
        onConsoleMessage: (c, m) => print('NC_SMOKE console: ${m.message}'),
      ),
    ),
  ));
}
