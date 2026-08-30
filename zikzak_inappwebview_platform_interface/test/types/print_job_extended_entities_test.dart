// Public-API regression tests for the print_job valueObjects not covered by
// print_job_entities_test (PrintJobAttributes + its nested media size /
// resolution / printer + the print-job enums). Pins the wire contract:
//   - colorMode wire 1..2, state 1-based, pageOrder [-1,0,1,2],
//     duplex/orientation by index, nested object maps
// NOTE: duplexMode/disposition/paginationMode were platform-adaptive in
// upstream (per-OS native values / string wires); the migration flattened
// them to sequential index wires — pinned as shipped.
import 'package:flutter_test/flutter_test.dart';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

void main() {
  group('PrintJobMediaSize', () {
    test('wire + round-trip', () {
      final m = PrintJobMediaSize(
        id: 'A4',
        widthMils: 8267,
        heightMils: 11692,
        label: 'A4',
      );
      expect(m.toJson(), {
        'id': 'A4',
        'widthMils': 8267,
        'heightMils': 11692,
        'label': 'A4',
      });
      final back = PrintJobMediaSize.fromJson(m.toJson());
      expect(back.widthMils, 8267);
      expect(back.heightMils, 11692);
    });
  });

  group('PrintJobResolution', () {
    test('wire + round-trip', () {
      final r = PrintJobResolution(
        id: '300dpi',
        label: '300',
        verticalDpi: 300,
        horizontalDpi: 300,
      );
      expect(r.toJson(), {
        'id': '300dpi',
        'label': '300',
        'verticalDpi': 300,
        'horizontalDpi': 300,
      });
      final back = PrintJobResolution.fromJson(r.toJson());
      expect(back.verticalDpi, 300);
      expect(back.horizontalDpi, 300);
    });
  });

  group('Printer', () {
    test('wire + round-trip', () {
      final p = Printer(
        id: 'p1',
        type: 'printer',
        languageLevel: 1,
        name: 'Office',
      );
      expect(p.toJson(), {
        'id': 'p1',
        'type': 'printer',
        'languageLevel': 1,
        'name': 'Office',
      });
      final back = Printer.fromJson(p.toJson());
      expect(back.id, 'p1');
      expect(back.languageLevel, 1);
    });
  });

  group('PrintJobAttributes', () {
    test('wire: enums + nested objects', () {
      final a = PrintJobAttributes(
        colorMode: PrintJobColorMode.COLOR,
        duplexMode: PrintJobDuplexMode.LONG_EDGE,
        orientation: PrintJobOrientation.LANDSCAPE,
        mediaSize: PrintJobMediaSize(id: 'A4', widthMils: 8267, heightMils: 11692, label: 'A4'),
        resolution: PrintJobResolution(
          id: 'r',
          label: '300',
          verticalDpi: 300,
          horizontalDpi: 300,
        ),
        footerHeight: 0.5,
        headerHeight: 0.5,
        paperName: 'A4',
        localizedPaperName: 'A4',
        printableRect: InAppWebViewRect(x: 0, y: 0, width: 100, height: 50),
        paperRect: InAppWebViewRect(x: 0, y: 0, width: 200, height: 100),
        detailedErrorReporting: true,
        faxNumber: '123',
        jobDisposition: PrintJobDisposition.SAVE,
        horizontalPagination: PrintJobPaginationMode.FIT,
        verticalPagination: PrintJobPaginationMode.AUTOMATIC,
      );
      final map = a.toJson();
      expect(map['colorMode'], 2);
      expect(map['duplexMode'], 1);
      expect(map['orientation'], 1);
      expect(map['mediaSize'], {
        'id': 'A4',
        'widthMils': 8267,
        'heightMils': 11692,
        'label': 'A4',
      });
      expect(map['resolution'], {
        'id': 'r',
        'label': '300',
        'verticalDpi': 300,
        'horizontalDpi': 300,
      });
      expect(map['printableRect'], {'x': 0.0, 'y': 0.0, 'width': 100.0, 'height': 50.0});
      expect(map['paperRect'], {'x': 0.0, 'y': 0.0, 'width': 200.0, 'height': 100.0});
      expect(map['jobDisposition'], 2); // SAVE index
      expect(map['horizontalPagination'], 1); // FIT index

      final back = PrintJobAttributes.fromJson(map);
      expect(back.colorMode, PrintJobColorMode.COLOR);
      expect(back.duplexMode, PrintJobDuplexMode.LONG_EDGE);
      expect(back.mediaSize?.widthMils, 8267);
      expect(back.resolution?.verticalDpi, 300);
      expect(back.jobDisposition, PrintJobDisposition.SAVE);
      expect(back.horizontalPagination, PrintJobPaginationMode.FIT);
    });

    test('fromJson is null/missing-key tolerant', () {
      final a = PrintJobAttributes.fromJson({});
      expect(a.colorMode, isNull);
      expect(a.mediaSize, isNull);
      expect(a.margins, isNull);
    });
  });

  group('print-job enum wires', () {
    test('PrintJobColorMode: 1-based', () {
      expect(printJobColorModeToWire(PrintJobColorMode.MONOCHROME), 1);
      expect(printJobColorModeToWire(PrintJobColorMode.COLOR), 2);
      expect(printJobColorModeFromWire(1), PrintJobColorMode.MONOCHROME);
      expect(printJobColorModeFromWire(3), isNull);
      expect(printJobColorModeFromWire(null), isNull);
    });

    test('PrintJobState: 1-based', () {
      expect(printJobStateToWire(PrintJobState.CREATED), 1);
      expect(printJobStateToWire(PrintJobState.CANCELED), 7);
      expect(printJobStateFromWire(4), PrintJobState.BLOCKED);
      expect(printJobStateFromWire(0), isNull);
      expect(printJobStateFromWire(8), isNull);
    });

    test('PrintJobPageOrder: [-1,0,1,2]', () {
      expect(printJobPageOrderToWire(PrintJobPageOrder.DESCENDING), -1);
      expect(printJobPageOrderToWire(PrintJobPageOrder.SPECIAL), 0);
      expect(printJobPageOrderToWire(PrintJobPageOrder.ASCENDING), 1);
      expect(printJobPageOrderToWire(PrintJobPageOrder.UNKNOWN), 2);
      expect(printJobPageOrderFromWire(1), PrintJobPageOrder.ASCENDING);
      expect(printJobPageOrderFromWire(99), isNull);
    });

    test('sequential enums: orientation/outputType/renderingQuality', () {
      expect(PrintJobOrientation.PORTRAIT.index, 0);
      expect(PrintJobOrientation.LANDSCAPE.index, 1);
      expect(PrintJobOutputType.GENERAL.index, 0);
      expect(PrintJobOutputType.PHOTO_GRAYSCALE.index, 3);
      expect(PrintJobRenderingQuality.BEST.index, 0);
      expect(PrintJobRenderingQuality.RESPONSIVE.index, 1);
      expect(PrintJobDuplexMode.NONE.index, 0);
      expect(PrintJobDuplexMode.LONG_EDGE.index, 1);
      expect(PrintJobDuplexMode.SHORT_EDGE.index, 2);
      expect(PrintJobDisposition.SPOOL.index, 0);
      expect(PrintJobDisposition.CANCEL.index, 3);
      expect(PrintJobPaginationMode.AUTOMATIC.index, 0);
      expect(PrintJobPaginationMode.CLIP.index, 2);
    });
  });
}
