
import 'flutter_facetec_sdk_platform_interface.dart';

class FlutterFacetecSdk {
  Future<String?> getPlatformVersion() {
    return FlutterFacetecSdkPlatform.instance.getPlatformVersion();
  }

  Future<void> initialize({required String licenseKey, required String encryptionKey}) {
    return FlutterFacetecSdkPlatform.instance.initialize(licenseKey: licenseKey, encryptionKey: encryptionKey);
  }

  Future<void> startLiveCheckProcess() {
    return FlutterFacetecSdkPlatform.instance.startLiveCheckProcess();
  }
}
