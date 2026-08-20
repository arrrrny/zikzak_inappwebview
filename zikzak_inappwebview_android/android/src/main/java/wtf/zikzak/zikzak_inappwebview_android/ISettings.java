package wtf.zikzak.zikzak_inappwebview_android;

import android.util.Log;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.util.Map;

/**
 * Common contract for all plugin settings model classes parsed from a
 * Flutter platform-channel {@code Map<String, Object>} (the wire format
 * produced by the Dart side's {@code toMap()} / {@code toJson()}).
 *
 * <h2>Wire-format coercion</h2>
 *
 * The Flutter platform channel's {@code StandardMessageCodec} preserves the
 * runtime type of values, so a Dart {@code int} normally arrives as a
 * {@link Integer} and a Dart {@code bool} arrives as a {@link Boolean}.
 * However, in practice the wire format is not always so strict:
 *
 * <ul>
 *   <li>On the 5.x line (master), the model layer migrated to
 *       {@code json_serializable}. Without explicit
 *       {@code @JsonKey(toJson: ..., fromJson: ...)} converters, enum fields
 *       serialize as their <em>string name</em> (e.g. {@code "OFF"},
 *       {@code "MIXED_CONTENT_ALWAYS_ALLOW"}) rather than their integer
 *       wire value. See issue
 *       <a href="https://github.com/arrrrny/zikzak_inappwebview/issues/245">#245</a>:
 *       {@code ClassCastException: java.lang.String cannot be cast to
 *       java.lang.Integer} raised at {@code InAppWebViewSettings.parse}
 *       on Android.</li>
 *   <li>Hand-built maps (e.g. tests, persisted settings, third-party
 *       callers) frequently pass integer fields as numeric strings
 *       ({@code "0"}, {@code "2"}).</li>
 *   <li>JS interop paths sometimes box numbers as {@link Number} subtypes
 *       other than {@link Integer} (e.g. {@link java.lang.Long},
 *       {@link java.lang.Double}).</li>
 * </ul>
 *
 * Direct {@code (Integer) value} casts in {@link #parse(Map)} throw a
 * runtime {@link ClassCastException} on any of the above. The
 * {@link #coerceInteger(Object)} helper on this interface accepts all three
 * forms and either returns the coerced {@link Integer} or {@code null}
 * (which the caller is expected to map to its field default by simply not
 * assigning). This makes the Android settings parser resilient to future
 * Dart-side codegen changes — most importantly, it makes the 4.x maintenance
 * line (the {@code development} branch) forward-compatible with the 5.x
 * json_serializable models, which is the regression that broke published
 * 5.0.0 builds in issue #245.
 */
public interface ISettings<T> {
  /** Shared log tag for coerce / fallback diagnostics. */
  String LOG_TAG = "ISettings";

  @NonNull ISettings<T> parse(@NonNull Map<String, Object> settings);
  @NonNull Map<String, Object> toMap();
  @NonNull Map<String, Object> getRealSettings(@NonNull T obj);

  /**
   * Coerce a platform-channel wire value to an {@link Integer}.
   *
   * <p>Accepts (in order):
   * <ul>
   *   <li>{@code null} → {@code null}</li>
   *   <li>{@link Integer} → returned as-is</li>
   *   <li>any other {@link Number} (e.g. {@link java.lang.Long},
   *       {@link java.lang.Double}, {@link java.math.BigInteger}) →
   *       {@link Number#intValue()}</li>
   *   <li>{@link String} → parsed via {@link Integer#parseInt(String)} if
   *       numeric, otherwise {@code null} with a warning log
   *       (the wire value is most likely an enum name like {@code "OFF"}
   *       whose integer mapping is field-specific and cannot be resolved
   *       generically; callers should keep the field default in that case)</li>
   *   <li>any other type → {@code null} with a warning log</li>
   * </ul>
   *
   * <p>This method never throws — it logs and falls back to {@code null}.
   * Callers should treat {@code null} as "keep the field default" by
   * wrapping the assignment in a null check:
   * <pre>{@code
   * Integer coerced = ISettings.coerceInteger(value);
   * if (coerced != null) {
   *     forceDark = coerced;
   * }
   * }</pre>
   *
   * <p>For brevity in the common case where the field default is already
   * {@code null} (or the caller is happy to overwrite with {@code null}),
   * a direct assignment is also acceptable:
   * <pre>{@code
   * forceDark = ISettings.coerceInteger(value);
   * }</pre>
   *
   * @param value the raw wire value (may be {@code null})
   * @return the coerced {@link Integer}, or {@code null} if {@code value}
   *         is {@code null} or cannot be coerced
   */
  @Nullable
  static Integer coerceInteger(@Nullable Object value) {
    if (value == null) {
      return null;
    }
    if (value instanceof Integer) {
      return (Integer) value;
    }
    if (value instanceof Number) {
      return ((Number) value).intValue();
    }
    if (value instanceof String) {
      String s = ((String) value).trim();
      if (s.isEmpty()) {
        return null;
      }
      try {
        return Integer.parseInt(s);
      } catch (NumberFormatException e) {
        Log.w(
          LOG_TAG,
          "Cannot coerce String->Integer (value=\"" + s + "\"); " +
          "keeping field default. See issue #245."
        );
        return null;
      }
    }
    Log.w(
      LOG_TAG,
      "Cannot coerce to Integer (type=" +
      value.getClass().getName() + "); keeping field default."
    );
    return null;
  }
}
