// Public-API regression tests for the web history valueObjects (Zorphy
// entities). Pins the consumer-visible contract:
//   - JSON wire format (WebUri as toString; nested item lists)
//   - null/missing-key tolerance of fromJson (WebHistoryItem.url required)
import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

void main() {
  group('WebHistoryItem', () {
    test('toJson emits the wire format', () {
      final item = WebHistoryItem(
        originalUrl: WebUri('https://flutter.dev/original'),
        title: 'Flutter',
        url: WebUri('https://flutter.dev/'),
        index: 0,
        offset: 1,
        entryId: 7,
      );
      expect(item.toJson(), {
        'originalUrl': 'https://flutter.dev/original',
        'title': 'Flutter',
        'url': 'https://flutter.dev/',
        'index': 0,
        'offset': 1,
        'entryId': 7,
      });
    });

    test('null/missing keys tolerated everywhere (url too)', () {
      final item = WebHistoryItem.fromJson({});
      expect(item.originalUrl, isNull);
      expect(item.url, isNull);
      expect(item.title, isNull);
      expect(item.index, isNull);
      expect(item.offset, isNull);
      expect(item.entryId, isNull);
    });

    test('round-trip + copyWith', () {
      final item = WebHistoryItem(
        originalUrl: WebUri('https://a.dev'),
        url: WebUri('https://b.dev'),
        index: 3,
      );
      final back = WebHistoryItem.fromJson(item.toJson());
      expect(back.originalUrl?.toString(), 'https://a.dev');
      expect(back.url.toString(), 'https://b.dev');
      expect(back.index, 3);
      expect(item.copyWith(index: 4).index, 4);
    });
  });

  group('WebHistory', () {
    test('toJson nests item maps + currentIndex', () {
      final h = WebHistory(
        list: [
          WebHistoryItem(url: WebUri('https://a.dev'), index: 0),
          WebHistoryItem(url: WebUri('https://b.dev'), index: 1),
        ],
        currentIndex: 1,
      );
      expect(h.toJson(), {
        'list': [
          {'originalUrl': null, 'title': null, 'url': 'https://a.dev', 'index': 0, 'offset': null, 'entryId': null},
          {'originalUrl': null, 'title': null, 'url': 'https://b.dev', 'index': 1, 'offset': null, 'entryId': null},
        ],
        'currentIndex': 1,
      });
    });

    test('fromJson is null/missing-key tolerant + round-trip', () {
      final h = WebHistory.fromJson({});
      expect(h.list, isNull);
      expect(h.currentIndex, isNull);

      final full = WebHistory(
        list: [WebHistoryItem(url: WebUri('https://c.dev'))],
        currentIndex: 0,
      );
      final back = WebHistory.fromJson(full.toJson());
      expect(back.list, hasLength(1));
      expect(back.list!.first.url.toString(), 'https://c.dev');
      expect(back.currentIndex, 0);
      expect(full.copyWith(currentIndex: 5).currentIndex, 5);
    });
  });
}
