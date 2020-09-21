package com.fangstar.atauth_flutter_plugin

import android.util.Log
import com.alibaba.fastjson.JSON
import com.alibaba.fastjson.annotation.JSONCreator
import com.mobile.auth.gatewayauth.model.TokenRet

@Suppress("unused")
class ResultInfo @JSONCreator constructor(
    val msg: String? = null,
    val code: String? = null,
    val requestId: String? = null,
    val token: String? = null
) {
    
    fun toJson(): String {
        val json = JSON.toJSONString(this)
        Log.e("ResultInfo", "toJson: $json")
        return json
    }
    
    companion object {
        const val FAIL_CODE = "0"
        const val SUCCESS_CODE = "1"
        
        const val USER_CANCELED = "100"
        const val CHOOSE_VERIFICATION_CODE_LOGIN = "101"
        
        @JvmStatic
        fun success(tokenRet: TokenRet?): ResultInfo {
            return ResultInfo(msg = tokenRet?.msg, code = SUCCESS_CODE, requestId = tokenRet?.requestId, token = tokenRet?.token)
        }
        
        @JvmStatic
        fun fail(tokenRet: TokenRet?): ResultInfo {
            return ResultInfo(msg = tokenRet?.msg, code = FAIL_CODE, requestId = tokenRet?.requestId, token = tokenRet?.token)
        }
    }
    
}