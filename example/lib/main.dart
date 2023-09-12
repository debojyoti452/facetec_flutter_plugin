import 'dart:developer';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_facetec_sdk/flutter_facetec_sdk.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _flutterFacetecSdkPlugin = FlutterFacetecSdk();

  @override
  void initState() {
    super.initState();
    initPlatformState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _flutterFacetecSdkPlugin.setExtrasObserver(listenNativeCalls);
    });
  }

  Future<void> listenNativeCalls(MethodCall call) async {
    log('listenNativeCalls: ${call.method}');
    switch (call.method) {
      case 'onFaceVerifyResponse':
        log('onFaceVerifyResponse called ${call.arguments}');
        break;
      default:
        log('no method handler for method ${call.method}');
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await _flutterFacetecSdkPlugin.getPlatformVersion() ?? 'Unknown platform version';

      await _flutterFacetecSdkPlugin.initialize(licenseKey: 'hello', encryptionKey: 'world');
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    } catch (e) {
      platformVersion = 'Failed to initialize FlutterFacetecSdk.\n$e';
      log(platformVersion);
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: [
            Center(
              child: Text('Running on: $_platformVersion\n'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await _flutterFacetecSdkPlugin.startLiveCheckProcess();
                } catch (e) {
                  log('Failed to start live check process.\n$e');
                }
              },
              child: const Text('Start Live Check Process'),
            ),
          ],
        ),
      ),
    );
  }
}
