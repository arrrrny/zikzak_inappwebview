package wtf.zikzak.zikzak_inappwebview_android;

import static org.junit.Assert.assertArrayEquals;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertThrows;

import android.os.Bundle;
import android.os.Parcel;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.robolectric.RobolectricTestRunner;
import org.robolectric.annotation.Config;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RunWith(RobolectricTestRunner.class)
@Config(sdk = {24, 33, 34})
public class BundleUtilsTest {
  @Test
  public void readsHeadersAndNestedSettingsAfterParcelRoundTrip() {
    Bundle bundle = new Bundle();
    bundle.putSerializable("headers", new HashMap<>(Map.of("X-Test", "value")));
    HashMap<String, Object> settings = new HashMap<>();
    settings.put("hidden", true);
    settings.put("nested", new HashMap<>(Map.of("name", "kept")));
    settings.put("bytes", new byte[] {1, 2, 3});
    bundle.putSerializable("settings", settings);
    Parcel parcel = Parcel.obtain();
    bundle.writeToParcel(parcel, 0);
    parcel.setDataPosition(0);
    Bundle restored = Bundle.CREATOR.createFromParcel(parcel);

    Map<String, String> headers = BundleUtils.getMap(restored, "headers", String.class);
    Map<String, Object> restoredSettings = BundleUtils.getMap(restored, "settings", Object.class);

    assertEquals("value", headers.get("X-Test"));
    assertEquals(Boolean.TRUE, restoredSettings.get("hidden"));
    assertEquals(Map.of("name", "kept"), restoredSettings.get("nested"));
    assertArrayEquals(new byte[] {1, 2, 3}, (byte[]) restoredSettings.get("bytes"));
    parcel.recycle();
  }

  @Test
  public void readsMenuAndScriptMapListsAfterParcelRoundTrip() {
    Bundle bundle = new Bundle();
    bundle.putSerializable("menuItems", new ArrayList<>(Collections.singletonList(
        new HashMap<>(Map.of("id", 7, "label", "Open")))));
    Parcel parcel = Parcel.obtain();
    bundle.writeToParcel(parcel, 0);
    parcel.setDataPosition(0);
    Bundle restored = Bundle.CREATOR.createFromParcel(parcel);

    List<Map<String, Object>> menu = BundleUtils.getMapList(restored, "menuItems");

    assertEquals(1, menu.size());
    assertEquals(7, menu.get(0).get("id"));
    assertEquals("Open", menu.get(0).get("label"));
    parcel.recycle();
  }

  @Test
  public void preservesAbsentOptionalCollections() {
    Bundle bundle = new Bundle();

    assertNull(BundleUtils.getMap(bundle, "actionButton", Object.class));
    assertNull(BundleUtils.getMapList(bundle, "initialUserScripts"));
  }

  @Test
  public void rejectsNonStringHeaderValuesAtTheReadBoundary() {
    Bundle bundle = new Bundle();
    bundle.putSerializable("headers", new HashMap<>(Map.of("X-Test", 7)));

    assertThrows(ClassCastException.class,
        () -> BundleUtils.getMap(bundle, "headers", String.class));
  }

  @Test
  public void rejectsNonStringMapKeysAtTheReadBoundary() {
    Bundle bundle = new Bundle();
    bundle.putSerializable("settings", new HashMap<>(Map.of(7, "value")));

    assertThrows(ClassCastException.class,
        () -> BundleUtils.getMap(bundle, "settings", Object.class));
  }
}
