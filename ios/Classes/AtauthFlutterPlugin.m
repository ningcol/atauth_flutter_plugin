#import "AtauthFlutterPlugin.h"

#import <ATAuthSDK/ATAuthSDK.h>
#import "ATUtils.h"

@implementation AtauthFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"atauth_flutter_plugin"
            binaryMessenger:[registrar messenger]];
  AtauthFlutterPlugin* instance = [[AtauthFlutterPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  }
  else if ([@"initSDK" isEqualToString:call.method]) {
      [self initATAuthSDK:call result:result];
  }
  else if ([@"checkEnvAvailable" isEqualToString:call.method]) {
      [self checkATAuthSDK:call result:result];
  }
  else if ([@"accelerateLoginPage" isEqualToString:call.method]) {
      [self accelerateLoginPage:call result:result];
  }
  else if ([@"getLoginTokenPage" isEqualToString:call.method]) {
      [self getLoginTokenPage:call result:result];
  }
  else if ([@"cancelLogin" isEqualToString:call.method]) {
      [self cancelLogin:call result:result];
  }
  else if ([@"hideLoginLoading" isEqualToString:call.method]) {
      [self hideLoginLoading:call result:result];
  }
  else if ([@"isChinaUnicom" isEqualToString:call.method]) {
      [self isChinaUnicom:call result:result];
  }
  else if ([@"isChinaMobile" isEqualToString:call.method]) {
      [self isChinaMobile:call result:result];
  }
  else if ([@"isChinaTelecom" isEqualToString:call.method]) {
      [self isChinaTelecom:call result:result];
  }
  else if ([@"getCurrentMobileNetworkName" isEqualToString:call.method]) {
      [self getCurrentMobileNetworkName:call result:result];
  }
  else if ([@"getCurrentCarrierName" isEqualToString:call.method]) {
      [self getCurrentCarrierName:call result:result];
  }
  else if ([@"getNetworktype" isEqualToString:call.method]) {
      [self getNetworktype:call result:result];
  }
  else if ([@"simSupportedIsOK" isEqualToString:call.method]) {
      [self simSupportedIsOK:call result:result];
  }
  else if ([@"isWWANOpen" isEqualToString:call.method]) {
      [self isWWANOpen:call result:result];
  }
  else if ([@"reachableViaWWAN" isEqualToString:call.method]) {
      [self reachableViaWWAN:call result:result];
  }
  else {
      result(FlutterMethodNotImplemented);
  }
}


/// 初始化sdk
- (void)initATAuthSDK:(FlutterMethodCall *)call result:(FlutterResult)result {
  NSString *skdInfo = [call.arguments objectForKey:@"authSDKInfo"];
  [[TXCommonHandler sharedInstance] setAuthSDKInfo:skdInfo
                                          complete:^(NSDictionary * _Nonnull resultDic) {
      NSLog(@"设置秘钥结果：%@", [self dictToJson:resultDic]);
      result([self dictToJson:resultDic]);
  }];
}


/// 检查环境
- (void)checkATAuthSDK:(FlutterMethodCall *)call result:(FlutterResult)result {
  NSString *typeString = [call.arguments objectForKey:@"type"];
  PNSAuthType authType = PNSAuthTypeLoginToken;
  if ([typeString isEqualToString:@"PNSAuthTypeLoginToken"]) {
      authType = PNSAuthTypeLoginToken;
  }
  if ([typeString isEqualToString:@"PNSAuthTypeVerifyToken"]) {
      authType = PNSAuthTypeVerifyToken;
  }

  [[TXCommonHandler sharedInstance] checkEnvAvailableWithAuthType:authType
                                                         complete:^(NSDictionary * _Nullable resultDic) {
      NSLog(@"checkATAuthSDK：%@", [self dictToJson:resultDic]);
      result([self dictToJson:resultDic]);
  }];
}


/// 加速一键登录授权页弹起
- (void)accelerateLoginPage:(FlutterMethodCall *)call result:(FlutterResult)result {
  NSTimeInterval time = [[call.arguments objectForKey:@"timeout"] doubleValue];

  [[TXCommonHandler sharedInstance] accelerateLoginPageWithTimeout:time complete:^(NSDictionary * _Nonnull resultDic) {
      result([self dictToJson:resultDic]);
  }];

}

/// 获取一键登录Token，调用该接口首先会弹起授权页，点击授权页的登录按钮获取Token
- (void)getLoginTokenPage:(FlutterMethodCall *)call result:(FlutterResult)result {
  NSTimeInterval time = [[call.arguments objectForKey:@"timeout"] doubleValue];


  [[TXCommonHandler sharedInstance] getLoginTokenWithTimeout:time
                                                  controller:[self viewControllerWithWindow:nil]
                                                       model:[self buildFullScreenPortraitModel]
                                                    complete:^(NSDictionary * _Nonnull resultDic) {
      NSString *resultCode = [resultDic objectForKey:@"resultCode"];
      NSString *msg = [resultDic objectForKey:@"msg"];
      if ([resultCode isEqualToString:PNSCodeSuccess]) {
          result([self dictToJson:resultDic]);
      } else {
      }

  }];

}

/// 注销授权页，建议用此方法，对于移动卡授权页的消失会清空一些数据
- (void)cancelLogin:(FlutterMethodCall *)call result:(FlutterResult)result {
  BOOL flag = [[call.arguments objectForKey:@"flag"] boolValue];
  [[TXCommonHandler sharedInstance] cancelLoginVCAnimated:flag complete:nil];
}

- (void)hideLoginLoading:(FlutterMethodCall *)call result:(FlutterResult)result {
  [[TXCommonHandler sharedInstance] hideLoginLoading];
}




/// 判断当前上网卡运营商是否是中国联通
- (void)isChinaUnicom:(FlutterMethodCall *)call result:(FlutterResult)result {
  result([NSNumber numberWithBool:[TXCommonUtils isChinaUnicom]]);
}

/// 判断当前上网卡运营商是否是中国移动
- (void)isChinaMobile:(FlutterMethodCall *)call result:(FlutterResult)result {
  result([NSNumber numberWithBool:[TXCommonUtils isChinaMobile]]);
}

/// 判断当前上网卡运营商是否是中国电信
- (void)isChinaTelecom:(FlutterMethodCall *)call result:(FlutterResult)result {
  result([NSNumber numberWithBool:[TXCommonUtils isChinaTelecom]]);
}

/// 获取当前上网卡网络名称
- (void)getCurrentMobileNetworkName:(FlutterMethodCall *)call result:(FlutterResult)result {
  result([TXCommonUtils getCurrentMobileNetworkName]);
}

/// 获取当前上网卡运营商名称，比如中国移动、中国电信、中国联通
- (void)getCurrentCarrierName:(FlutterMethodCall *)call result:(FlutterResult)result {
  result([TXCommonUtils getCurrentCarrierName]);
}

/// 获取当前上网卡网络类型，比如WiFi，4G
- (void)getNetworktype:(FlutterMethodCall *)call result:(FlutterResult)result {
  result([TXCommonUtils getNetworktype]);
}

///  判断当前设备是否有SIM卡
- (void)simSupportedIsOK:(FlutterMethodCall *)call result:(FlutterResult)result {
  result([NSNumber numberWithBool:[TXCommonUtils simSupportedIsOK]]);
}

///  判断wwan是否开着（通过p0网卡判断，无wifi或有wifi情况下都能检测到）
- (void)isWWANOpen:(FlutterMethodCall *)call result:(FlutterResult)result {
  result([NSNumber numberWithBool:[TXCommonUtils isWWANOpen]]);
}

///  判断wwan是否开着（仅无wifi情况下）
- (void)reachableViaWWAN:(FlutterMethodCall *)call result:(FlutterResult)result {
  result([NSNumber numberWithBool:[TXCommonUtils reachableViaWWAN]]);
}






- (UIViewController *)viewControllerWithWindow:(UIWindow *)window {
  UIWindow *windowToUse = window;
  if (windowToUse == nil) {
      for (UIWindow *window in [UIApplication sharedApplication].windows) {
          if (window.isKeyWindow) {
              windowToUse = window;
              break;
          }
      }
  }

  UIViewController *topController = windowToUse.rootViewController;
  while (topController.presentedViewController) {
      topController = topController.presentedViewController;
  }
  return topController;
}






- (TXCustomModel *)buildFullScreenPortraitModel {
  TXCustomModel *model = [[TXCustomModel alloc] init];
  model.supportedInterfaceOrientations = UIInterfaceOrientationMaskPortrait;
  model.navColor = [UIColor orangeColor];
  NSDictionary *attributes = @{
      NSForegroundColorAttributeName : [UIColor whiteColor],
      NSFontAttributeName : [UIFont systemFontOfSize:20.0]
  };
  model.navTitle = [[NSAttributedString alloc] initWithString:@"一键登录" attributes:attributes];
  model.navBackImage = [UIImage imageNamed:@"icon_nav_back_light"];
  model.logoImage = [UIImage imageNamed:@"taobao"];
  model.changeBtnIsHidden = YES;
  model.privacyOne = @[@"协议122", @"https://www.taobao.com"];

//    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeSystem];
//    [button1 setTitle:button1Title forState:UIControlStateNormal];
//    [button1 addTarget:target1 action:selector1 forControlEvents:UIControlEventTouchUpInside];
//
//    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeSystem];
//    [button2 setTitle:button2Title forState:UIControlStateNormal];
//    [button2 addTarget:target2 action:selector2 forControlEvents:UIControlEventTouchUpInside];

  model.customViewBlock = ^(UIView * _Nonnull superCustomView) {
//        [superCustomView addSubview:button1];
//        [superCustomView addSubview:button2];
  };
  model.customViewLayoutBlock = ^(CGSize screenSize, CGRect contentViewFrame, CGRect navFrame, CGRect titleBarFrame, CGRect logoFrame, CGRect sloganFrame, CGRect numberFrame, CGRect loginFrame, CGRect changeBtnFrame, CGRect privacyFrame) {
//        button1.frame = CGRectMake(CGRectGetMinX(loginFrame),
//                                   CGRectGetMaxY(loginFrame) + 20,
//                                   CGRectGetWidth(loginFrame),
//                                   30);
//
//        button2.frame = CGRectMake(CGRectGetMinX(loginFrame),
//                                   CGRectGetMaxY(button1.frame) + 15,
//                                   CGRectGetWidth(loginFrame),
//                                   30);
  };
  return model;
}

- (NSString *)dictToJson:(NSDictionary *)dict {
  return [ATUtils dictionary2Json:dict];
}


@end
