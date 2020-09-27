package com.fangstar.atauth_flutter_plugin

import com.mobile.auth.gatewayauth.PhoneNumberAuthHelper
import io.flutter.plugin.common.MethodChannel

interface IAuthUIConfig {
    
    fun configAuthUI(helper: PhoneNumberAuthHelper, result: MethodChannel.Result)
    
}