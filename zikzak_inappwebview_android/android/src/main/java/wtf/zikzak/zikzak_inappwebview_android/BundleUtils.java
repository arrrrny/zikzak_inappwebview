package wtf.zikzak.zikzak_inappwebview_android;

import android.os.Bundle;

import androidx.annotation.Nullable;
import androidx.core.os.BundleCompat;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/** Reads the serializable collections passed between the browser managers and activities. */
public final class BundleUtils {
  private BundleUtils() {}

  @Nullable
  public static <T> Map<String, T> getMap(Bundle bundle, String key, Class<T> valueType) {
    Serializable value = BundleCompat.getSerializable(bundle, key, Serializable.class);
    return copyMap((Map<?, ?>) value, valueType);
  }

  @Nullable
  public static List<Map<String, Object>> getMapList(Bundle bundle, String key) {
    Serializable value = BundleCompat.getSerializable(bundle, key, Serializable.class);
    if (value == null) return null;
    List<?> list = (List<?>) value;
    List<Map<String, Object>> result = new ArrayList<>(list.size());
    for (Object item : list) {
      result.add(copyMap((Map<?, ?>) item, Object.class));
    }
    return result;
  }

  @Nullable
  private static <T> Map<String, T> copyMap(@Nullable Map<?, ?> map, Class<T> valueType) {
    if (map == null) return null;
    Map<String, T> result = new HashMap<>();
    for (Map.Entry<?, ?> entry : map.entrySet()) {
      result.put(String.class.cast(entry.getKey()), valueType.cast(entry.getValue()));
    }
    return result;
  }
}
