import 'package:zikzak_inappwebview_internal_annotations/zikzak_inappwebview_internal_annotations.dart';

part 'over_scroll_mode.g.dart';

///Class used to configure the `WebView`'s over-scroll mode.
///Setting the over-scroll mode of a WebView will have an effect only if the `WebView` is capable of scrolling.
@ExchangeableEnum()
class OverScrollMode_ {
  // ignore: unused_field
  final int _value;
  const OverScrollMode_._internal(this._value);

  ///Always allow a user to over-scroll this view, provided it is a view that can scroll.
  static const ALWAYS = const OverScrollMode_._internal(0);

  ///Allow a user to over-scroll this view only if the content is large enough to meaningfully scroll, provided it is a view that can scroll.
  static const IF_CONTENT_SCROLLS = const OverScrollMode_._internal(1);

  ///Never allow a user to over-scroll this view.
  static const NEVER = const OverScrollMode_._internal(2);
}
