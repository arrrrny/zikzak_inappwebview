# Bug Issue: Failed to handle method call  java.lang.ClassCastException: java.lang.String cannot be cast to java.lang.Integer

- **Slug**: classcastexception-string-integer
- **Fetched**: 2026-08-22T21:09:19
- **Issue**: 245
- **URL**: https://github.com/arrrrny/zikzak_inappwebview/issues/245
- **State**: open
- **Severity**: unknown
- **Author**: arontest2023-glitch
- **Labels**: none

## Body

Failed to handle method call
java.lang.ClassCastException: java.lang.String cannot be cast to java.lang.Integer                                                                                                    	at wtf.zikzak.zikzak_inappwebview_android.webview.in_app_webview.InAppWebViewSettings.parse(InAppWebViewSettings.java:332)

## Comments

**KohlsAdrian** (2026-08-19T21:48:48Z):

```bash
PlatformException(error, java.lang.String cannot be cast to java.lang.Integer, null, java.lang.ClassCastException: java.lang.String cannot be cast to java.lang.Integer
	at wtf.zikzak.zikzak_inappwebview_android.webview.in_app_webview.InAppWebViewSettings.parse(InAppWebViewSettings.java:332)
	at wtf.zikzak.zikzak_inappwebview_android.webview.in_app_webview.FlutterWebView.<init>(FlutterWebView.java:57)
	at wtf.zikzak.zikzak_inappwebview_android.webview.FlutterWebViewFactory.create(FlutterWebViewFactory.java:67)
	at io.flutter.plugin.platform.PlatformViewsController.createPlatformView(PlatformViewsController.java:535)
	at io.flutter.plugin.platform.PlatformViewsController$1.createForPlatformViewLayer(PlatformViewsController.java:172)
	at io.flutter.plugin.platform.PlatformViewsControllerDelegator.createForPlatformViewLayer(PlatformViewsControllerDelegator.java:128)
	at io.flutter.embedding.engine.systemchannels.PlatformViewsChannel$1.create(PlatformViewsChannel.java:115)
	at io.flutter.embedding.engine.systemch
{navigatorManager: WebviewAuth, fcm: fzCGDHwjQOWy3ZHu7_F-P0:APA91bEiI7fO_4FlVdC2ckqNuE5a2CipugR_B3FLJKZEsCzU2URFk1-pmB7MVv7ESrRkAZQH42dfv-gzsDyd6mnhW39q9_Qk3lS9XbWTZ4cZp4Xn1ExTJP4}
#0      StandardMethodCodec.decodeEnvelope (package:flutter/src/services/message_codecs.dart:653:7)
#1      MethodChannel._invokeMethod (package:flutter/src/services/platform_channel.dart:366:18)
<asynchronous suspension>
#2      ExpensiveAndroidViewController._sendCreateMessage (package:flutter/src/services/platform_views.dart:1140:5)
<asynchronous suspension>
#3      AndroidViewController.create (package:flutter/src/services/platform_views.dart:864:5)
<asynchronous suspension>
```

**KohlsAdrian** (2026-08-19T22:05:15Z):

https://github.com/arrrrny/zikzak_inappwebview/pull/246
