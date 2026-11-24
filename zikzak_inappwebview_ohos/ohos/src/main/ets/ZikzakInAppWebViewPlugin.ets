import { FlutterPlugin, FlutterPluginBinding, MethodCall, MethodChannel, MethodResult } from '@ohos/flutter_ohos';
import { webview } from '@kit.ArkWeb';
import { ArkWebFactory } from './ArkWebView';

interface CookieArguments { url: string; cookie: string; }

export default class ZikzakInAppWebViewPlugin implements FlutterPlugin {
  private cookies: MethodChannel | null = null;
  private factory: ArkWebFactory | null = null;

  getUniqueClassName(): string { return 'ZikzakInAppWebViewPlugin'; }

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    this.factory = new ArkWebFactory(binding);
    binding.getPlatformViewRegistry().registerViewFactory('wtf.zikzak/arkweb', this.factory);
    this.cookies = new MethodChannel(binding.getBinaryMessenger(), 'wtf.zikzak/arkweb_cookies');
    this.cookies.setMethodCallHandler({
      onMethodCall: (call: MethodCall, result: MethodResult): void => {
        this.handleCookies(call, result);
      }
    });
  }

  private async handleCookies(call: MethodCall, result: MethodResult): Promise<void> {
    try {
      switch (call.method) {
        case 'setCookie': {
          const args: CookieArguments = JSON.parse(call.args as string);
          webview.WebCookieManager.configCookieSync(args.url, args.cookie, false, true);
          webview.WebCookieManager.saveCookieSync();
          result.success(true);
          return;
        }
        case 'getAllCookies':
          result.success(JSON.stringify(await webview.WebCookieManager.fetchAllCookies(false)));
          return;
        case 'deleteAllCookies':
          await webview.WebCookieManager.clearAllCookies();
          webview.WebCookieManager.saveCookieSync();
          result.success(true);
          return;
        default:
          result.notImplemented();
      }
    } catch (error) {
      result.error('ARKWEB_COOKIE_ERROR', (error as Error).message, null);
    }
  }

  onDetachedFromEngine(binding: FlutterPluginBinding): void {
    this.cookies?.setMethodCallHandler(null);
    this.cookies = null;
    this.factory?.dispose();
    this.factory = null;
  }
}
