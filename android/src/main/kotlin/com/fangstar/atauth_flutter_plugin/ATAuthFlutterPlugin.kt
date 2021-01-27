package com.fangstar.atauth_flutter_plugin

import android.content.Context
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry.Registrar

/** ATAuthFlutterPlugin */
class ATAuthFlutterPlugin : FlutterPlugin {
    
    private val CHANNEL_NAME = "atauth_flutter_plugin"
    private var mChannel: MethodChannel? = null

    companion object {
        @JvmStatic
        var enableLog = false

        @JvmStatic
        private var sAuthUIConfig: IAuthUIConfig? = null
        
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            ATAuthFlutterPlugin().setupChannel(registrar.messenger(), registrar.context())
        }
        
        @JvmStatic
        fun setupAuthUIConfig(authUIConfig: IAuthUIConfig) {
            sAuthUIConfig = authUIConfig
        }
        
        @JvmStatic
        fun getAuthUIConfig(): IAuthUIConfig? = sAuthUIConfig
    }
    
    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        setupChannel(flutterPluginBinding.binaryMessenger, flutterPluginBinding.applicationContext)
    }
    
    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        teardownChannel()
    }
    
    private fun setupChannel(messenger: BinaryMessenger, context: Context) {
        val channel = MethodChannel(messenger, CHANNEL_NAME)
        mChannel = channel
        val handler = MethodCallHandlerImpl(context)
        channel.setMethodCallHandler(handler)
    }
    
    private fun teardownChannel() {
        mChannel?.setMethodCallHandler(null)
        mChannel = null
    }
}
