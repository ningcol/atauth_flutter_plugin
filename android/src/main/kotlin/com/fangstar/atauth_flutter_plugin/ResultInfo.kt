package com.fangstar.atauth_flutter_plugin

import android.util.Log
import com.mobile.auth.gatewayauth.model.TokenRet
import org.json.JSONObject

@Suppress("unused")
class ResultInfo constructor(
    val msg: String? = null,
    val code: String? = null,
    val requestId: String? = null,
    val token: String? = null
) {
    
    fun toJson(): String {
        val jsonObj = JSONObject()
        jsonObj.put("msg", msg)
        jsonObj.put("code", code)
        jsonObj.put("requestId", requestId)
        jsonObj.put("token", token)
        val result = jsonObj.toString()
        if(ATAuthFlutterPlugin.enableLog) {
            Log.e("ResultInfo", "toJson: $result")
        }
        return result
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