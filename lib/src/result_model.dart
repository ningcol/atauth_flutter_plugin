import 'dart:convert';

ResultModel resultModelFromJson(String? str) => ResultModel.fromJson(json.decode(str!));

String resultModelToJson(ResultModel? data) => json.encode(data!.toJson());

class ResultModel {
  ResultModel({
    this.msg,
    this.code,
    this.requestId,
    this.token,
  });

  String? msg;
  String? code;
  String? requestId;
  /// 登录才有
  String? token;
  bool get success => code == '1';
  bool get fail => code == '0';

  /// 是否用户取消登陆
  bool get isUserCanceled => code == '100';
  /// 是否选择使用验证码登陆
  bool get isChooseVerificationCode => code == '101';

  factory ResultModel.fromJson(Map<String?, dynamic>? json) => ResultModel(
    msg: json!["msg"],
    code: json["code"],
    requestId: json["requestId"],
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "msg": msg,
    "code": code,
    "requestId": requestId,
    "token": token,
  };
}
