// Public-API regression tests for misc Zorphy valueObjects not covered by the
// other type tests: loaded_resource, in_app_webview_hit_test_result,
// in_app_webview_initial_data, screenshot_configuration, find_session,
// request_focus_node_href_result, request_image_ref_result, prewarming_token,
// webview_package_info, window_features, url_response, download_start_request,
// custom_scheme_response, website_data_record.
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

void main() {
  group('LoadedResource', () {
    test('wire + round-trip', () {
      final r = LoadedResource(
        initiatorType: 'script',
        url: WebUri('https://a.dev/app.js'),
        startTime: 1.5,
        duration: 2.25,
      );
      expect(r.toJson(), {
        'initiatorType': 'script',
        'url': 'https://a.dev/app.js',
        'startTime': 1.5,
        'duration': 2.25,
      });
      final back = LoadedResource.fromJson(r.toJson());
      expect(back.url?.toString(), 'https://a.dev/app.js');
      expect(back.duration, 2.25);
      expect(LoadedResource.fromJson({}).url, isNull);
    });
  });

  group('InAppWebViewHitTestResult', () {
    test('wire: type as int native value + extra', () {
      final r = InAppWebViewHitTestResult(
        type: InAppWebViewHitTestResultType.IMAGE_TYPE,
        extra: 'https://a.dev/i.png',
      );
      expect(r.toJson(), {'type': 5, 'extra': 'https://a.dev/i.png'});
      final back = InAppWebViewHitTestResult.fromJson({'type': 8, 'extra': 'x'});
      expect(back.type, InAppWebViewHitTestResultType.SRC_IMAGE_ANCHOR_TYPE);
      expect(back.extra, 'x');
    });

    test('unknown wire ints fall back safely', () {
      final r = InAppWebViewHitTestResult.fromJson({'type': 99});
      expect(r.type, isNull);
    });
  });

  group('InAppWebViewInitialData', () {
    test('wire + round-trip', () {
      final d = InAppWebViewInitialData(
        data: '<html></html>',
        mimeType: 'text/html',
        encoding: 'utf-8',
        baseUrl: WebUri('https://base.dev/'),
        historyUrl: WebUri('https://history.dev/'),
      );
      expect(d.toJson(), {
        'data': '<html></html>',
        'mimeType': 'text/html',
        'encoding': 'utf-8',
        'baseUrl': 'https://base.dev/',
        'historyUrl': 'https://history.dev/',
      });
      final back = InAppWebViewInitialData.fromJson(d.toJson());
      expect(back.baseUrl?.toString(), 'https://base.dev/');
      expect(back.historyUrl?.toString(), 'https://history.dev/');
      // data is required.
      expect(() => InAppWebViewInitialData.fromJson({}), throwsA(anything));
    });
  });

  group('ScreenshotConfiguration', () {
    test('wire: compressFormat by name + nested rect', () {
      final c = ScreenshotConfiguration(
        rect: InAppWebViewRect(x: 0, y: 0, width: 100, height: 50),
        snapshotWidth: 100,
        compressFormat: CompressFormat.JPEG,
        quality: 90,
        afterScreenUpdates: true,
      );
      final map = c.toJson();
      expect(map['rect'], {'x': 0.0, 'y': 0.0, 'width': 100.0, 'height': 50.0});
      expect(map['snapshotWidth'], 100);
      expect(map['compressFormat'], 'JPEG');
      expect(map['quality'], 90);
      expect(map['afterScreenUpdates'], true);
      final back = ScreenshotConfiguration.fromJson(c.toJson());
      expect(back.rect?.width, 100.0);
      expect(back.compressFormat, CompressFormat.JPEG);
    });
  });

  group('FindSession', () {
    test('wire: display style by name', () {
      final f = FindSession(
        resultCount: 3,
        highlightedResultIndex: 1,
        searchResultDisplayStyle: SearchResultDisplayStyle.TOTAL,
      );
      expect(f.toJson(), {
        'resultCount': 3,
        'highlightedResultIndex': 1,
        'searchResultDisplayStyle': 'TOTAL',
      });
      final back = FindSession.fromJson(f.toJson());
      expect(back.resultCount, 3);
      expect(back.searchResultDisplayStyle, SearchResultDisplayStyle.TOTAL);
    });
  });

  group('RequestFocusNodeHrefResult + RequestImageRefResult', () {
    test('wire + round-trip', () {
      final f = RequestFocusNodeHrefResult(
        url: WebUri('https://a.dev/'),
        title: 't',
        src: 'https://a.dev/i.png',
      );
      expect(f.toJson(), {
        'url': 'https://a.dev/',
        'title': 't',
        'src': 'https://a.dev/i.png',
      });
      final back = RequestFocusNodeHrefResult.fromJson(f.toJson());
      expect(back.url?.toString(), 'https://a.dev/');
      expect(back.src, 'https://a.dev/i.png');

      final img = RequestImageRefResult(url: WebUri('https://a.dev/i.png'));
      expect(img.toJson(), {'url': 'https://a.dev/i.png'});
      expect(RequestImageRefResult.fromJson(img.toJson()).url?.toString(),
          'https://a.dev/i.png');
    });
  });

  group('PrewarmingToken', () {
    test('wire + round-trip', () {
      final t = PrewarmingToken(id: 'token-1');
      expect(t.toJson(), {'id': 'token-1'});
      final back = PrewarmingToken.fromJson(t.toJson());
      expect(back.id, 'token-1');
    });
  });

  group('WebViewPackageInfo', () {
    test('wire + round-trip', () {
      final p = WebViewPackageInfo(versionName: '1.2.3', packageName: 'com.x');
      expect(p.toJson(), {'versionName': '1.2.3', 'packageName': 'com.x'});
      final back = WebViewPackageInfo.fromJson(p.toJson());
      expect(back.versionName, '1.2.3');
      expect(back.packageName, 'com.x');
    });
  });

  group('WindowFeatures', () {
    test('wire + defaults', () {
      final w = WindowFeatures(
        allowsResizing: true,
        height: 100,
        menuBarVisibility: true,
        statusBarVisibility: false,
        toolbarsVisibility: true,
        width: 200,
        x: 1,
        y: 2,
      );
      expect(w.toJson(), {
        'allowsResizing': true,
        'height': 100,
        'menuBarVisibility': true,
        'statusBarVisibility': false,
        'toolbarsVisibility': true,
        'width': 200,
        'x': 1,
        'y': 2,
      });
      final back = WindowFeatures.fromJson(w.toJson());
      expect(back.width, 200);
      expect(back.x, 1);
    });
  });

  group('URLResponse', () {
    test('wire + round-trip', () {
      final r = URLResponse(
        url: WebUri('https://a.dev/r'),
        expectedContentLength: 100,
        mimeType: 'text/html',
        suggestedFilename: 'r.html',
        textEncodingName: 'utf-8',
        headers: {'x-a': 'b'},
        statusCode: 200,
      );
      expect(r.toJson(), {
        'url': 'https://a.dev/r',
        'expectedContentLength': 100,
        'mimeType': 'text/html',
        'suggestedFilename': 'r.html',
        'textEncodingName': 'utf-8',
        'headers': {'x-a': 'b'},
        'statusCode': 200,
      });
      final back = URLResponse.fromJson(r.toJson());
      expect(back.url.toString(), 'https://a.dev/r');
      expect(back.statusCode, 200);
      expect(back.headers, {'x-a': 'b'});
    });
  });

  group('DownloadStartRequest', () {
    test('wire + round-trip', () {
      final d = DownloadStartRequest(
        url: WebUri('https://a.dev/file.zip'),
        userAgent: 'ua',
        contentDisposition: 'attachment',
        mimeType: 'application/zip',
        contentLength: 100,
        suggestedFilename: 'file.zip',
        textEncodingName: null,
      );
      expect(d.toJson(), {
        'url': 'https://a.dev/file.zip',
        'userAgent': 'ua',
        'contentDisposition': 'attachment',
        'mimeType': 'application/zip',
        'contentLength': 100,
        'suggestedFilename': 'file.zip',
        'textEncodingName': null,
      });
      final back = DownloadStartRequest.fromJson(d.toJson());
      expect(back.url.toString(), 'https://a.dev/file.zip');
      expect(back.contentLength, 100);
    });
  });

  group('CustomSchemeResponse', () {
    test('wire: data as Uint8List pass-through', () {
      final r = CustomSchemeResponse(
        data: Uint8List.fromList([1, 2, 3]),
        contentType: 'application/octet-stream',
        contentEncoding: 'utf-8',
      );
      expect(r.toJson()['data'], Uint8List.fromList([1, 2, 3]));
      expect(r.toJson()['contentType'], 'application/octet-stream');
      final back = CustomSchemeResponse.fromJson(r.toJson());
      expect(back.data, Uint8List.fromList([1, 2, 3]));
      // accepts List<int> too
      final viaList = CustomSchemeResponse.fromJson({
        'data': [4, 5],
        'contentType': 'text/plain',
        'contentEncoding': 'utf-8',
      });
      expect(viaList.data, Uint8List.fromList([4, 5]));
      // data is required
      expect(
        () => CustomSchemeResponse.fromJson({'contentType': 'x', 'contentEncoding': 'y'}),
        throwsA(anything),
      );
    });
  });

  group('WebsiteDataRecord', () {
    test('wire: dataTypes as WKWebsiteDataType strings', () {
      final r = WebsiteDataRecord(
        displayName: 'flutter.dev',
        dataTypes: {
          WebsiteDataType.WKWebsiteDataTypeCookies,
          WebsiteDataType.WKWebsiteDataTypeSessionStorage,
        },
      );
      final map = r.toJson();
      expect(map['displayName'], 'flutter.dev');
      expect(map['dataTypes'], {
        'WKWebsiteDataTypeCookies',
        'WKWebsiteDataTypeSessionStorage',
      });
      final back = WebsiteDataRecord.fromJson(r.toJson());
      expect(back.displayName, 'flutter.dev');
      expect(back.dataTypes, {
        WebsiteDataType.WKWebsiteDataTypeCookies,
        WebsiteDataType.WKWebsiteDataTypeSessionStorage,
      });
    });
  });
}
