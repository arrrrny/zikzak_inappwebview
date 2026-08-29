import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

import 'src/fake_platform_controller.dart';

/// Behavioral tests for the JavaScriptController facade (spec 011, U29-U42).
///
/// Each test proves the facade forwards to the parent [InAppWebViewController]
/// and ultimately to the platform with identical arguments, via the recording
/// [FakePlatformInAppWebViewController]. (CSS methods U43-U45 are not present on
/// the JavaScriptController facade and are not covered here.)

JavaScriptHandlerCallback _echo = (args) => args;

InAppWebViewController _controller(FakePlatformInAppWebViewController fake) =>
    InAppWebViewController.fromPlatform(platform: fake);

final _userScript = UserScript(
  source: 'console.log("hi");',
  injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START,
);

void main() {
  group('JavaScriptController delegates to parent (U29-U42)', () {
    test('U29 evaluateJavascript delegates with identical args and result',
        () async {
      final fake = FakePlatformInAppWebViewController()..nextEvaluate = 7;
      final controller = _controller(fake);
      final world = ContentWorld.world(name: 'myWorld');

      final result = await controller.javaScript
          .evaluateJavascript(source: '1+1', contentWorld: world);

      expect(result, 7);
      final calls = fake.recorded('evaluateJavascript');
      expect(calls, hasLength(1));
      expect(calls.single.args['source'], '1+1');
      expect(calls.single.args['contentWorld'], world);
    });

    test('U30 callAsyncJavaScript delegates with identical args and result',
        () async {
      final result = CallAsyncJavaScriptResult(value: 'ok');
      final fake = FakePlatformInAppWebViewController()
        ..nextAsyncResult = result;
      final controller = _controller(fake);
      final args = {'x': 1};

      final got = await controller.javaScript.callAsyncJavaScript(
        functionBody: 'return x;',
        arguments: args,
      );

      expect(got, result);
      final calls = fake.recorded('callAsyncJavaScript');
      expect(calls, hasLength(1));
      expect(calls.single.args['functionBody'], 'return x;');
      expect(calls.single.args['arguments'], args);
    });

    test('U31 injectJavascriptFileFromUrl delegates with identical args',
        () async {
      final fake = FakePlatformInAppWebViewController();
      final controller = _controller(fake);
      final urlFile = WebUri('https://example.com/a.js');
      final attrs = ScriptHtmlTagAttributes(id: 'a');

      await controller.javaScript.injectJavascriptFileFromUrl(
        urlFile: urlFile,
        scriptHtmlTagAttributes: attrs,
      );

      final calls = fake.recorded('injectJavascriptFileFromUrl');
      expect(calls, hasLength(1));
      expect(calls.single.args['urlFile'], urlFile);
      expect(calls.single.args['scriptHtmlTagAttributes'], attrs);
    });

    test('U32 injectJavascriptFileFromAsset delegates with identical arg',
        () async {
      final fake = FakePlatformInAppWebViewController()..nextInjectAsset = 'out';
      final controller = _controller(fake);

      final out = await controller.javaScript
          .injectJavascriptFileFromAsset(assetFilePath: 'assets/a.js');

      expect(out, 'out');
      final calls = fake.recorded('injectJavascriptFileFromAsset');
      expect(calls, hasLength(1));
      expect(calls.single.args['assetFilePath'], 'assets/a.js');
    });

    test('U33 addJavaScriptHandler delegates with identical handler', () {
      final fake = FakePlatformInAppWebViewController();
      final controller = _controller(fake);

      controller.javaScript
          .addJavaScriptHandler(handlerName: 'h', callback: _echo);

      final calls = fake.recorded('addJavaScriptHandler');
      expect(calls, hasLength(1));
      expect(calls.single.args['handlerName'], 'h');
      expect(calls.single.args['callback'], _echo);
    });

    test('U34 removeJavaScriptHandler delegates and returns same callback',
        () async {
      final fake = FakePlatformInAppWebViewController()..nextHandler = _echo;
      final controller = _controller(fake);

      final removed = controller.javaScript.removeJavaScriptHandler(
        handlerName: 'h',
      );

      expect(removed, _echo);
      final calls = fake.recorded('removeJavaScriptHandler');
      expect(calls, hasLength(1));
      expect(calls.single.args['handlerName'], 'h');
    });

    test('U35 hasJavaScriptHandler delegates and returns same boolean',
        () async {
      final fake = FakePlatformInAppWebViewController()..nextBool = true;
      final controller = _controller(fake);

      expect(await controller.javaScript.hasJavaScriptHandler(handlerName: 'h'),
          isTrue);
      final calls = fake.recorded('hasJavaScriptHandler');
      expect(calls, hasLength(1));
      expect(calls.single.args['handlerName'], 'h');
    });

    test('U36 addUserScript delegates with identical script', () async {
      final fake = FakePlatformInAppWebViewController();
      final controller = _controller(fake);

      await controller.javaScript.addUserScript(userScript: _userScript);

      final calls = fake.recorded('addUserScript');
      expect(calls, hasLength(1));
      expect(calls.single.args['userScript'], _userScript);
    });

    test('U37 addUserScripts delegates with identical list', () async {
      final fake = FakePlatformInAppWebViewController();
      final controller = _controller(fake);
      final scripts = [_userScript];

      await controller.javaScript.addUserScripts(userScripts: scripts);

      final calls = fake.recorded('addUserScripts');
      expect(calls, hasLength(1));
      expect(calls.single.args['userScripts'], scripts);
    });

    test('U38 removeUserScript delegates and returns same boolean', () async {
      final fake = FakePlatformInAppWebViewController()..nextBool = false;
      final controller = _controller(fake);

      expect(
          await controller.javaScript.removeUserScript(userScript: _userScript),
          isFalse);
      final calls = fake.recorded('removeUserScript');
      expect(calls, hasLength(1));
      expect(calls.single.args['userScript'], _userScript);
    });

    test('U39 removeUserScripts delegates with identical list', () async {
      final fake = FakePlatformInAppWebViewController();
      final controller = _controller(fake);
      final scripts = [_userScript];

      await controller.javaScript.removeUserScripts(userScripts: scripts);

      final calls = fake.recorded('removeUserScripts');
      expect(calls, hasLength(1));
      expect(calls.single.args['userScripts'], scripts);
    });

    test('U40 removeUserScriptsByGroupName delegates with identical name',
        () async {
      final fake = FakePlatformInAppWebViewController();
      final controller = _controller(fake);

      await controller.javaScript
          .removeUserScriptsByGroupName(groupName: 'g');

      final calls = fake.recorded('removeUserScriptsByGroupName');
      expect(calls, hasLength(1));
      expect(calls.single.args['groupName'], 'g');
    });

    test('U41 removeAllUserScripts delegates to parent', () async {
      final fake = FakePlatformInAppWebViewController();
      final controller = _controller(fake);

      await controller.javaScript.removeAllUserScripts();

      expect(fake.recorded('removeAllUserScripts'), hasLength(1));
    });

    test('U42 hasUserScript delegates and returns same boolean', () async {
      final fake = FakePlatformInAppWebViewController()..nextBool = true;
      final controller = _controller(fake);

      expect(await controller.javaScript.hasUserScript(userScript: _userScript),
          isTrue);
      final calls = fake.recorded('hasUserScript');
      expect(calls, hasLength(1));
      expect(calls.single.args['userScript'], _userScript);
    });
  });
}
