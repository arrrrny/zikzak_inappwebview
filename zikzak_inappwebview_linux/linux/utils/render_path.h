// Which path a WPE frame takes on its way to the Flutter texture.
//
// Two paths exist, and they are mutually exclusive per frame:
//
// - kZeroCopyEgl: the DMA-BUF buffer is kept and its EGL image is bound as a
//   Flutter texture, so no pixel ever crosses the CPU.
// - kPixelBuffer: the frame is copied into the CPU pixel buffer and the
//   texture uploads it.
//
// Mixing them is what left the visible view blank (issue #442): while an EGL
// image was imported, the buffer callbacks filled no pixel buffer, so a
// texture that could not sample the image (the pixel-buffer texture, or the
// EGL texture after its import was rejected) had nothing to draw.

#ifndef ZIKZAK_INAPPWEBVIEW_LINUX_UTILS_RENDER_PATH_H_
#define ZIKZAK_INAPPWEBVIEW_LINUX_UTILS_RENDER_PATH_H_

namespace zikzak_inappwebview {

enum class FramePath {
  // Keep the DMA-BUF buffer and expose its EGL image to Flutter.
  kZeroCopyEgl,
  // Copy the frame into the CPU pixel buffer for the texture to upload.
  kPixelBuffer,
};

// Decide what to do with one frame.
//
// Zero-copy needs all three of these: a texture that does not want the CPU
// copy, a DMA-BUF buffer (an SHM buffer cannot be imported through EGL) and
// a display to import it from, with no previous import failure for this view.
// Anything else needs the pixel buffer.
inline FramePath FramePathFor(bool egl_display_available, bool is_dma_buf,
                              bool egl_import_failed, bool pixel_readback_required) {
  if (pixel_readback_required) {
    return FramePath::kPixelBuffer;
  }
  if (!egl_display_available || !is_dma_buf || egl_import_failed) {
    return FramePath::kPixelBuffer;
  }
  return FramePath::kZeroCopyEgl;
}

}  // namespace zikzak_inappwebview

#endif  // ZIKZAK_INAPPWEBVIEW_LINUX_UTILS_RENDER_PATH_H_
