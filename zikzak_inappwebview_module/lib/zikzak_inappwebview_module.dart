/// Value-add module for zikzak_inappwebview.
///
/// This package owns the intelligence layer (pool, capture, VCR, dialogue
/// dismisser, recipes, navigation tracker, agent tools) that consumes only
/// the plugin core public API.
library;

// Ports (abstract interfaces)
export 'src/ports/webview_session_factory.dart';
export 'src/ports/capture_source.dart';
export 'src/ports/cassette_engine.dart';
export 'src/ports/dialogue_dismiss_port.dart';
export 'src/ports/recipe_port.dart';
export 'src/ports/navigation_tracker_port.dart';

// Services (concrete implementations)
export 'src/services/webview_pool.dart';
export 'src/services/capture_service.dart';

// Models (shared data types)
export 'src/models/pool_session.dart';
export 'src/models/cassette.dart';

// VCR
export 'src/vcr/cassette_engine_impl.dart';
