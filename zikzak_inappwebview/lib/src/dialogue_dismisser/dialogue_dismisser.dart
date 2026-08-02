import 'dart:collection';

import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

import '../in_app_webview/in_app_webview_controller.dart';
import 'dialogue_dismiss_rules.dart';
import 'dialogue_dismissal.dart';
import 'dialogue_dismisser_js.dart';

///Signature of the [DialogueDismisser] dismissal callback.
typedef DialogueDismissalCallback = void Function(
  DialogueDismissal dismissal,
);

///Content-aware popup/cookie-banner dismisser.
///
///Unlike the legacy `InAppWebViewSettings.dismissDialogues` (which removes
///EVERY `position: fixed/sticky` element), this dismisser only touches
///overlay candidates whose text content matches the keyword patterns of the
///enabled presets (see [DialogueDismissRules]). Non-matching sticky/fixed
///elements — price banners, nav bars, chat widgets — are never touched.
///
///Architecture mirrors `NavigationTracker`: [maybeCreate] builds the
///dismisser, [mergeUserScripts] composes caller scripts with the dismisser's
///[UserScript], and [attach] registers the `__zikzakDialogueDismissed__`
///JavaScript handler.
///
///The dismisser works without a WebView: [handleJsPayload] operates on a
///plain instance; [attach] only wires the JS bridge.
class DialogueDismisser {
  ///The enabled presets.
  final Set<DialogueDismissPreset> presets;

  final DialogueDismissalCallback? _onDismissal;

  final List<DialogueDismissal> _dismissals = <DialogueDismissal>[];

  InAppWebViewController? _controller;

  DialogueDismisser._({
    required this.presets,
    DialogueDismissalCallback? onDismissal,
  }) : _onDismissal = onDismissal;

  ///Creates a dismisser for [presets]. Returns `null` when [presets] is
  ///empty (nothing to dismiss).
  static DialogueDismisser? maybeCreate({
    required Set<DialogueDismissPreset> presets,
    DialogueDismissalCallback? onDismissal,
  }) {
    if (presets.isEmpty) return null;
    return DialogueDismisser._(
      presets: Set<DialogueDismissPreset>.unmodifiable(presets),
      onDismissal: onDismissal,
    );
  }

  ///Merges the dismisser script into the user-provided scripts.
  ///Returns [userScripts] unchanged when [dismisser] is `null`.
  static UnmodifiableListView<UserScript>? mergeUserScripts(
    List<UserScript>? userScripts,
    DialogueDismisser? dismisser,
  ) {
    if (dismisser == null) {
      return userScripts == null ? null : UnmodifiableListView(userScripts);
    }
    return UnmodifiableListView<UserScript>(<UserScript>[
      ...?userScripts,
      dismisser.buildUserScript(),
    ]);
  }

  ///Builds the dismisser script to add to the initial user scripts.
  ///Main-frame only: consent popups live in the main frame.
  UserScript buildUserScript() {
    return UserScript(
      groupName: 'zikzakDialogueDismisser',
      source: buildDialogueDismisserJs(presets),
      injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START,
      forMainFrameOnly: true,
    );
  }

  ///Dismissals reported so far.
  List<DialogueDismissal> get dismissals => UnmodifiableListView(_dismissals);

  ///Registers the JavaScript handler on [controller] and flushes events the
  ///page buffered before registration. Call from `onWebViewCreated`.
  void attach(InAppWebViewController controller) {
    _controller = controller;
    controller.addJavaScriptHandler(
      handlerName: kDialogueDismissedHandlerName,
      callback: (arguments) {
        if (arguments.isEmpty) return null;
        final raw = arguments[0];
        if (raw is Map) {
          handleJsPayload(Map<String, dynamic>.from(raw));
        }
        return null;
      },
    );
    _flushPageQueue();
  }

  ///Removes the JavaScript handler.
  void detach() {
    final controller = _controller;
    if (controller != null) {
      controller.removeJavaScriptHandler(
        handlerName: kDialogueDismissedHandlerName,
      );
    }
    _controller = null;
  }

  ///Processes a raw payload reported by the dismisser script.
  ///Public so it can be unit-tested without a WebView.
  void handleJsPayload(Map<String, dynamic> payload) {
    final dismissal = DialogueDismissal.fromJson(payload);
    _dismissals.add(dismissal);
    _onDismissal?.call(dismissal);
  }

  Future<void> _flushPageQueue() async {
    final controller = _controller;
    if (controller == null) return;
    try {
      await controller.evaluateJavascript(
        source:
            'window.__zikzakDialogueDismisser__ && window.__zikzakDialogueDismisser__.ready ? window.__zikzakDialogueDismisser__.ready() : 0;',
      );
    } catch (_) {
      // The page may not exist yet or navigation may have aborted.
    }
  }
}
