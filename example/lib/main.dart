import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:atauth_flutter_plugin/aliyun_number_auth.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _showData = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    String sdkInfo;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await AtauthFlutterPlugin.platformVersion;
      sdkInfo = await rootBundle.loadString('key/sdk.key');

      var result = await AtauthFlutterPlugin.initATAuthSDK(sdkInfo: sdkInfo);
      if (result.success) {
        print('初始化成功');
      }

      var result1 = await AtauthFlutterPlugin.checkSDK(type: PNSAuthType.PNSAuthTypeVerifyToken);
      if (result1.success) {
        print('检查当前环境支持 - PNSAuthTypeVerifyToken');
      }

      var result2 = await AtauthFlutterPlugin.checkSDK(type: PNSAuthType.PNSAuthTypeLoginToken);
      if (result2.success) {
        print('检查当前环境支持 - PNSAuthTypeLoginToken');
      }

      var result3 = await AtauthFlutterPlugin.accelerateLoginPage(timeout: 3.0);
      if (result3.success) {
        print('加速成功');
      }



    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _showData = '$platformVersion\n$sdkInfo';
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_showData\n'),
        ),
        floatingActionButton: FloatingActionButton(
          child: Text('登录'),
          onPressed: () async {
            /// 一键登录
            var result3 = await AtauthFlutterPlugin.getLoginToken(timeout: 3.0);
            if (true == result3.token?.isNotEmpty && result3.success) {
              print(result3.token);
              AtauthFlutterPlugin.cancelLogin(flag: true);
            } else if (result3.isUserCanceled){
              print('用户取消');
            } else {
              if (result3.isChooseVerificationCode) {
                //打开验证码登陆
                print('使用验证码登陆');
              } else {
                print('一键登录失败');
              }
              // 异步操作，有延迟，写在最后
              await AtauthFlutterPlugin.cancelLogin(flag: true);
            }
          },
        ),
      ),
    );
  }
}
