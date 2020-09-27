package com.example.atauth_flutter_plugin_example

import io.flutter.app.FlutterApplication

class App : FlutterApplication() {
    
    override fun onCreate() {
        super.onCreate()
        
        AuthUIConfigImpl.setup()
        
    }
    
}