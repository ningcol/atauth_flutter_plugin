#import "AtauthFlutterPlugin.h"

#import <ATAuthSDK/ATAuthSDK.h>
#import "ATUtils.h"

#define     ATCOLOR(r, g, b)                 [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]


@interface AtauthFlutterPlugin()
@property(nonatomic, copy) FlutterResult loginResult;
@end

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
      NSString *token = [resultDic objectForKey:@"token"];
      if ([resultCode isEqualToString:PNSCodeSuccess]) {
          NSDictionary *dict = @{@"msg": msg, @"code": @"1", @"token": token};
          result([self dictToJson:dict]);
      }
      self.loginResult = result;
//      if (self.isClickOthersLogin) {
//          NSDictionary *dict = @{@"msg": @"点击其它登录", @"code": @"101"};
//          result([self dictToJson:dict]);
//      }

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
  model.navColor = [UIColor whiteColor];
  model.navBackImage = [UIImage imageNamed:@"icon_login_back"];
    model.navTitle = [[NSAttributedString alloc] initWithString:@""];
    
    CGSize logoSize = CGSizeMake(30, 44);
    __block CGFloat logoMaxY = 0;
    __block CGFloat loginMaxY = 0;
    __block CGFloat btnHeight = 50;
    __block CGFloat btnMargin = 10;
    
    // logo
    model.logoImage = [UIImage imageNamed:@"icon_login"];
    model.logoFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        CGFloat x = (superViewSize.width - logoSize.width) /2;
        // 27  44
        logoMaxY = logoSize.height + frame.origin.y;
        return CGRectMake(x, frame.origin.y, logoSize.width, logoSize.height);
    };
    
    // 电话号码
    model.numberFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        return CGRectMake(frame.origin.x, logoMaxY + 20, frame.size.width, frame.size.height);
    };
    
    // slogan
//    model.loginBtnText = [[NSAttributedString alloc] initWithString:@"中国电信提供认证服务"];
    

    // 登录按钮
    NSDictionary *attributes = @{
        // rgb(33, 91, 241)  241 241
        NSForegroundColorAttributeName : [UIColor whiteColor],
        NSFontAttributeName : [UIFont systemFontOfSize:17.0]
    };
    UIImage *loginImg = [UIImage imageNamed:@"btn_login_normal"];
    model.loginBtnBgImgs = @[loginImg, loginImg, loginImg];
    model.loginBtnText = [[NSAttributedString alloc] initWithString:@"立即登录" attributes:attributes];
    model.loginBtnFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {  // 高度默认50
        CGRect loginFrame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, btnHeight);
        loginMaxY = CGRectGetMaxY(loginFrame);
        return loginFrame;
    };

    
    // 切换到其它方式
  model.changeBtnIsHidden = YES;
    
    
    // 协议checkBox
    model.checkBoxIsChecked = YES;
    model.checkBoxIsHidden = YES;
    
    
    UIColor *globalGray = ATCOLOR(153, 153, 153);
    // 协议
    model.privacyPreText = @"为保障您的个人隐私权益，请在登录前仔细阅读";
    model.privacyOne = @[@"协议122", @"https://www.taobao.com"];
    model.privacyColors = @[globalGray, ATCOLOR(33, 91, 241)];
    model.privacyFont = [UIFont systemFontOfSize:13];
//    model.privacyTwo = @[@"协议2", @"https://www.taobao.com"];
//    model.privacyThree = @[@"协议3", @"https://www.taobao.com"];
    model.privacyFrameBlock = ^CGRect(CGSize screenSize, CGSize superViewSize, CGRect frame) {
        return CGRectMake(frame.origin.x, loginMaxY + btnMargin + btnHeight + 15, frame.size.width, frame.size.height);
    };
     
    // 协议详情页
    model.privacyNavBackImage = [UIImage imageNamed:@"icon_login_back"];

    // 自定义view
    UIButton *othersBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    othersBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [othersBtn setTitleColor:globalGray forState:UIControlStateNormal];
    [othersBtn setTitle:@"其它手机号码登录" forState:UIControlStateNormal];
    [othersBtn setBackgroundImage:[UIImage imageNamed:@"btn_login_others_normal"] forState:UIControlStateNormal];
    [othersBtn setBackgroundImage:[UIImage imageNamed:@"btn_login_others_normal"] forState:UIControlStateHighlighted];
    [othersBtn addTarget:self action:@selector(clickOthersBtn) forControlEvents:UIControlEventTouchUpInside];
    

  model.customViewBlock = ^(UIView * _Nonnull superCustomView) {
        [superCustomView addSubview:othersBtn];
  };
  model.customViewLayoutBlock = ^(CGSize screenSize, CGRect contentViewFrame, CGRect navFrame, CGRect titleBarFrame, CGRect logoFrame, CGRect sloganFrame, CGRect numberFrame, CGRect loginFrame, CGRect changeBtnFrame, CGRect privacyFrame) {
      othersBtn.frame = CGRectMake(CGRectGetMinX(loginFrame),
                                   CGRectGetMaxY(loginFrame) + btnMargin,
                                   CGRectGetWidth(loginFrame),
                                   btnHeight);
  };
    

  return model;
}


- (void)clickOthersBtn {
    [[self viewControllerWithWindow:nil] dismissViewControllerAnimated:YES completion:^{
      NSDictionary *dict = @{@"msg": @"点击其它登录", @"code": @"101"};
      self.loginResult([self dictToJson:dict]);
    }];
}

/*
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
 */

- (NSString *)dictToJson:(NSDictionary *)dict {
  return [ATUtils dictionary2Json:dict];
}


@end
