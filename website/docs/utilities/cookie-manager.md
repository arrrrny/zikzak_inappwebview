---
sidebar_position: 1
title: Cookie Manager
---

# Cookie Manager

Manage WebView cookies across your application.

**Platform Support:** Android, iOS

:::info v3.0 Changes
macOS, Windows, and Web platform support has been removed in v3.0.
:::

## Getting Started

`CookieManager` is a singleton object:

```dart
import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';

final cookieManager = CookieManager.instance();
```

## Platform Implementations

- **Android:** Uses native `CookieManager` class
- **iOS:** Implemented via `WKHTTPCookieStore`

## Setting Cookies

```dart
await cookieManager.setCookie(
  url: WebUri('https://example.com'),
  name: 'session_id',
  value: 'abc123xyz',
  domain: '.example.com',
  path: '/',
  expiresDate: DateTime.now().add(Duration(days: 30)).millisecondsSinceEpoch,
  isSecure: true,
  isHttpOnly: true,
  sameSite: HTTPCookieSameSitePolicy.LAX,
);
```

### Cookie Parameters

| Parameter | Type | Description |
|-----------|------|-------------|
| `url` | `WebUri` | The URL to set the cookie for |
| `name` | `String` | Cookie name |
| `value` | `String` | Cookie value |
| `domain` | `String?` | Domain scope (e.g., `.example.com`) |
| `path` | `String` | Path scope (default: `/`) |
| `expiresDate` | `int?` | Expiration timestamp (milliseconds) |
| `maxAge` | `int?` | Max age in seconds |
| `isSecure` | `bool?` | HTTPS only |
| `isHttpOnly` | `bool?` | Not accessible via JavaScript |
| `sameSite` | `HTTPCookieSameSitePolicy?` | SameSite attribute |

## Getting Cookies

### Get All Cookies for URL

```dart
List<Cookie> cookies = await cookieManager.getCookies(
  url: WebUri('https://example.com'),
);

for (var cookie in cookies) {
  print('${cookie.name} = ${cookie.value}');
  print('Domain: ${cookie.domain}');
  print('Path: ${cookie.path}');
  print('Expires: ${cookie.expiresDate}');
  print('Secure: ${cookie.isSecure}');
  print('HttpOnly: ${cookie.isHttpOnly}');
}
```

### Get Specific Cookie

```dart
Cookie? cookie = await cookieManager.getCookie(
  url: WebUri('https://example.com'),
  name: 'session_id',
);

if (cookie != null) {
  print('Cookie value: ${cookie.value}');
}
```

## Deleting Cookies

### Delete Specific Cookie

```dart
await cookieManager.deleteCookie(
  url: WebUri('https://example.com'),
  name: 'session_id',
  domain: '.example.com',
  path: '/',
);
```

### Delete All Cookies for URL

```dart
await cookieManager.deleteCookies(
  url: WebUri('https://example.com'),
  domain: '.example.com',
  path: '/',
);
```

### Delete All Cookies

```dart
await cookieManager.deleteAllCookies();
```

## Complete Example

```dart
import 'package:flutter/material.dart';
import 'package:zikzak_inappwebview/zikzak_inappwebview.dart';

class CookieManagerExample extends StatefulWidget {
  @override
  _CookieManagerExampleState createState() => _CookieManagerExampleState();
}

class _CookieManagerExampleState extends State<CookieManagerExample> {
  final cookieManager = CookieManager.instance();
  final url = WebUri('https://example.com');
  List<Cookie> cookies = [];

  @override
  void initState() {
    super.initState();
    _loadCookies();
  }

  Future<void> _loadCookies() async {
    final loadedCookies = await cookieManager.getCookies(url: url);
    setState(() {
      cookies = loadedCookies;
    });
  }

  Future<void> _setCookie() async {
    await cookieManager.setCookie(
      url: url,
      name: 'test_cookie',
      value: 'test_value_${DateTime.now().millisecondsSinceEpoch}',
      expiresDate: DateTime.now()
          .add(Duration(days: 1))
          .millisecondsSinceEpoch,
      isSecure: true,
    );
    await _loadCookies();
  }

  Future<void> _deleteCookie(String name) async {
    await cookieManager.deleteCookie(
      url: url,
      name: name,
    );
    await _loadCookies();
  }

  Future<void> _deleteAllCookies() async {
    await cookieManager.deleteAllCookies();
    await _loadCookies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cookie Manager'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadCookies,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                ElevatedButton(
                  child: Text('Set Cookie'),
                  onPressed: _setCookie,
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  child: Text('Delete All'),
                  onPressed: _deleteAllCookies,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: cookies.isEmpty
                ? Center(child: Text('No cookies'))
                : ListView.builder(
                    itemCount: cookies.length,
                    itemBuilder: (context, index) {
                      final cookie = cookies[index];
                      return ListTile(
                        title: Text(cookie.name),
                        subtitle: Text(cookie.value),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _deleteCookie(cookie.name),
                        ),
                      );
                    },
                  ),
          ),
          Expanded(
            child: InAppWebView(
              initialUrlRequest: URLRequest(url: url),
              onLoadStop: (controller, url) async {
                // Reload cookies when page loads
                await _loadCookies();
              },
            ),
          ),
        ],
      ),
    );
  }
}
```

## Session Cookies vs Persistent Cookies

### Session Cookies (temporary)

Don't set `expiresDate` or `maxAge`:

```dart
await cookieManager.setCookie(
  url: WebUri('https://example.com'),
  name: 'temp_session',
  value: 'temporary_value',
  // No expiresDate or maxAge - deleted when browser closes
);
```

### Persistent Cookies (saved)

Set an expiration:

```dart
await cookieManager.setCookie(
  url: WebUri('https://example.com'),
  name: 'persistent_token',
  value: 'long_lived_value',
  expiresDate: DateTime.now()
      .add(Duration(days: 365))
      .millisecondsSinceEpoch,
);
```

## SameSite Attribute

Control cookie behavior with third-party requests:

```dart
// Strict: Only sent for same-site requests
await cookieManager.setCookie(
  url: url,
  name: 'strict_cookie',
  value: 'value',
  sameSite: HTTPCookieSameSitePolicy.STRICT,
);

// Lax: Sent for top-level navigation (default, recommended)
await cookieManager.setCookie(
  url: url,
  name: 'lax_cookie',
  value: 'value',
  sameSite: HTTPCookieSameSitePolicy.LAX,
);

// None: Sent with all requests (requires Secure flag)
await cookieManager.setCookie(
  url: url,
  name: 'none_cookie',
  value: 'value',
  sameSite: HTTPCookieSameSitePolicy.NONE,
  isSecure: true, // Required with SameSite=None
);
```

## Best Practices

1. **Use Secure flag for HTTPS** - Always set `isSecure: true` for production
2. **Set HttpOnly for sensitive data** - Prevents JavaScript access
3. **Use appropriate SameSite** - LAX is a good default
4. **Set expiration dates** - Don't rely on session cookies for important data
5. **Validate domains** - Ensure domain matches your app's requirements

## Common Use Cases

### Login Session Management

```dart
// After successful login
await cookieManager.setCookie(
  url: WebUri('https://api.example.com'),
  name: 'auth_token',
  value: loginResponse.token,
  expiresDate: DateTime.now()
      .add(Duration(days: 30))
      .millisecondsSinceEpoch,
  isSecure: true,
  isHttpOnly: true,
  sameSite: HTTPCookieSameSitePolicy.LAX,
);

// After logout
await cookieManager.deleteCookie(
  url: WebUri('https://api.example.com'),
  name: 'auth_token',
);
```

### Preferences Storage

```dart
// Save user preference
await cookieManager.setCookie(
  url: WebUri('https://example.com'),
  name: 'theme',
  value: 'dark',
  expiresDate: DateTime.now()
      .add(Duration(days: 365))
      .millisecondsSinceEpoch,
);

// Load preference
Cookie? themeCookie = await cookieManager.getCookie(
  url: WebUri('https://example.com'),
  name: 'theme',
);
String theme = themeCookie?.value ?? 'light';
```

## Next Steps

- Web Storage Manager (coming soon) - Manage local/session storage
- HTTP Auth Credential Database (coming soon) - HTTP authentication
- [InAppWebView Settings](../webview/in-app-webview) - WebView configuration
