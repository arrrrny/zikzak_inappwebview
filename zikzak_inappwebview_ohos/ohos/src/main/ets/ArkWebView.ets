import { FlutterPluginBinding, MethodChannel, MethodCall, MethodResult } from '@ohos/flutter_ohos';
import StandardMessageCodec from '@ohos/flutter_ohos/src/main/ets/plugin/common/StandardMessageCodec';
import PlatformView, { Params } from '@ohos/flutter_ohos/src/main/ets/plugin/platform/PlatformView';
import PlatformViewFactory from '@ohos/flutter_ohos/src/main/ets/plugin/platform/PlatformViewFactory';
import { common } from '@kit.AbilityKit';
import { webview } from '@kit.ArkWeb';
import { picker } from '@kit.CoreFileKit';
import { cameraPicker, camera } from '@kit.CameraKit';
import { UIContext, FrameCallback } from '@ohos.arkui.UIContext';

interface WebSettings {
  javaScriptEnabled?: boolean;
  userAgent?: string;
  supportZoom?: boolean;
  useWideViewPort?: boolean;
  mixedContentMode?: number;
  forceDark?: number;
  algorithmicDarkeningAllowed?: boolean;
  mediaPlaybackRequiresUserGesture?: boolean;
  transparentBackground?: boolean;
}
interface UserScript {
  source: string;
  injectionTime: number;
  groupName?: string;
  allowedOriginRules?: string[];
  forMainFrameOnly?: boolean;
  contentWorld?: ContentWorld;
}
interface ContentWorld { name: string; }
interface UrlRequest { url?: string; method?: string; body?: number[]; headers?: Record<string, string>; }
interface HtmlData { data: string; mimeType?: string; encoding?: string; baseUrl?: string; historyUrl?: string; }
interface CreationArguments {
  settings?: WebSettings;
  scripts?: UserScript[];
  initialUrlRequest?: UrlRequest;
  initialData?: HtmlData;
  initialFile?: string;
  interceptNavigation: boolean;
}
interface SourceArguments { source: string; }
interface FileArguments { assetFilePath: string; }
interface JsCall { handlerName: string; args: Object[]; callId: number; documentId: string; }
interface WebEvent {
  url?: string;
  method?: string;
  headers?: Record<string, string>;
  isMainFrame?: boolean;
  progress?: number;
  title?: string;
  isReload?: boolean;
  message?: string;
  level?: number;
  description?: string;
  statusCode?: number;
  origin?: string;
  resources?: string[];
  handlerName?: string;
  args?: Object[];
}
interface Completion { resolve: () => void; reject: (error: Error) => void; }

class ConfigurationFrame extends FrameCallback {
  private view: ArkWebView;
  constructor(view: ArkWebView) { super(); this.view = view; }
  onIdle(_timeLeftInNano: number): void { this.view.configurationApplied(); }
}

const BRIDGE = `(() => {
  if(window!==window.top) return;
  const documentId = Array.from(crypto.getRandomValues(new Uint32Array(4))).join('-');
  let sequence = 0;
  const pending = new Map();
  const callHandler = (handlerName, ...args) => new Promise((resolve,reject) => {
    const callId = ++sequence;
    pending.set(callId,{resolve,reject});
    try { globalThis.__zikzakArkWeb.callHandler(JSON.stringify({handlerName,args,callId,documentId})); }
    catch(error) { pending.delete(callId); reject(error); }
  });
  globalThis.__zikzakArkWebReply = (owner,id,success,value) => {
    if(owner!==documentId) return;
    const operation=pending.get(id);
    if(!operation) return;
    pending.delete(id);
    if(success) operation.resolve(JSON.parse(value));
    else operation.reject(new Error(value));
  };
  globalThis.zikzak_inappwebview = {callHandler};
  window.dispatchEvent(new Event('flutterInAppWebViewPlatformReady'));
})();`;

@Observed
export class ArkWebState {
  settings: WebSettings = {};
  scripts: UserScript[] = [];
  revision = 0;
  disposed = false;
  view: ArkWebView;
  constructor(view: ArkWebView, settings: WebSettings, scripts: UserScript[]) {
    this.view = view;
    this.settings = settings;
    this.scripts = scripts;
  }
  documentScripts(time: number): ScriptItem[] {
    const items: ScriptItem[] = time === 0 ? [{script: BRIDGE, scriptRules: ['*']}] : [];
    for (const script of this.scripts) {
      if (script.injectionTime !== time) continue;
      items.push({
        script: script.forMainFrameOnly === false ? script.source : `if (window === window.top) {\n${script.source}\n}`,
        scriptRules: script.allowedOriginRules ?? ['*']
      });
    }
    return items;
  }
}

export class ArkWebFactory extends PlatformViewFactory {
  private views = new Set<ArkWebView>();
  private binding: FlutterPluginBinding;
  constructor(binding: FlutterPluginBinding) {
    super(StandardMessageCodec.INSTANCE);
    this.binding = binding;
  }
  create(context: common.Context, id: number, args: Object): PlatformView {
    let view: ArkWebView;
    view = new ArkWebView(context, this.binding, id, JSON.parse(args as string) as CreationArguments, () => this.views.delete(view));
    this.views.add(view);
    return view;
  }
  dispose(): void {
    for (const view of this.views) view.dispose();
    this.views.clear();
  }
}

export class ArkWebView extends PlatformView {
  readonly controller = new webview.WebviewController();
  readonly model: ArkWebState;
  private channel: MethodChannel;
  private initial: CreationArguments;
  private initialStarted = false;
  private navigationGeneration = 0;
  private attached = false;
  private initialPageLoaded = false;
  private readyCompletions: Completion[] = [];
  private configurationCompletions: Completion[] = [];
  private binding: FlutterPluginBinding;
  private onDispose: () => void;
  private uiContext: UIContext | null = null;

  constructor(context: common.Context, binding: FlutterPluginBinding, id: number,
    args: CreationArguments, onDispose: () => void) {
    super();
    this.binding = binding;
    this.initial = args;
    this.onDispose = onDispose;
    this.model = new ArkWebState(this, args.settings ?? {}, args.scripts ?? []);
    this.channel = new MethodChannel(binding.getBinaryMessenger(), `wtf.zikzak/arkweb_${id}`);
    this.channel.setMethodCallHandler({onMethodCall: (call: MethodCall, result: MethodResult): void => {
      this.handle(call, result);
    }});
  }

  getType(): string { return 'web'; }
  getView(): WrappedBuilder<[Params]> { return new WrappedBuilder(ArkWebBuilder); }

  // `mixedContentModeToWire(value) => value?.index`, and the interface's enum
  // order is ALWAYS_ALLOW = 0, NEVER_ALLOW = 1, COMPATIBILITY_MODE = 2. Index 1
  // is the documented most-secure value, so it must map to `MixedMode.None` —
  // treating every non-zero index as `Compatible` (the old ternary) silently
  // downgraded the strictest setting to a permissive one.
  private mixedMode(mode: number | undefined): MixedMode {
    switch (mode) {
      case 1: return MixedMode.None;
      case 2: return MixedMode.Compatible;
      default: return MixedMode.All;
    }
  }

  onAttached(): void {
    this.attached = true;
  }
  bindUIContext(context: UIContext): void { this.uiContext = context; }
  onPageEnd(url: string): void {
    // Controller attachment precedes ArkUI's initial src load. Releasing
    // imperative loads earlier lets that declarative blank page overwrite them.
    this.initialPageLoaded = true;
    for (const completion of this.readyCompletions) completion.resolve();
    this.readyCompletions = [];
    this.emit('onLoadStop', {url: url});
  }
  private ready(): Promise<void> {
    if (this.model.disposed) return Promise.reject(new Error('WebView was disposed'));
    if (this.attached && this.initialPageLoaded) return Promise.resolve();
    return new Promise<void>((resolve, reject) => { this.readyCompletions.push({resolve, reject}); });
  }
  configurationApplied(): void {
    const completions = this.configurationCompletions;
    this.configurationCompletions = [];
    for (const completion of completions) completion.resolve();
  }
  private updateConfiguration(): Promise<void> {
    // Without a UI context there is no frame to wait for: registering a
    // completion here would leave the Dart `await` pending forever, since the
    // frame callback that resolves it is never posted.
    if (this.uiContext == null) return Promise.resolve();
    return new Promise<void>((resolve, reject) => {
      this.configurationCompletions.push({resolve, reject});
      this.model.revision++;
      this.uiContext!.postFrameCallback(new ConfigurationFrame(this));
    });
  }
  emit(method: string, data: WebEvent): void {
    if (!this.model.disposed && this.initialStarted) this.channel.invokeMethod(method, JSON.stringify(data));
  }
  async ask(method: string, data: WebEvent): Promise<Object | null> {
    if (this.model.disposed) throw new Error('WebView was disposed');
    return new Promise<Object | null>((resolve, reject) => {
      this.channel.invokeMethod(method, JSON.stringify(data), {
        success: (value: Object) => {
          if (this.model.disposed) reject(new Error('WebView was disposed'));
          else resolve(value);
        },
        error: (code: string, message: string) => reject(new Error(message)),
        notImplemented: () => reject(new Error(`No callback registered for ${method}`))
      });
    });
  }
  callHandler(message: string): string {
    const call: JsCall = JSON.parse(message);
    this.ask('onCallJsHandler', {handlerName: call.handlerName, args: call.args})
      .then((value) => this.replyToJavaScript(call, true, value as string))
      .catch((error: Error) => this.replyToJavaScript(call, false, error.message));
    return '';
  }
  private async replyToJavaScript(call: JsCall, success: boolean, value: string): Promise<void> {
    if (this.model.disposed) return;
    try {
      // Resolve in a new JS task: a handler may immediately call another
      // native handler, which must not re-enter an active runJavaScript call.
      await this.controller.runJavaScript(`setTimeout(()=>window.__zikzakArkWebReply?.(${JSON.stringify(call.documentId)},${call.callId},${success},${JSON.stringify(value)}),0)`);
    } catch (error) {
      console.error(`ArkWeb JavaScript reply failed: ${(error as Error).message}`);
    }
  }

  navigation(request: WebResourceRequest): boolean {
    // ArkWeb's veto callback is synchronous. Only replay main-frame GETs;
    // POST bodies and subframe targets are not exposed by this native API.
    if (!this.initialStarted || !this.initial.interceptNavigation || !request.isMainFrame() || request.getRequestMethod() !== 'GET') return false;
    const generation = ++this.navigationGeneration;
    const headers: Record<string, string> = {};
    for (const header of request.getRequestHeader()) headers[header.headerKey] = header.headerValue;
    this.ask('shouldOverrideUrlLoading', {
      url: request.getRequestUrl(), method: request.getRequestMethod(), headers: headers,
      isMainFrame: request.isMainFrame()
    }).then((allowed) => {
      if (allowed === true && !this.model.disposed && generation === this.navigationGeneration) {
        this.load({url: request.getRequestUrl(), method: 'GET', headers: headers});
      }
    }).catch((error: Error) => console.error(`ArkWeb navigation callback failed: ${error.message}`));
    return true;
  }

  private load(request: UrlRequest): void {
    this.navigationGeneration++;
    const method = (request.method ?? 'GET').toUpperCase();
    if (method === 'POST') {
      if (request.headers != null && Object.keys(request.headers).length > 0) {
        throw new Error('ArkWeb postUrl cannot attach custom headers');
      }
      this.controller.postUrl(request.url ?? '', new Uint8Array(request.body ?? []).buffer);
    } else if (method === 'GET') {
      const headers: webview.WebHeader[] = [];
      if (request.headers != null) {
        for (const name of Object.keys(request.headers)) headers.push({headerKey: name, headerValue: request.headers[name]});
      }
      this.controller.loadUrl(request.url ?? '', headers);
    } else throw new Error(`ArkWeb loadUrl does not support ${method}`);
  }
  private loadData(data: HtmlData): void {
    this.navigationGeneration++;
    this.controller.loadData(data.data, data.mimeType ?? 'text/html', data.encoding ?? 'utf-8', data.baseUrl, data.historyUrl);
  }
  private loadAsset(path: string): void {
    this.controller.loadUrl($rawfile(this.binding.getFlutterAssets().getAssetFilePathByName(path)));
  }
  private async handle(call: MethodCall, result: MethodResult): Promise<void> {
    try {
      // Only the load family waits for the initial document. ArkUI's
      // declarative `Web({src: 'about:blank'})` load begins when the component
      // builds, and an imperative load issued before that finishes is
      // overwritten by it — which is why loads stay gated. Every other method
      // answers straight from the controller: gating them would let a hanging
      // initial navigation block `stopLoading`, i.e. the one call that could
      // abort the very navigation it is waiting on. A controller that is not
      // attached yet reports a native error through `result`.
      if (call.method.startsWith('load') || call.method === 'postUrl' || call.method === 'startInitialLoad') {
        await this.ready();
      } else if (this.model.disposed) {
        throw new Error('WebView was disposed');
      }
      switch (call.method) {
        case 'startInitialLoad':
          if (!this.initialStarted) {
            this.initialStarted = true;
            if (this.initial.initialUrlRequest != null) this.load(this.initial.initialUrlRequest);
            else if (this.initial.initialData != null) this.loadData(this.initial.initialData);
            else if (this.initial.initialFile != null) this.loadAsset(this.initial.initialFile);
          }
          break;
        case 'loadUrl':
          this.initialStarted = true;
          this.load(JSON.parse(call.args as string) as UrlRequest);
          break;
        case 'postUrl':
          this.initialStarted = true;
          const post: UrlRequest = JSON.parse(call.args as string);
          post.method = 'POST';
          this.load(post);
          break;
        case 'loadData':
          this.initialStarted = true;
          this.loadData(JSON.parse(call.args as string) as HtmlData);
          break;
        case 'loadFile':
          this.initialStarted = true;
          this.loadAsset((JSON.parse(call.args as string) as FileArguments).assetFilePath);
          break;
        case 'getUrl': result.success(this.controller.getUrl()); return;
        case 'getTitle': result.success(this.controller.getTitle()); return;
        case 'canGoBack': result.success(this.controller.accessBackward()); return;
        case 'canGoForward': result.success(this.controller.accessForward()); return;
        case 'goBack': this.navigationGeneration++; this.controller.backward(); break;
        case 'goForward': this.navigationGeneration++; this.controller.forward(); break;
        case 'reload': this.navigationGeneration++; this.controller.refresh(); break;
        case 'stopLoading': this.controller.stop(); break;
        case 'evaluateJavascript':
          result.success(await this.controller.runJavaScript((JSON.parse(call.args as string) as SourceArguments).source));
          return;
        case 'setSettings': {
          const settings: WebSettings = JSON.parse(call.args as string);
          this.model.settings = settings;
          if (settings.userAgent != null) this.controller.setCustomUserAgent(settings.userAgent);
          await this.updateConfiguration();
          break;
        }
        case 'getSettings': result.success(JSON.stringify(this.model.settings)); return;
        case 'addUserScript': {
          const script: UserScript = JSON.parse(call.args as string);
          if (script.contentWorld != null && script.contentWorld.name !== 'page') throw new Error('Isolated content worlds are not implemented');
          this.model.scripts = this.model.scripts.concat([script]);
          await this.updateConfiguration();
          break;
        }
        case 'removeUserScript': {
          const script: UserScript = JSON.parse(call.args as string);
          const index = this.model.scripts.findIndex((item: UserScript) => item.source === script.source && item.injectionTime === script.injectionTime && item.groupName === script.groupName);
          if (index < 0) { result.success(false); return; }
          this.model.scripts = this.model.scripts.filter((_item: UserScript, itemIndex: number) => itemIndex !== index);
          await this.updateConfiguration();
          result.success(true);
          return;
        }
        case 'removeAllUserScripts':
          this.model.scripts = [];
          await this.updateConfiguration();
          break;
        case 'dispose':
          // The Dart controller can be disposed on its own, apart from the
          // platform-view lifecycle; without this the native WebView stays
          // attached and keeps loading.
          this.dispose();
          break;
        default: result.notImplemented(); return;
      }
      result.success(null);
    } catch (error) {
      result.error('ARKWEB_ERROR', (error as Error).message, null);
    }
  }

  dispose(): void {
    if (this.model.disposed) return;
    this.model.disposed = true;
    this.channel.setMethodCallHandler(null);
    for (const completion of this.readyCompletions.concat(this.configurationCompletions)) completion.reject(new Error('WebView was disposed'));
    this.readyCompletions = [];
    this.configurationCompletions = [];
    if (this.attached) {
      this.controller.deleteJavaScriptRegister('__zikzakArkWeb');
      this.controller.stop();
    }
    this.onDispose();
  }
}

@Component
struct ArkWebComponent {
  @ObjectLink model: ArkWebState;
  aboutToAppear(): void { this.model.view.bindUIContext(this.getUIContext()); }
  build() {
    Column() {
      if (!this.model.disposed) {
        Web({src: 'about:blank', controller: this.model.view.controller})
          .javaScriptAccess(this.model.settings.javaScriptEnabled ?? true)
          .domStorageAccess(true)
          .zoomAccess(this.model.settings.supportZoom ?? true)
          .wideViewModeAccess(this.model.settings.useWideViewPort ?? true)
          .metaViewport(this.model.settings.useWideViewPort ?? true)
          // ArkWeb exposes no declarative page-zoom attribute, and
          // `textZoom` is not part of `InAppWebViewSettings` at all (the
          // interface has `pageZoom`, whose CSS-`zoom` semantics differ from
          // Android's accessibility `textZoom`). Neither is mapped here rather
          // than silently pretending to be.
          .mixedMode(this.mixedMode(this.model.settings.mixedContentMode))
          .darkMode(this.model.settings.forceDark === 2 ? WebDarkMode.On : WebDarkMode.Off)
          .forceDarkAccess(this.model.settings.algorithmicDarkeningAllowed ?? false)
          .mediaPlayGestureAccess(this.model.settings.mediaPlaybackRequiresUserGesture ?? true)
          .backgroundColor(this.model.settings.transparentBackground ? Color.Transparent : Color.White)
          .runJavaScriptOnDocumentStart(this.model.documentScripts(0))
          .runJavaScriptOnDocumentEnd(this.model.documentScripts(1))
          .javaScriptProxy({object: this.model.view, name: '__zikzakArkWeb', methodList: ['callHandler'], controller: this.model.view.controller})
          .onControllerAttached(() => {
            const agent = this.model.settings.userAgent;
            if (agent != null) this.model.view.controller.setCustomUserAgent(agent);
            this.model.view.onAttached();
          })
          .onPageBegin((event) => this.model.view.emit('onLoadStart', {url: event?.url ?? ''}))
          .onPageEnd((event) => this.model.view.onPageEnd(event?.url ?? ''))
          .onProgressChange((event) => this.model.view.emit('onProgressChanged', {progress: event?.newProgress ?? 0}))
          .onTitleReceive((event) => this.model.view.emit('onTitleChanged', {title: event?.title ?? ''}))
          .onRefreshAccessedHistory((event) => this.model.view.emit('onUpdateVisitedHistory', {url: event?.url ?? '', isReload: event?.isRefreshed ?? false}))
          .onConsole((event) => {
            this.model.view.emit('onConsoleMessage', {message: event?.message.getMessage() ?? '', level: event?.message.getMessageLevel() ?? 0});
            return false;
          })
          .onErrorReceive((event) => {
            if (event != null) this.model.view.emit('onReceivedError', {url: event.request.getRequestUrl(), isMainFrame: event.request.isMainFrame(), description: event.error.getErrorInfo()});
          })
          .onHttpErrorReceive((event) => {
            if (event != null) this.model.view.emit('onReceivedHttpError', {url: event.request.getRequestUrl(), isMainFrame: event.request.isMainFrame(), statusCode: event.response.getResponseCode()});
          })
          .onOverrideUrlLoading((request) => this.model.view.navigation(request))
          .onPermissionRequest((event) => {
            if (event == null) return;
            const request = event.request;
            this.model.view.ask('onPermissionRequest', {origin: request.getOrigin(), resources: request.getAccessibleResource()})
              .then((resources) => {
                const granted = resources as string[];
                if (granted.length > 0) request.grant(granted);
                else request.deny();
              }).catch(() => request.deny());
          })
          .onGeolocationShow((event) => {
            if (event == null) return;
            this.model.view.ask('onGeolocationPermissionsShowPrompt', {origin: event.origin})
              .then((allowed) => event.geolocation.invoke(event.origin, allowed === true, false))
              .catch(() => event.geolocation.invoke(event.origin, false, false));
          })
          .onShowFileSelector((event) => {
            if (event == null) return false;
            const context = getContext(this) as common.UIAbilityContext;
            const types = event.fileSelector.getAcceptType();
            if (event.fileSelector.isCapture() && types.some((type: string) => type.startsWith('image/'))) {
              cameraPicker.pick(context, [cameraPicker.PickerMediaType.PHOTO], {cameraPosition: camera.CameraPosition.CAMERA_POSITION_BACK})
                .then((result) => event.result.handleFileList(result.resultUri.length > 0 ? [result.resultUri] : []))
                .catch(() => event.result.handleFileList([]));
              return true;
            }
            const options = new picker.DocumentSelectOptions();
            options.maxSelectNumber = event.fileSelector.getMode() === 1 ? 100 : 1;
            const extensions = types.filter((type: string) => type.startsWith('.'));
            if (extensions.length > 0) options.fileSuffixFilters = [extensions.join(',')];
            const documentPicker = new picker.DocumentViewPicker(context);
            documentPicker.select(options).then((uris) => event.result.handleFileList(uris))
              .catch(() => event.result.handleFileList([]));
            return true;
          })
          .onSslErrorEventReceive((event) => event?.handler.handleCancel())
          .width('100%').height('100%')
      }
    }.width('100%').height('100%')
  }
}

@Builder
export function ArkWebBuilder(params: Params) {
  ArkWebComponent({model: (params.platformView as ArkWebView).model})
}
