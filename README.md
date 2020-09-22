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

 ### Android

SDK限制：自定义登录界面需要修改安卓代码

### IOS

SDK限制：自定义登录界面需要修改iOS代码