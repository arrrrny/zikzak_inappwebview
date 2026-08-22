import 'package:zorphy_annotation/zorphy_annotation.dart';

part 'print_job_media_size.zorphy.dart';
part 'print_job_media_size.g.dart';

///Class representing the supported media size for a [PlatformPrintJobController].
///Media size is the dimension of the media on which the content is printed.
@Zorphy(
  kind: ZorphyKind.valueObject,
  generateJson: true,
  generateCompareTo: true,
)
abstract class $PrintJobMediaSize {
  ///The unique media size id.
  ///
  ///It is unique amongst other media sizes supported by the printer.
  ///This id is defined by the client that generated the media size
  ///instance and should not be interpreted by other parties.
  String get id;

  ///The media width in mils (thousandths of an inch).
  int get widthMils;

  ///The media height in mils (thousandths of an inch).
  int get heightMils;

  ///The human readable label.
  String? get label;
}
