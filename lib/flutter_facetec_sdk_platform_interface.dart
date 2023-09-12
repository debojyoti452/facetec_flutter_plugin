import 'package:flutter/services.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_facetec_sdk_method_channel.dart';

abstract class FlutterFacetecSdkPlatform extends PlatformInterface {
  /// Constructs a FlutterFacetecSdkPlatform.
  FlutterFacetecSdkPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterFacetecSdkPlatform _instance = MethodChannelFlutterFacetecSdk();

  /// The default instance of [FlutterFacetecSdkPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterFacetecSdk].
  static FlutterFacetecSdkPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterFacetecSdkPlatform] when
  /// they register themselves.
  static set instance(FlutterFacetecSdkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> initialize({required String licenseKey, required String encryptionKey}) {
    throw UnimplementedError('initialize() has not been implemented.');
  }

  Future<void> startLiveCheckProcess() {
    throw UnimplementedError('startLiveCheckProcess() has not been implemented.');
  }

  void setExtrasObserver(Future<void> Function(MethodCall call) nativeObserver) {
    throw UnimplementedError('setExtrasObserver() has not been implemented.');
  }
}
