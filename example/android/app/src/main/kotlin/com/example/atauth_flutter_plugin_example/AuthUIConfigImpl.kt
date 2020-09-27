package com.example.atauth_flutter_plugin_example

import android.content.pm.ActivityInfo
import android.graphics.Color
import android.os.Build
import android.view.Gravity
import android.view.View
import android.widget.ImageView
import com.fangstar.atauth_flutter_plugin.ATAuthFlutterPlugin
import com.fangstar.atauth_flutter_plugin.IAuthUIConfig
import com.fangstar.atauth_flutter_plugin.ResultInfo
import com.fangstar.atauth_flutter_plugin.ext.failRet
import com.mobile.auth.gatewayauth.AuthRegisterXmlConfig
import com.mobile.auth.gatewayauth.AuthUIConfig
import com.mobile.auth.gatewayauth.PhoneNumberAuthHelper
import com.mobile.auth.gatewayauth.ui.AbstractPnsViewDelegate
import io.flutter.plugin.common.MethodChannel

object AuthUIConfigImpl : IAuthUIConfig {
    
    @JvmStatic
    fun setup() {
        ATAuthFlutterPlugin.setupAuthUIConfig(this)
    }
    
    override fun configAuthUI(helper: PhoneNumberAuthHelper, result: MethodChannel.Result) {
        helper.removeAuthRegisterXmlConfig()
        helper.removeAuthRegisterViewConfig()
        helper.addAuthRegisterXmlConfig(ResultAuthRegisterXmlConfig(result).getAuthRegisterXmlConfig())
        helper.setAuthUIConfig(mAuthUIConfigBuilder.create())
    }
    
    private class ResultAuthRegisterXmlConfig(private val result: MethodChannel.Result) {
        fun getAuthRegisterXmlConfig(): AuthRegisterXmlConfig {
            return AuthRegisterXmlConfig.Builder()
                    .setLayout(R.layout.layout_onekey_auth_login, object : AbstractPnsViewDelegate() {
                        override fun onViewCreated(view: View) {
                            findViewById(R.id.btn_other_login).setOnClickListener {
                                result.failRet(msg = "使用验证码登录", code = ResultInfo.CHOOSE_VERIFICATION_CODE_LOGIN)
                            }
                        }
                    }).build()
        }
    }
    
    @JvmStatic
    private val mAuthUIConfigBuilder: AuthUIConfig.Builder by lazy {
        AuthUIConfig.Builder()
                //导航栏
                .setNavColor(Color.TRANSPARENT) //导航栏颜色
                .setNavReturnImgPath("icon_close") //导航栏返回图标
                .setNavReturnScaleType(ImageView.ScaleType.FIT_XY) //返回按钮缩放
                .setNavReturnImgWidth(20) //返回按钮宽度
                .setNavReturnImgHeight(20) //返回按钮高度
                .setWebNavColor(Color.WHITE) //协议页面导航栏颜色
                .setWebNavTextColor(Color.BLACK) //协议页面导航栏字体颜色
                .setWebNavTextSize(23) //协议页面导航栏字体大小
                .setWebNavReturnImgPath("icon_close") //协议页面导航栏返回图标
                //状态栏
                .setStatusBarColor(Color.WHITE) //状态栏颜色 (5.0+)
                .setLightColor(true) //状态栏字体颜色，true: 黑色 (6.0+)
                //LOGO
                .setLogoImgPath("icon_login_phone") //
                .setLogoWidth(30) //
                .setLogoHeight(44) //
                .setLogoScaleType(ImageView.ScaleType.FIT_XY) //
                .setLogoOffsetY(100) //
                //掩码栏
                .setNumberColor(Color.parseColor("#101010")) //
                .setNumberSize(40) //
                .setNumFieldOffsetY(160) //
                //Slogan
                .setSloganTextColor(Color.parseColor("#353535")) //
                .setSloganTextSize(20) //
                .setSloganOffsetY(220) //
                //登录按钮
                .setLogBtnText("立即登录") //
                .setLogBtnTextColor(Color.WHITE) //
                .setLogBtnHeight(50) //
                .setLogBtnTextSize(25) //
                .setLogBtnMarginLeftAndRight(45) //
                .setLogBtnBackgroundPath("login_btn_bg") //
                .setLogBtnOffsetY(330) //
                //其他登录方式
                .setSwitchAccHidden(true) //
                //协议栏
                .setAppPrivacyOne("房星网隐私政策", "https://m.fangstar.com/mobile/privacy2") //
                .setAppPrivacyTwo("房星网用户服务协议", "https://m.fangstar.com/mobile/privacy") //
                .setAppPrivacyColor(Color.parseColor("#999999"), Color.parseColor("#215BF1")) //
                .setPrivacyOffsetY(470) //
                .setPrivacyState(true) //
                .setProtocolGravity(Gravity.START) //
                .setPrivacyTextSize(13) //
                .setPrivacyMargin(50) //
                .setPrivacyBefore("为保障您的个人隐私权益，请在登录前仔细阅读") //
                .setCheckboxHidden(true) //
                //其他属性
                .setScreenOrientation(if (Build.VERSION.SDK_INT == 26) {
                    ActivityInfo.SCREEN_ORIENTATION_BEHIND
                } else {
                    ActivityInfo.SCREEN_ORIENTATION_SENSOR_PORTRAIT
                })
    }
    
}