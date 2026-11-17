// Source-contract tests for the Linux frame path (issue #442).
//
// The visible Linux view showed nothing while the page itself was alive: the
// WPE frame was kept as an EGL image, the texture bound it without checking
// that the import worked, and the CPU pixel buffer was never filled — so
// neither the zero-copy path nor the fallback had anything to draw.
//
// The decision the buffer callbacks follow is unit-tested in C++
// (`linux/test/render_path_test.cc`). What is asserted here is the wiring
// around it, which needs a GL context and a WPE display to exercise for
// real: the texture verifies the import before it accepts a frame, and the
// two textures that sample pixels ask the webview to fill the pixel buffer.
// Read as text; the native build proves compilation.

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// The sources with every whitespace run removed, so a contract can be written
/// as the code it looks for rather than as the line breaks it happens to have.
String _compact(String path) =>
    File(path).readAsStringSync().replaceAll(RegExp(r'\s+'), '');

void main() {
  group('Linux frame path contract (#442)', () {
    test('the EGL texture verifies the import before accepting the image', () {
      final source = _compact(
        'linux/in_app_webview/inappwebview_egl_texture.cc',
      );

      expect(
        source,
        contains('constGLenumerror=glGetError();'),
        reason: 'a rejected EGL import must be read from the GL error queue',
      );
      expect(
        source,
        contains(
          'glGetTexLevelParameteriv(GL_TEXTURE_2D,0,GL_TEXTURE_WIDTH,&width);',
        ),
        reason:
            'an import the driver accepts without storing anything must be '
            'caught by an empty texture',
      );
      expect(
        source,
        contains('if(bound){'),
        reason: 'the frame is only accepted once the import is verified',
      );
    });

    test('a rejected import latches zero-copy off and asks for pixels', () {
      final source = _compact(
        'linux/in_app_webview/inappwebview_egl_texture.cc',
      );

      final disable = source.indexOf('staticvoiddisable_zero_copy(');
      expect(disable, isNonNegative, reason: 'the fallback must be reachable');

      final body = source.substring(disable);
      expect(
        body,
        contains('self->zero_copy_disabled=TRUE;'),
        reason: 'zero-copy must be latched off so the next frame skips it',
      );
      expect(
        body,
        contains('self->webview->SetPixelReadbackRequired(true);'),
        reason:
            'the pixel path needs the CPU copy, which the buffer callbacks '
            'only fill while pixel readback is required',
      );
      expect(
        source,
        contains('disable_zero_copy(self,"EGLimagerejectedbytheGLcontext");'),
        reason: 'the failed import must fall through to the pixel path',
      );
      expect(
        source,
        contains('ZIKZAK_INAPPWEBVIEW_LINUX_DISABLE_ZERO_COPY'),
        reason: 'the env override must start on the pixel path from frame one',
      );
    });

    test('the pixel-buffer texture asks the webview for pixels', () {
      final source = _compact('linux/in_app_webview/custom_platform_view.cc');

      expect(
        source,
        contains('webview_->SetPixelReadbackRequired(true);'),
        reason:
            'the pixel-buffer texture cannot read a DMA-BUF frame itself, so '
            'the buffer callbacks must hand it the CPU copy',
      );
      expect(
        source.contains('SetSkipPixelReadback'),
        isFalse,
        reason: 'the old skip flag would leave the pixel buffer empty again',
      );
    });

    test('the headless manager parses initialUserScripts', () {
      final source = _compact(
        'linux/headless_in_app_webview/headless_in_app_webview_manager.cc',
      );

      expect(
        source,
        contains('get_fl_map_value_raw(params,"initialUserScripts")'),
        reason: 'the Dart side sends initialUserScripts in the params map',
      );
      expect(
        source,
        contains('webviewParams.initialUserScripts.push_back('),
        reason: 'the scripts must reach the InAppWebView that injects them',
      );
    });
  });
}
