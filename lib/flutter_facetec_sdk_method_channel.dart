import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_facetec_sdk_platform_interface.dart';

/// An implementation of [FlutterFacetecSdkPlatform] that uses method channels.
class MethodChannelFlutterFacetecSdk extends FlutterFacetecSdkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_facetec_sdk');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<void> initialize({required String licenseKey, required String encryptionKey}) {
    return methodChannel.invokeMethod<void>('initialize', <String, dynamic>{
      'licenseKey': licenseKey,
      'encryptionKey': encryptionKey,
    });
  }

  @override
  Future<void> startLiveCheckProcess() {
    return methodChannel.invokeMethod<void>('startLiveCheckProcess');
  }
}
