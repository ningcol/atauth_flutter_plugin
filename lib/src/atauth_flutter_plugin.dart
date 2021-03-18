
import 'dart:async';
import 'dart:convert';

import 'result_model.dart';
import 'package:flutter/services.dart';

class AtauthFlutterPlugin {
  static const MethodChannel _channel =
      const MethodChannel('atauth_flutter_plugin');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<ResultModel> initATAuthSDK(
      {required String sdkInfo,
        bool loggerEnable = false,
        bool uploadLogEnable = false}) async {
    return ResultModel.fromJson(
        jsonDecode(await _channel.invokeMethod('initSDK', {
          'authSDKInfo': sdkInfo,
          "loggerEnable": loggerEnable,
          "uploadLogEnable": uploadLogEnable
        })));
  }

  /// 检查当前环境是否支持一键登录或号码认证
  static Future<ResultModel> checkSDK({
    required PNSAuthType type,
  }) async {
    return ResultModel.fromJson(
        jsonDecode(await _channel.invokeMethod('checkEnvAvailable', {'type': type.name}))
    );
  }

  /// 加速一键登录授权页弹起
  static Future<ResultModel> accelerateLoginPage({
    /// 接口超时时间，单位s，默认为3.0s
    required double timeout,
  }) async {
    return ResultModel.fromJson(
        jsonDecode(await _channel.invokeMethod('accelerateLoginPage', {'timeout': timeout}))
    );
  }

  /// 获取一键登录Token，调用该接口首先会弹起授权页，点击授权页的登录按钮获取Token
  /// !!! 这里只有获取token成功才有返回
  static Future<ResultModel> getLoginToken({
    /// 接口超时时间，单位s，默认为3.0s
    required double timeout,
  }) async {
    return ResultModel.fromJson(
        jsonDecode(await _channel.invokeMethod('getLoginTokenPage', {'timeout': timeout}))
    );
  }

  /// 注销授权页，建议用此方法，对于移动卡授权页的消失会清空一些数据
  static Future<void> cancelLogin({
    /// 是否添加动画
    required bool flag,
  }) async {
    return await _channel.invokeMethod('cancelLogin', {'flag': flag});
  }


  /// 手动隐藏一键登录获取登录Token之后的等待动画，默认为自动隐藏
  static Future<void> get hideLoginLoading async {
    return await _channel.invokeMethod('hideLoginLoading');
  }
}


enum PNSAuthType {
  PNSAuthTypeVerifyToken,  //本机号码校验
  PNSAuthTypeLoginToken //一键登录
}

extension _ExtPNSAuthType on PNSAuthType{
  get name => toString().split('.').last;
}
