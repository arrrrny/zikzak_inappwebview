// dart format width=80
// ignore_for_file: UNNECESSARY_CAST
// ignore_for_file: type=lint

part of 'navigation_response.dart';

// **************************************************************************
// ZorphyGenerator
// **************************************************************************

@JsonSerializable(explicitToJson: true, checked: true)
class NavigationResponse {
  NavigationResponse({
    URLResponse? this.response,
    required bool this.isForMainFrame,
    required bool this.canShowMIMEType,
  });

  factory NavigationResponse.fromJson(Map<String, dynamic> json) =>
      _$NavigationResponseFromJson(json);

  @JsonKey(toJson: _responseToJson, fromJson: _responseFromJson)
  final URLResponse? response;

  final bool isForMainFrame;

  final bool canShowMIMEType;

  NavigationResponse copyWith({
    URLResponse? response,
    bool? isForMainFrame,
    bool? canShowMIMEType,
  }) {
    return NavigationResponse(
      response: response ?? this.response,
      isForMainFrame: isForMainFrame ?? this.isForMainFrame,
      canShowMIMEType: canShowMIMEType ?? this.canShowMIMEType,
    );
  }

  NavigationResponse copyWithNavigationResponse({
    URLResponse? response,
    bool? isForMainFrame,
    bool? canShowMIMEType,
  }) {
    return copyWith(
      response: response,
      isForMainFrame: isForMainFrame,
      canShowMIMEType: canShowMIMEType,
    );
  }

  NavigationResponse patchWithNavigationResponse([
    NavigationResponsePatch? patchInput,
  ]) {
    final _patcher = patchInput ?? NavigationResponsePatch();
    final _patchMap = _patcher.patchMap;
    return NavigationResponse(
      response: _patchMap.containsKey(NavigationResponse$.response)
          ? (_patchMap[NavigationResponse$.response] is Function)
                ? _patchMap[NavigationResponse$.response](this.response)
                : (_patchMap[NavigationResponse$.response] is Patch)
                ? _patchMap[NavigationResponse$.response].applyTo(this.response)
                : _patchMap[NavigationResponse$.response]
          : this.response,
      isForMainFrame: _patchMap.containsKey(NavigationResponse$.isForMainFrame)
          ? (_patchMap[NavigationResponse$.isForMainFrame] is Function)
                ? _patchMap[NavigationResponse$.isForMainFrame](
                    this.isForMainFrame,
                  )
                : (_patchMap[NavigationResponse$.isForMainFrame] is Patch)
                ? _patchMap[NavigationResponse$.isForMainFrame].applyTo(
                    this.isForMainFrame,
                  )
                : _patchMap[NavigationResponse$.isForMainFrame]
          : this.isForMainFrame,
      canShowMIMEType:
          _patchMap.containsKey(NavigationResponse$.canShowMIMEType)
          ? (_patchMap[NavigationResponse$.canShowMIMEType] is Function)
                ? _patchMap[NavigationResponse$.canShowMIMEType](
                    this.canShowMIMEType,
                  )
                : (_patchMap[NavigationResponse$.canShowMIMEType] is Patch)
                ? _patchMap[NavigationResponse$.canShowMIMEType].applyTo(
                    this.canShowMIMEType,
                  )
                : _patchMap[NavigationResponse$.canShowMIMEType]
          : this.canShowMIMEType,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NavigationResponse &&
        response == other.response &&
        isForMainFrame == other.isForMainFrame &&
        canShowMIMEType == other.canShowMIMEType;
  }

  @override
  int get hashCode {
    return Object.hash(
      this.response,
      this.isForMainFrame,
      this.canShowMIMEType,
    );
  }

  @override
  String toString() {
    return 'NavigationResponse(' +
        'response: ${response}' +
        ', ' +
        'isForMainFrame: ${isForMainFrame}' +
        ', ' +
        'canShowMIMEType: ${canShowMIMEType})';
  }

  Map<String, dynamic> toJsonLean() {
    final Map<String, dynamic> data = _$NavigationResponseToJson(this);
    return _sanitizeJson(data);
  }

  dynamic _sanitizeJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      json.remove('__typename');
      return json..forEach((key, value) {
        json[key] = _sanitizeJson(value);
      });
    } else if (json is List) {
      return json.map((e) => _sanitizeJson(e)).toList();
    }
    return json;
  }
}

extension NavigationResponsePropertyHelpers on NavigationResponse {
  bool get hasResponse {
    return this.response != null;
  }

  bool get noResponse {
    return this.response == null;
  }

  URLResponse get responseRequired {
    return this.response ??
        (throw StateError('response is required but was null'));
  }
}

extension NavigationResponseSerialization on NavigationResponse {
  Map<String, dynamic> toJson() {
    return _$NavigationResponseToJson(this);
  }
}

enum NavigationResponse$ { response, isForMainFrame, canShowMIMEType }

class NavigationResponsePatch
    extends PatchBase<NavigationResponse, NavigationResponse$> {
  NavigationResponse applyTo(NavigationResponse entity) {
    return entity.patchWithNavigationResponse(this);
  }

  NavigationResponsePatch withResponse(URLResponse? value) {
    patchMap[NavigationResponse$.response] = value;
    return this;
  }

  NavigationResponsePatch withResponsePatch(URLResponsePatch patch) {
    patchMap[NavigationResponse$.response] = patch;
    return this;
  }

  NavigationResponsePatch withResponsePatchFunc(
    URLResponsePatch Function(URLResponsePatch) patch,
  ) {
    patchMap[NavigationResponse$.response] = (dynamic current) {
      var currentPatch = URLResponsePatch();
      return patch(currentPatch).applyTo(current as URLResponse);
    };
    return this;
  }

  NavigationResponsePatch withIsForMainFrame(bool? value) {
    patchMap[NavigationResponse$.isForMainFrame] = value;
    return this;
  }

  NavigationResponsePatch withCanShowMIMEType(bool? value) {
    patchMap[NavigationResponse$.canShowMIMEType] = value;
    return this;
  }
}

/// Field descriptors for [NavigationResponse] query construction
abstract final class NavigationResponseFields {
  static const response = Field<NavigationResponse, URLResponse?>(
    'response',
    _$response,
  );

  static const isForMainFrame = Field<NavigationResponse, bool>(
    'isForMainFrame',
    _$isForMainFrame,
  );

  static const canShowMIMEType = Field<NavigationResponse, bool>(
    'canShowMIMEType',
    _$canShowMIMEType,
  );

  static URLResponse? _$response(NavigationResponse e) {
    return e.response;
  }

  static bool _$isForMainFrame(NavigationResponse e) {
    return e.isForMainFrame;
  }

  static bool _$canShowMIMEType(NavigationResponse e) {
    return e.canShowMIMEType;
  }
}

extension NavigationResponseCompareE on NavigationResponse {
  Map<String, dynamic> compareToNavigationResponse(NavigationResponse other) {
    final Map<String, dynamic> diff = {};

    if (response != other.response) {
      diff['response'] = () => other.response;
    }

    if (isForMainFrame != other.isForMainFrame) {
      diff['isForMainFrame'] = () => other.isForMainFrame;
    }

    if (canShowMIMEType != other.canShowMIMEType) {
      diff['canShowMIMEType'] = () => other.canShowMIMEType;
    }
    return diff;
  }
}
