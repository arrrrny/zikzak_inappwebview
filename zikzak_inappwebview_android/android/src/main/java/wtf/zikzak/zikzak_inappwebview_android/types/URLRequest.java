package wtf.zikzak.zikzak_inappwebview_android.types;

import androidx.annotation.Nullable;

import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;

public class URLRequest {
  @Nullable
  private String url;
  @Nullable
  private String method;
  @Nullable
  private byte[] body;
  @Nullable
  private Map<String, String> headers;
  @Nullable
  private Double timeoutInterval;

  public URLRequest(@Nullable String url, @Nullable String method, @Nullable byte[] body, @Nullable Map<String, String> headers, @Nullable Double timeoutInterval) {
    this.url = url;
    this.method = method;
    this.body = body;
    this.headers = headers;
    this.timeoutInterval = timeoutInterval;
  }

  @Nullable
  public static URLRequest fromMap(@Nullable Map<String, Object> map) {
    if (map == null) {
      return null;
    }
    String url = (String) map.get("url");
    if (url == null) {
      url = "about:blank";
    }
    String method = (String) map.get("method");
    byte[] body = (byte[]) map.get("body");
    Map<String, String> headers = (Map<String, String>) map.get("headers");
    Double timeoutInterval = null;
    Object timeoutObj = map.get("timeoutInterval");
    if (timeoutObj instanceof Number) {
      timeoutInterval = ((Number) timeoutObj).doubleValue();
    }
    return new URLRequest(url, method, body, headers, timeoutInterval);
  }

  public Map<String, Object> toMap() {
    Map<String, Object> urlRequestMap = new HashMap<>();
    urlRequestMap.put("url", url);
    urlRequestMap.put("method", method);
    urlRequestMap.put("headers", headers);
    urlRequestMap.put("body", body);
    urlRequestMap.put("allowsCellularAccess", null);
    urlRequestMap.put("allowsConstrainedNetworkAccess", null);
    urlRequestMap.put("allowsExpensiveNetworkAccess", null);
    urlRequestMap.put("cachePolicy", null);
    urlRequestMap.put("httpShouldHandleCookies", null);
    urlRequestMap.put("httpShouldUsePipelining", null);
    urlRequestMap.put("networkServiceType", null);
    urlRequestMap.put("timeoutInterval", timeoutInterval);
    urlRequestMap.put("mainDocumentURL", null);
    urlRequestMap.put("assumesHTTP3Capable", null);
    urlRequestMap.put("attribution", null);
    return urlRequestMap;
  }

  @Nullable
  public String getUrl() {
    return url;
  }

  public void setUrl(@Nullable String url) {
    this.url = url;
  }

  @Nullable
  public String getMethod() {
    return method;
  }

  public void setMethod(@Nullable String method) {
    this.method = method;
  }

  @Nullable
  public byte[] getBody() {
    return body;
  }

  public void setBody(@Nullable byte[] body) {
    this.body = body;
  }

  @Nullable
  public Map<String, String> getHeaders() {
    return headers;
  }

  public void setHeaders(@Nullable Map<String, String> headers) {
    this.headers = headers;
  }

  @Nullable
  public Double getTimeoutInterval() {
    return timeoutInterval;
  }

  public void setTimeoutInterval(@Nullable Double timeoutInterval) {
    this.timeoutInterval = timeoutInterval;
  }

  @Override
  public boolean equals(Object o) {
    if (this == o) return true;
    if (o == null || getClass() != o.getClass()) return false;

    URLRequest that = (URLRequest) o;

    if (url != null ? !url.equals(that.url) : that.url != null) return false;
    if (method != null ? !method.equals(that.method) : that.method != null) return false;
    if (!Arrays.equals(body, that.body)) return false;
    if (headers != null ? !headers.equals(that.headers) : that.headers != null) return false;
    return timeoutInterval != null ? timeoutInterval.equals(that.timeoutInterval) : that.timeoutInterval == null;
  }

  @Override
  public int hashCode() {
    int result = url != null ? url.hashCode() : 0;
    result = 31 * result + (method != null ? method.hashCode() : 0);
    result = 31 * result + Arrays.hashCode(body);
    result = 31 * result + (headers != null ? headers.hashCode() : 0);
    result = 31 * result + (timeoutInterval != null ? timeoutInterval.hashCode() : 0);
    return result;
  }

  @Override
  public String toString() {
    return "URLRequest{" +
            "url='" + url + '\'' +
            ", method='" + method + '\'' +
            ", body=" + Arrays.toString(body) +
            ", headers=" + headers +
            ", timeoutInterval=" + timeoutInterval +
            '}';
  }
}
