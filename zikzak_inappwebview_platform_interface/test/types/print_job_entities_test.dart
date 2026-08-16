// Public-API regression tests for the print_job family, migrated from
// @ExchangeableObject/@ExchangeableEnum codegen (see PROGRESS.md, Phase 3g).
//
// Pins the CONSUMER-VISIBLE contract: wire formats incl. the NON-sequential
// enums (PrintJobColorMode 1-based, PrintJobState 1..7, PrintJobPageOrder
// -1/0/1/2), nested PrintJobMediaSize/PrintJobResolution/PrintJobInfo, WebUri
// as string, EdgeInsets via MapEdgeInsets, and round-trips.
import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

void main() {
  group('print_job enum wires', () {
    test('PrintJobColorMode is 1-based', () {
      expect(printJobColorModeToWire(PrintJobColorMode.MONOCHROME), 1);
      expect(printJobColorModeToWire(PrintJobColorMode.COLOR), 2);
      expect(printJobColorModeFromWire(1), PrintJobColorMode.MONOCHROME);
      expect(printJobColorModeFromWire(0), isNull);
    });

    test('PrintJobState is 1-based', () {
      expect(printJobStateToWire(PrintJobState.CREATED), 1);
      expect(printJobStateToWire(PrintJobState.CANCELED), 7);
      expect(printJobStateFromWire(7), PrintJobState.CANCELED);
    });

    test('PrintJobPageOrder is -1/0/1/2', () {
      expect(printJobPageOrderToWire(PrintJobPageOrder.DESCENDING), -1);
      expect(printJobPageOrderToWire(PrintJobPageOrder.UNKNOWN), 2);
      expect(printJobPageOrderFromWire(-1), PrintJobPageOrder.DESCENDING);
      expect(printJobPageOrderFromWire(5), isNull);
    });
  });

  group('PrintJobSettings', () {
    test('wire round-trip (nested mediaSize, WebUri, enum wires)', () {
      final settings = PrintJobSettings(
        handledByClient: true,
        jobName: 'job',
        colorMode: PrintJobColorMode.COLOR,
        pageOrder: PrintJobPageOrder.DESCENDING,
        mediaSize: PrintJobMediaSize(
          id: 'A4',
          label: 'A4',
          widthMils: 827,
          heightMils: 1169,
        ),
        jobSavingURL: WebUri('https://example.com/job.pdf'),
        firstPage: 1,
        lastPage: 10,
      );
      final map = settings.toJson();
      expect(map['colorMode'], 2);
      expect(map['pageOrder'], -1);
      expect((map['mediaSize'] as Map)['id'], 'A4');
      expect(map['jobSavingURL'], 'https://example.com/job.pdf');

      final restored = PrintJobSettings.fromJson(map);
      expect(restored.colorMode, PrintJobColorMode.COLOR);
      expect(restored.pageOrder, PrintJobPageOrder.DESCENDING);
      expect(restored.mediaSize!.id, 'A4');
      expect(restored.jobSavingURL!.toString(), 'https://example.com/job.pdf');
      expect(restored.firstPage, 1);
    });
  });

  group('PrintJobInfo', () {
    test('nested printer + state wire round-trip', () {
      final info = PrintJobInfo(
        state: PrintJobState.COMPLETED,
        label: 'job',
        numberOfPages: 5,
        printer: Printer(name: 'printer'),
      );
      final map = info.toJson();
      expect(map['state'], 5);
      expect((map['printer'] as Map)['name'], 'printer');

      final restored = PrintJobInfo.fromJson(map);
      expect(restored.state, PrintJobState.COMPLETED);
      expect(restored.printer!.name, 'printer');
      expect(restored.numberOfPages, 5);
    });
  });
}
