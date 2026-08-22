import 'package:zorphy_annotation/zorphy_annotation.dart';
import '../enums/renderer_priority.dart';

part 'render_process_gone_detail.zorphy.dart';
part 'render_process_gone_detail.g.dart';

///Class that provides more specific information about why the render process exited.
///It is used by the [PlatformWebViewCreationParams.onRenderProcessGone] event.
@Zorphy(
  kind: ZorphyKind.valueObject,
  generateJson: true,
  generateCompareTo: true,
)
abstract class $RenderProcessGoneDetail {
  ///Indicates whether the render process was observed to crash, or whether it was killed by the system.
  ///
  ///If the render process was killed, this is most likely caused by the system being low on memory.
  bool get didCrash;

  ///Returns the renderer priority that was set at the time that the renderer exited. This may be greater than the priority that
  ///any individual `WebView` requested using [].
  @JsonKey(
    fromJson: _rendererPriorityAtExitFromJson,
    toJson: _rendererPriorityAtExitToJson,
  )
  RendererPriority? get rendererPriorityAtExit;
}

RendererPriority? _rendererPriorityAtExitFromJson(Object? value) =>
    rendererPriorityFromWire(value);

Object? _rendererPriorityAtExitToJson(RendererPriority? value) =>
    rendererPriorityToWire(value);
