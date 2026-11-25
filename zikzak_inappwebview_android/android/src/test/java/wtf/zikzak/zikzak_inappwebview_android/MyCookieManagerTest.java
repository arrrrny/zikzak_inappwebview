package wtf.zikzak.zikzak_inappwebview_android;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;

import android.webkit.CookieManager;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.robolectric.RobolectricTestRunner;
import org.robolectric.shadows.ShadowLooper;
import org.robolectric.annotation.Config;

import java.nio.ByteBuffer;
import java.util.Map;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.TimeUnit;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

@RunWith(RobolectricTestRunner.class)
@Config(sdk = {24, 34})
public class MyCookieManagerTest {
  private MyCookieManager manager;

  @Before
  public void setUp() {
    MyCookieManager.cookieManager = null;
    InAppWebViewFlutterPlugin plugin = new InAppWebViewFlutterPlugin();
    plugin.messenger = new UnusedMessenger();
    manager = new MyCookieManager(plugin);
  }

  @After
  public void tearDown() {
    manager.dispose();
    MyCookieManager.cookieManager = null;
  }

  @Test
  public void setsCookieFromChannelArgumentsAndReturnsThePlatformResult() throws Exception {
    Result result = new Result();

    manager.onMethodCall(new MethodCall("setCookie", Map.of(
        "url", "https://example.test", "name", "session", "value", "abc",
        "path", "/", "expiresDate", "4102444800000")), result);
    ShadowLooper.idleMainLooper();

    assertEquals(Boolean.TRUE, result.value.get(5, TimeUnit.SECONDS));
    assertEquals("session=abc", CookieManager.getInstance().getCookie("https://example.test"));
  }

  @Test
  public void clearsTheNamedCookieValueWithoutChangingOtherCookies() throws Exception {
    CookieManager.getInstance().setCookie("https://example.test", "session=abc; Path=/");
    CookieManager.getInstance().setCookie("https://example.test", "other=kept; Path=/");
    Result result = new Result();

    manager.onMethodCall(new MethodCall("deleteCookie", Map.of(
        "url", "https://example.test", "name", "session", "path", "/")), result);
    ShadowLooper.idleMainLooper();

    assertEquals(Boolean.TRUE, result.value.get(5, TimeUnit.SECONDS));
    // Robolectric's cookie store does not expire Max-Age=0 cookies, but it does
    // expose the replacement value and the other cookies sent to the platform.
    String cookies = CookieManager.getInstance().getCookie("https://example.test");
    assertTrue(cookies.contains("other=kept"));
    assertFalse(cookies.contains("session=abc"));
  }

  @Test
  public void removesSessionCookiesAndKeepsPersistentCookies() throws Exception {
    CookieManager.getInstance().setCookie("https://example.test", "session=abc; Path=/");
    CookieManager.getInstance().setCookie("https://example.test",
        "persistent=kept; Path=/; Expires=Fri, 01 Jan 2100 00:00:00 GMT");
    Result result = new Result();

    manager.onMethodCall(new MethodCall("removeSessionCookies", null), result);
    ShadowLooper.idleMainLooper();

    assertEquals(Boolean.TRUE, result.value.get(5, TimeUnit.SECONDS));
    assertEquals("persistent=kept", CookieManager.getInstance().getCookie("https://example.test"));
  }

  @Test
  public void removesAllCookiesAndReturnsThePlatformResult() throws Exception {
    CookieManager.getInstance().setCookie("https://example.test", "session=abc; Path=/");
    Result result = new Result();

    manager.onMethodCall(new MethodCall("deleteAllCookies", null), result);
    ShadowLooper.idleMainLooper();

    assertEquals(Boolean.TRUE, result.value.get(5, TimeUnit.SECONDS));
    assertNull(CookieManager.getInstance().getCookie("https://example.test"));
  }

  private static final class Result implements MethodChannel.Result {
    final CompletableFuture<Object> value = new CompletableFuture<>();

    @Override
    public void success(Object result) { value.complete(result); }

    @Override
    public void error(String code, String message, Object details) {
      value.completeExceptionally(new AssertionError(code + ": " + message));
    }

    @Override
    public void notImplemented() {
      value.completeExceptionally(new AssertionError("Method not implemented"));
    }
  }

  private static final class UnusedMessenger implements BinaryMessenger {
    @Override
    public void send(String channel, ByteBuffer message) { throw new AssertionError(channel); }

    @Override
    public void send(String channel, ByteBuffer message, BinaryReply callback) {
      throw new AssertionError(channel);
    }

    @Override
    public void setMessageHandler(String channel, BinaryMessageHandler handler) {}
  }
}
