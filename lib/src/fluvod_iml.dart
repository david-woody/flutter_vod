import 'package:flutter/services.dart';

final MethodChannel _channel = const MethodChannel('com.uni4m/flutter_vod')
  ..setMethodCallHandler(_handler);

Future<dynamic> _handler(MethodCall methodCall) {
  if ("initVod" == methodCall.method) {
  } else if ("onAuthResponse" == methodCall.method) {
  } else if ("onLaunchMiniProgramResponse" == methodCall.method) {}

  return Future.value(true);
}

Future initVod({String signature}) async {
  return await _channel
      .invokeMethod("initVod", {"signature": signature});
}

Future getSignature({String requestUrl, String httpServerAddr}) async {
  return await _channel
      .invokeMethod("getSignature", {"requestUrl": requestUrl, "httpServerAddr": httpServerAddr});
}

Future uploadVideo({String videoPath,String signature}) async {
  return await _channel.invokeMethod("uploadVideo", {"videoPath": videoPath,"signature": signature});
}
