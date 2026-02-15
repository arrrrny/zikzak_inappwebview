import 'dart:async';
import 'package:zikzak_inappwebview_platform_interface/zikzak_inappwebview_platform_interface.dart';

class FindInteractionControllerWeb extends PlatformFindInteractionController {
  FindInteractionControllerWeb(
      PlatformFindInteractionControllerCreationParams params)
      : super.implementation(params);

  @override
  Future<void> findAll({String? find}) async {
    // Not implemented for web
  }

  @override
  Future<void> findNext({bool forward = true}) async {
    // Not implemented for web
  }

  @override
  Future<void> clearMatches() async {
    // Not implemented for web
  }

  @override
  Future<void> setSearchText(String? searchText) async {
    // Not implemented for web
  }
}
