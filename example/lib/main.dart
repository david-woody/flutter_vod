import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';

import 'package:flutter_vod/fluvod.dart' as fluvod;
import 'package:image_picker/image_picker.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _signature = 'Unknown';
  String _result = 'Unknown';
  String _uploadResult = 'Unknown';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getSignature();
      await initVod(_signature);
    });
  }

  Future<void> getSignature({requestUrl, httpServerAddr}) async {
    String signatue;
    try {
      signatue = await fluvod.getSignature(
          httpServerAddr:
          httpServerAddr ?? "http://demo.vod2.myqcloud.com/shortvideo",
          requestUrl: requestUrl ?? "api/v1/misc/upload/signature");
    } on Exception {}
    if (!mounted) return;
    setState(() {
      _signature = signatue;
    });
  }

  Future<void> initVod(_sign) async {
    String result;
    try {
      result = await fluvod.initVod(signature: _sign);
    } on PlatformException {
      result = 'Failed to init.';
    }
    if (!mounted) return;
    setState(() {
      _result = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin Tencent Vod app'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Text(
                'GetSignature on:',
                style: TextStyle(fontSize: 16,),
              ),
              Text(
                '$_signature\n',
              ),
              Text(
                'Init Vod result:',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                '$_result\n',
              ),
              Text(
                'Upload result:',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                '$_uploadResult\n',
              ),
              FlatButton(
                onPressed: _getVideo,
                child: Text("Upload"),
                textColor: Colors.black,
                color: Colors.transparent,
                disabledTextColor: Colors.white,
                disabledColor: Colors.grey,
                shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(18.0),
                    side: BorderSide(
                      color: Colors.blue,
                      width: 0.8,
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }

  _getVideo() async {
    var image = await ImagePicker.pickVideo(source: ImageSource.camera)
        .then((File f) async {
      if (f != null) {
        print('选取视频：' + f.path);
        await fluvod
            .uploadVideo(videoPath: f.path, signature: _signature)
            .then((data) async {
          print('上传视频路径：');
          print(data.runtimeType);
          print(data.toString());
          Map map = new Map<String, dynamic>.from(data);
          print(map['url']);
          print(map["fileId"]);
          if (!mounted) return;
          setState(() {
            _uploadResult = map.toString();
          });
        });
      }
    });
  }
}
