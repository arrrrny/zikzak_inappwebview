import 'dart:core';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

import '../in_app_webview_controller.dart';

///Use [InAppWebViewController] instead.
@Deprecated("Use InAppWebViewController instead")
class IOSInAppWebViewController {
  PlatformInAppWebViewController? _controller;

  IOSInAppWebViewController({
    required PlatformInAppWebViewController controller,
  }) {
    this._controller = controller;
  }

  ///Use [InAppWebViewController.reloadFromOrigin] instead.
  @Deprecated("Use InAppWebViewController.reloadFromOrigin instead")
  Future<void> reloadFromOrigin() async {
    await _controller?.reloadFromOrigin();
  }

  ///Use [InAppWebViewController.createPdf] instead.
  @Deprecated("Use InAppWebViewController.createPdf instead")
  Future<Uint8List?> createPdf({PDFConfiguration? pdfConfiguration}) async {
    return await _controller?.createPdf(pdfConfiguration: pdfConfiguration);
  }

  ///Use [InAppWebViewController.createWebArchiveData] instead.
  @Deprecated("Use InAppWebViewController.createWebArchiveData instead")
  Future<Uint8List?> createWebArchiveData() async {
    return await _controller?.createWebArchiveData();
  }

  ///Use [InAppWebViewController.hasOnlySecureContent] instead.
  @Deprecated("Use InAppWebViewController.hasOnlySecureContent instead")
  Future<bool> hasOnlySecureContent() async {
    return await _controller?.hasOnlySecureContent() ?? false;
  }

  ///Use [InAppWebViewController.handlesURLScheme] instead.
  @Deprecated("Use InAppWebViewController.handlesURLScheme instead")
  static Future<bool> handlesURLScheme(String urlScheme) async {
    return await InAppWebViewController.handlesURLScheme(urlScheme);
  }

  void dispose() {
    _controller = null;
  }
}
