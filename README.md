# atauth_flutter_plugin

阿里云号码认证服务flutter插件（Alibaba Cloud Phone Number Verification Service） \
https://help.aliyun.com/product/75010.html \
支持中国三大运营商全网手机号码认证，一点接入，全国全网覆盖。


## Getting Started

集成阿里云号码认证SDK

|  平台   |  版本   |
| :-----: | :-----: |
| Android | V2.10.1 |
|   iOS   | V2.10.1 |

## 功能清单

* 初始化SDK
* 检查当前环境
* 加速弹出一键登录界面
* 弹出一键登录界面后拿到token

## 使用

### Flutter

1. 申请boundID对应的appKey
2. 调用initATAuthSDK方法传入申请的appKey
3. 如果要跑example中的代码，要创建key文件夹，里面创建sdk.key文件，里面写入key

 ### Android
AuthUIConfigImpl类里自定义界面

### IOS
需要修改iOS中修改代码（buildFullScreenPortraitModel方法中定义界面布局），暂未实现flutter修改界面