package com.fangstar.atauth_flutter_plugin.ext

import com.fangstar.atauth_flutter_plugin.ResultInfo
import com.mobile.auth.gatewayauth.model.TokenRet
import io.flutter.plugin.common.MethodChannel

fun MethodChannel.Result.failRet(ret: TokenRet? = null, msg: String? = null, code: String? = ResultInfo.FAIL_CODE) {
    if(null == ret) {
        success(ResultInfo(msg, code = code).toJson())
    } else {
        success(ResultInfo.fail(ret).toJson())
    }
}

fun MethodChannel.Result.successRet(ret: TokenRet? = null, msg: String? = null) {
    if(null == ret) {
        success(ResultInfo(msg, code = ResultInfo.SUCCESS_CODE).toJson())
    } else {
        success(ResultInfo.success(ret).toJson())
    }
}

fun MethodChannel.Result.failMsg(msg: String?) {
    failRet(msg = msg)
}

fun MethodChannel.Result.successMsg(msg: String?) {
    successRet(msg = msg)
}

fun MethodChannel.Result.failCode(code: String?) {
    failRet(code = code)
}