import 'package:zikzak_inappwebview_internal_annotations/zikzak_inappwebview_internal_annotations.dart';

part 'pull_to_refresh_size.g.dart';

///Class representing the size of the refresh indicator.
@ExchangeableEnum()
class PullToRefreshSize_ {
  // ignore: unused_field
  final int _value;
  const PullToRefreshSize_._internal(this._value);

  ///Default size.
  static const DEFAULT = const PullToRefreshSize_._internal(1);

  ///Large size.
  static const LARGE = const PullToRefreshSize_._internal(0);
}
