package com.fangstar.atauth_flutter_plugin

import android.content.Context
import android.util.Log
import androidx.annotation.NonNull
import com.alibaba.fastjson.JSON
import com.fangstar.atauth_flutter_plugin.ext.failCode
import com.fangstar.atauth_flutter_plugin.ext.failMsg
import com.fangstar.atauth_flutter_plugin.ext.failRet
import com.fangstar.atauth_flutter_plugin.ext.successMsg
import com.fangstar.atauth_flutter_plugin.ext.successRet
import com.mobile.auth.gatewayauth.PhoneNumberAuthHelper
import com.mobile.auth.gatewayauth.PreLoginResultListener
import com.mobile.auth.gatewayauth.ResultCode
import com.mobile.auth.gatewayauth.TokenResultListener
import com.mobile.auth.gatewayauth.model.TokenRet
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.*

class MethodCallHandlerImpl(private val ctx: Context) : MethodCallHandler {
    
    companion object {
        private const val TAG = "MethodCallHandlerImpl"
        
        @JvmStatic
        private fun safeParse(ret: String?): TokenRet? {
            return try {
                JSON.parseObject(ret, TokenRet::class.java)
            } catch(e: Exception) {
                null
            }
        }
        
    }
    
    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        Log.w(TAG, "onMethodCall: ${call.method}")
        when(call.method) {
            ChannelMethods.GET_PLATFORM_VERSION     -> result.success("Android ${android.os.Build.VERSION.RELEASE}")
            ChannelMethods.INIT_SDK                 -> initSdk(call, result)
            ChannelMethods.CHECK_ENV_AVAILABLE      -> checkEnvAvailable(call, result)
            ChannelMethods.ACCELERATE_LOGIN_PAGE    -> accelerateLoginPage(call, result)
            ChannelMethods.GET_LOGIN_TOKEN_PAGE     -> getLoginTokenPage(call, result)
            ChannelMethods.CANCEL_LOGIN             -> quitLoginPage(call, result)
            ChannelMethods.HIDE_LOGIN_LOADING       -> hideLoginLoading(call, result)
            ChannelMethods.GET_CURRENT_CARRIER_NAME -> getCurrentCarrierName(call, result)
            else                                    -> result.notImplemented()
        }
    }
    
    private fun initSdk(call: MethodCall, result: Result) {
        val authSDKInfo = call.argument<String>("authSDKInfo")
        val loggerEnable = call.argument<Boolean>("loggerEnable")
                ?: false
        val uploadLogEnable = call.argument<Boolean>("uploadLogEnable")
                ?: false
        if(!authSDKInfo.isNullOrEmpty()) {
            invokeSDK({ helper ->
                helper.setAuthSDKInfo(authSDKInfo)
                helper.reporter.setLoggerEnable(loggerEnable)
                helper.reporter.setUploadEnable(uploadLogEnable)
                result.successRet()
            })
        }
    }
    
    private fun checkEnvAvailable(call: MethodCall, result: Result) {
        val type = call.argument<String>("type")
        if(!type.isNullOrEmpty()) {
            val checkType = when {
                "PNSAuthTypeVerifyToken".equals(type, true) -> {
                    /*本机号码校验*/
                    PhoneNumberAuthHelper.SERVICE_TYPE_AUTH
                }
                "PNSAuthTypeLoginToken".equals(type, true)  -> {
                    /*一键登录*/
                    PhoneNumberAuthHelper.SERVICE_TYPE_LOGIN
                }
                else                                        -> {
                    result.notImplemented()
                    return
                }
            }
            invokeSDK({ helper ->
                helper.checkEnvAvailable(checkType)
            }, success = { ret: TokenRet? ->
                if(ResultCode.CODE_ERROR_ENV_CHECK_SUCCESS == ret?.code) {
                    result.successRet(ret)
                } else {
                    result.failRet(ret)
                }
            }, fail = { ret: TokenRet? ->
                result.failRet(ret)
            })
        }
    }
    
    private fun accelerateLoginPage(call: MethodCall, result: Result) {
        val timeout = (call.argument<Number>("timeout")
                ?: 5).toInt().let {
            if(it < 1000) {
                return@let it.times(1000)
            }
            it
        }
        invokeSDK({ helper ->
            helper.accelerateLoginPage(timeout, object : PreLoginResultListener {
                override fun onTokenFailed(vendor: String?, ret: String?) {
                    result.failMsg(ret)
                }
                
                override fun onTokenSuccess(vendor: String?) {
                    result.successMsg(vendor)
                }
            })
        })
    }
    
    private fun getLoginTokenPage(call: MethodCall, result: Result) {
        val timeout = (call.argument<Number>("timeout")
                ?: 5).toInt().let {
            if(it < 1000) {
                return@let it.times(1000)
            }
            it
        }
        Log.w(TAG, "getLoginTokenPage: $timeout")
        invokeSDK({ helper ->
            helper.setAuthListener(object : TokenResultListener {
                override fun onTokenFailed(p0: String?) {
                    Log.w(TAG, "onTokenFailed: $p0")
                    helper.setAuthListener(null)
                    helper.setUIClickListener(null)
                    helper.removeAuthRegisterViewConfig()
                    helper.removeAuthRegisterXmlConfig()
                    val tokenRet = safeParse(p0)
                    if(ResultCode.CODE_ERROR_USER_CANCEL == tokenRet?.code) {
                        result.failCode(ResultInfo.USER_CANCELED)
                    } else {
                        result.failRet(tokenRet)
                    }
                }
                
                override fun onTokenSuccess(p0: String?) {
                    Log.w(TAG, "onTokenSuccess: $p0")
                    val tokenRet = safeParse(p0)
                    if(ResultCode.CODE_GET_TOKEN_SUCCESS == tokenRet?.code) {
                        helper.setAuthListener(null)
                        helper.setUIClickListener(null)
                        helper.removeAuthRegisterViewConfig()
                        helper.removeAuthRegisterXmlConfig()
                        result.successRet(tokenRet)
                    }
                }
            })
            AuthUIConfigImpl.configAuthUI(helper, result)
            helper.getLoginToken(ctx, timeout)
        })
    }
    
    private fun quitLoginPage(call: MethodCall, result: Result) {
        invokeSDK({ helper ->
            helper.quitLoginPage()
            helper.setAuthListener(null)
            helper.setUIClickListener(null)
            helper.removeAuthRegisterViewConfig()
            helper.removeAuthRegisterXmlConfig()
            result.successRet()
        })
    }
    
    private fun hideLoginLoading(call: MethodCall, result: Result) {
        invokeSDK({ helper ->
            helper.hideLoginLoading()
            result.successRet()
        })
    }
    
    private fun getCurrentCarrierName(call: MethodCall, result: Result) {
        invokeSDK({ helper ->
            result.success(helper.currentCarrierName)
        })
    }
    
    private fun invokeSDK(business: (helper: PhoneNumberAuthHelper) -> Unit, success: ((ret: TokenRet?) -> Unit)? = null, fail: ((ret: TokenRet?) -> Unit)? = null) {
        val listener = if(null != success || null != fail) {
            object : TokenResultListener {
                override fun onTokenFailed(p0: String?) {
                    fail?.invoke(safeParse(p0))
                    PhoneNumberAuthHelper.getInstance(ctx, null)
                }
                
                override fun onTokenSuccess(p0: String?) {
                    success?.invoke(safeParse(p0))
                    PhoneNumberAuthHelper.getInstance(ctx, null)
                }
            }
        } else {
            null
        }
        val helper = PhoneNumberAuthHelper.getInstance(ctx, listener)
        business.invoke(helper)
    }
    
    object ChannelMethods {
        const val GET_PLATFORM_VERSION = "getPlatformVersion"
        const val INIT_SDK = "initSDK"
        const val CHECK_ENV_AVAILABLE = "checkEnvAvailable"
        const val ACCELERATE_LOGIN_PAGE = "accelerateLoginPage"
        const val GET_LOGIN_TOKEN_PAGE = "getLoginTokenPage"
        const val CANCEL_LOGIN = "cancelLogin"
        const val HIDE_LOGIN_LOADING = "hideLoginLoading"
        const val GET_CURRENT_CARRIER_NAME = "getCurrentCarrierName"
    }
}