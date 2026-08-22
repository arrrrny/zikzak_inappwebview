import 'package:zorphy_annotation/zorphy_annotation.dart';

part 'printer.zorphy.dart';
part 'printer.g.dart';

///Class representing the printer used by a [PlatformPrintJobController].
@Zorphy(
  kind: ZorphyKind.valueObject,
  generateJson: true,
  generateCompareTo: true,
)
abstract class $Printer {
  ///The unique id of the printer.
  String? get id;

  ///A description of the printer’s make and model.
  String? get type;

  ///The PostScript language level recognized by the printer.
  int? get languageLevel;

  ///The printer’s name.
  String? get name;
}
