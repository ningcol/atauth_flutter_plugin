import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:atauth_flutter_plugin/atauth_flutter_plugin.dart';

//ios
final sdkInfo = '8I+caDHMUXyzPseTX2SAv60SwqZeQpHGPrYDqioVOH+ADkqs0P5NqrClpanLYRrhnZKF20giKwPXuVNLiQ2IE1/X97ouTHad+W/1QEbbCd01facwqBrvPmPcBKcqNCswuXocohe6lhbBqHD2Ake/YtbqHnSBZK9wzZECUPguOzqqaiTW0UMtSCHwuz3lezfUzpmncOq52UlrKBX9HdJsHdfOHD5+TGo5C0EQ415GShLiOO9eMbX9UeX24x1YEsgRjtUyGuLQjJs=';
//android
// final sdkInfo = 'N98rEm/z5aV+jtRDlsbnUWV8Hxy0wi0yPrxsAujJo3UiLs31+9oFJmBLbP8Ks4n9V/cH/SYDbv9aQxqj6PGXKUAkC+0r6gkHOWjOgzA71/USL25rD72VF1qFbl77mwv1ZGfsfZi98vmjbYkq1ISvNxrGZNcma2IiOE7sfQzxwAvwzoHJBsMWh/RphlLdMgOY3kNWxnoFxEIJzzA6mPLQWFBbACtUpVIX1uJcs6jRHdnbL/C0g1I5dSfiC8YibNIIUwZQ5NBxtBovpqdnBgBApJewZXMx8LoT10v9SLxUhgZkkiFgQSCVRpNy2f2gFJiZ';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await AtauthFlutterPlugin.platformVersion;

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
        body: Center(
          child: Text('Running on: $_platformVersion\n'),
        ),
        floatingActionButton: FloatingActionButton(
          child: Text('登录'),
          onPressed: () async {
            /// 一键登录
            var result3 = await AtauthFlutterPlugin.getLoginToken(timeout: 3.0);
            print(result3.code);
            print(result3.msg);
            print(result3.token);
            if (true == result3.token?.isNotEmpty && result3.success) {
              await AtauthFlutterPlugin.cancelLogin(flag: true);
            }else if(result3.isUserCanceled){
              print('用户取消');
            }else{
              print(result3.code);
              if(result3.isChooseVerificationCode) {
                //打开验证码登陆
                print('使用验证码登陆');
              }else{
                print('一键登录失败');
              }
              await AtauthFlutterPlugin.cancelLogin(flag: true);
              if(result3.isChooseVerificationCode) {
                //打开验证码登陆
                print('使用验证码登陆');
              }else{
                print('一键登录失败');
              }
            }
          },
        ),
      ),
    );
  }
}
