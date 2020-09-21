package com.fangstar.atauth_flutter_plugin

import android.content.Context
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel.*

class MethodCallHandlerImpl(private val ctx: Context) : MethodCallHandler {
    
    companion object {
        private const val TAG = "MethodCallHandlerImpl"
    }
    
    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        Log.w(TAG, "onMethodCall: ${call.method}")
        when(call.method) {
            ChannelMethods.GET_PLATFORM_VERSION -> result.success("Android ${android.os.Build.VERSION.RELEASE}")
            else                                    -> result.notImplemented()
        }
    }
    
    object ChannelMethods {
        const val GET_PLATFORM_VERSION = "getPlatformVersion"
    }
}