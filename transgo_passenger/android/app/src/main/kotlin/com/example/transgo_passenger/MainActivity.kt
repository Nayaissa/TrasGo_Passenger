package com.example.transgo_passenger

import android.content.Intent
import android.net.Uri
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val phoneDialerChannel = "transgo_passenger/phone_dialer"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            phoneDialerChannel
        ).setMethodCallHandler { call, result ->
            if (call.method != "openDialer") {
                result.notImplemented()
                return@setMethodCallHandler
            }

            val phone = call.argument<String>("phone")?.trim().orEmpty()

            if (phone.isEmpty()) {
                result.success(false)
                return@setMethodCallHandler
            }

            try {
                val intent = Intent(Intent.ACTION_DIAL).apply {
                    data = Uri.parse("tel:$phone")
                }
                startActivity(intent)
                result.success(true)
            } catch (error: Exception) {
                result.success(false)
            }
        }
    }
}
