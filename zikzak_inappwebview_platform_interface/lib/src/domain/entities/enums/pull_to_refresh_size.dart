///Class representing the size of the refresh indicator.
enum PullToRefreshSize {
  ///Default size.
  DEFAULT,

  ///Large size.
  LARGE,
}

///PullToRefreshSize wire values are NOT sequential (DEFAULT=1, LARGE=0 in
///the old codegen) — a plain enum's `.index` would be reversed.
int pullToRefreshSizeToWire(PullToRefreshSize size) => switch (size) {
  PullToRefreshSize.DEFAULT => 1,
  PullToRefreshSize.LARGE => 0,
};
