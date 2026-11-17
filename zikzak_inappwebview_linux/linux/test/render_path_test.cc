#include "utils/render_path.h"

#include <gtest/gtest.h>

namespace zikzak_inappwebview {
namespace test {

namespace {

// The inputs of FramePathFor, spelled out per case.
struct FramePathCase {
  const char* name;
  bool egl_display_available;
  bool is_dma_buf;
  bool egl_import_failed;
  bool pixel_readback_required;
  FramePath expected;
};

// One table covers every combination the buffer callbacks can produce, so a
// change to the decision has to be made here first. The middle column is the
// zero-copy path as it runs on a healthy desktop: a DMA-BUF buffer, a display
// to import from, a texture that does not want the CPU copy.
constexpr FramePathCase kCases[] = {
    {"zero-copy on a healthy stack", true, true, false, false, FramePath::kZeroCopyEgl},
    {"software texture (DISABLE_GL) needs the CPU copy", true, true, false, true,
     FramePath::kPixelBuffer},
    {"EGL texture whose import was rejected needs the CPU copy", true, true, true, true,
     FramePath::kPixelBuffer},
    {"no EGL display (software rendering)", false, true, false, false, FramePath::kPixelBuffer},
    {"SHM buffer cannot be imported", true, false, false, false, FramePath::kPixelBuffer},
    {"a previous import failure latches the pixel path", true, true, true, false,
     FramePath::kPixelBuffer},
    {"nothing works", false, false, true, true, FramePath::kPixelBuffer},
};

}  // namespace

// The rule issue #442 is about: a frame that needs the CPU copy must never be
// routed to zero-copy, and a frame that cannot be imported must never be
// routed to zero-copy either.
TEST(RenderPath, FollowsTheCaseTable) {
  for (const auto& c : kCases) {
    SCOPED_TRACE(c.name);
    EXPECT_EQ(FramePathFor(c.egl_display_available, c.is_dma_buf, c.egl_import_failed,
                           c.pixel_readback_required),
              c.expected);
  }
}

TEST(RenderPath, ZeroCopyIsOnlyChosenForAnImportableDmaBufFrameNobodyNeedsPixelsFrom) {
  for (int mask = 0; mask < 16; mask++) {
    const bool egl_display_available = (mask & 1) != 0;
    const bool is_dma_buf = (mask & 2) != 0;
    const bool egl_import_failed = (mask & 4) != 0;
    const bool pixel_readback_required = (mask & 8) != 0;

    const FramePath path = FramePathFor(egl_display_available, is_dma_buf, egl_import_failed,
                                        pixel_readback_required);
    const bool zero_copy =
        path == FramePath::kZeroCopyEgl && egl_display_available && is_dma_buf &&
        !egl_import_failed && !pixel_readback_required;
    EXPECT_EQ(path == FramePath::kZeroCopyEgl, zero_copy)
        << "mask " << mask << ": zero-copy is not allowed here";
  }
}

}  // namespace test
}  // namespace zikzak_inappwebview