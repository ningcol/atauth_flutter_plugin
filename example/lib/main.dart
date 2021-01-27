import 'dart:async';

import 'package:atauth_flutter_plugin/aliyun_number_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _showData = 'Unknown';

  ResultModel _resultModel;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  @override
  void dispose() {
    _resultModel = null;
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    String sdkInfo;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await AtauthFlutterPlugin.platformVersion;
      sdkInfo = await rootBundle.loadString('key/sdk.key');

      /// 初始化SDK
      ResultModel result = await AtauthFlutterPlugin.initATAuthSDK(sdkInfo: sdkInfo);
      print('initATAuthSDK ${result.code}');

      /// 检查环境
      ResultModel result1 = await AtauthFlutterPlugin.checkSDK(type: PNSAuthType.PNSAuthTypeVerifyToken);
      print('checkSDK-PNSAuthTypeVerifyToken ${result1.code}');
      ResultModel result2 = await AtauthFlutterPlugin.checkSDK(type: PNSAuthType.PNSAuthTypeLoginToken);
      print('checkSDK-PNSAuthTypeLoginToken ${result2.code}');

      /// 加速一键登录授权页弹起
      ResultModel result3 = await AtauthFlutterPlugin.accelerateLoginPage(timeout: 3.0);
      print('accelerateLoginPage ${result3.code}');

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
        body: Builder(
          builder: (ctx){
            return Container(
              padding: EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text('Running on: $_showData\n'),
                    null == _resultModel
                        ? Container()
                        : MaterialButton(
                      child: Text(_resultModel.token),
                      onPressed: () {
                        Scaffold.of(ctx)
                            .showSnackBar(SnackBar(content: Text('已复制')));
                        Clipboard.setData(
                            ClipboardData(text: _resultModel.token));
                      },
                    ),
                    SizedBox(height: 100,),
                  ],
                ),
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: Text('登录'),
          onPressed: () async {
            /// 一键登录
            ResultModel result3 = await AtauthFlutterPlugin.getLoginToken(timeout: 3.0);
            if (true == result3.token?.isNotEmpty && result3.success) {
              AtauthFlutterPlugin.cancelLogin(flag: true);
              print('登陆成功');
              setState(() {
                _resultModel = result3;
              });
            } else if (result3.isUserCanceled) {
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
