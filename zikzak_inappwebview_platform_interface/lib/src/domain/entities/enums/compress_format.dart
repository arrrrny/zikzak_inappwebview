

///Class that represents the known formats a bitmap can be compressed into.
enum CompressFormat {
  ///Compress to the `PNG` format.
  ///PNG is lossless, so `quality` is ignored.
  PNG,
  ///Compress to the `JPEG` format.
  ///Quality of `0` means compress for the smallest size.
  ///`100` means compress for max visual quality.
  JPEG,
  ///Compress to the `WEBP` lossy format.
  ///Quality of `0` means compress for the smallest size.
  ///`100` means compress for max visual quality.
  WEBP,
  ///Compress to the `WEBP` lossy format.
  ///Quality of `0` means compress for the smallest size.
  ///`100` means compress for max visual quality.
  WEBP_LOSSY,
  ///Compress to the `WEBP` lossless format.
  ///Quality refers to how much effort to put into compression.
  ///A value of `0` means to compress quickly, resulting in a relatively large file size.
  ///`100` means to spend more time compressing, resulting in a smaller file.
  WEBP_LOSSLESS,
}
