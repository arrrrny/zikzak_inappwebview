package wtf.zikzak.zikzak_inappwebview_android.types;

import androidx.core.view.WindowInsetsCompat;

import java.util.Locale;

/**
 * Window-inset types that an Android WebView can be told to <b>ignore</b> when
 * laying out web content.
 *
 * <p>This is the native counterpart of the Dart {@code AndroidWebViewInsets}
 * class. The {@link #getValue() string values} are the stable wire format used
 * across the Dart &harr; Android method-channel boundary and mirror the names of
 * the corresponding {@code WindowInsetsCompat.Type} masks.</p>
 *
 * <p>When one of these types is configured to be ignored, the matching inset is
 * zeroed out before reaching the WebView so the WebView no longer pads or
 * shrinks its content for that inset (edge-to-edge / immersive layout).</p>
 */
public enum WebViewInsets {
    /** Insets for the IME (on-screen keyboard). */
    IME("ime", WindowInsetsCompat.Type.ime()),
    /** Insets for the system bars (status bar + navigation bar). */
    SYSTEM_BARS("systemBars", WindowInsetsCompat.Type.systemBars()),
    /** Insets for system gestures (e.g. swipe-from-edge back). */
    SYSTEM_GESTURES("systemGestures", WindowInsetsCompat.Type.systemGestures()),
    /** Insets for mandatory system gestures the system reserves for itself. */
    MANDATORY_SYSTEM_GESTURES(
        "mandatorySystemGestures",
        WindowInsetsCompat.Type.mandatorySystemGestures()
    ),
    /** Insets for the tappable element area reserved by the system. */
    TAPPABLE_ELEMENT("tappableElement", WindowInsetsCompat.Type.tappableElement()),
    /** Insets for the display cutout (notches / punch-holes). */
    DISPLAY_CUTOUT("displayCutout", WindowInsetsCompat.Type.displayCutout());

    private final String value;
    private final int typeMask;

    WebViewInsets(String value, int typeMask) {
        this.value = value;
        this.typeMask = typeMask;
    }

    /** Stable wire value used across the Dart &harr; Android boundary. */
    public String getValue() {
        return value;
    }

    /** The {@link WindowInsetsCompat.Type} mask this inset maps to. */
    public int getTypeMask() {
        return typeMask;
    }

    /**
     * Resolves a wire value to its {@link WebViewInsets}, or {@code null} if the
     * value is unknown.
     */
    public static WebViewInsets fromValue(String value) {
        if (value == null) {
            return null;
        }
        for (WebViewInsets insets : values()) {
            if (insets.value.equals(value)) {
                return insets;
            }
        }
        return null;
    }

    @Override
    public String toString() {
        return String.format(Locale.US, "%s(%s)", name(), value);
    }
}
