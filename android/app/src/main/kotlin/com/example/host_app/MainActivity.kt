package com.example.host_app

import android.content.ComponentName
import android.content.pm.PackageManager
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "app.icon"

    // Must match exactly the android:name values in AndroidManifest.xml (without package prefix)
    private val aliases = listOf("DefaultIcon", "IconOne", "IconTwo")

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "setLauncherIcon" -> {
                        val icon = call.argument<String>("icon") ?: "DefaultIcon"

                        // Validate that the requested alias is in our known list
                        if (!aliases.contains(icon)) {
                            result.error("INVALID", "Unknown alias: $icon", null)
                            return@setMethodCallHandler
                        }

                        try {
                            setLauncherIcon(icon)
                            result.success(true)
                        } catch (e: Exception) {
                            Log.e("MainActivity", "setLauncherIcon failed", e)
                            result.error("ERROR", e.message ?: "Failed to set icon", null)
                        }
                    }
                    else -> result.notImplemented()
                }
            }
    }

    @Throws(Exception::class)
    private fun setLauncherIcon(targetAlias: String) {
        val pm = packageManager
        val pkg = applicationContext.packageName

        Log.i("MainActivity", "Switching icon to: $targetAlias")

        aliases.forEach { alias ->
            // Full class name e.g. com.example.host_app.DefaultIcon
            val className = "$pkg.$alias"
            val comp = ComponentName(pkg, className)

            val newState = if (alias == targetAlias)
                PackageManager.COMPONENT_ENABLED_STATE_ENABLED
            else
                PackageManager.COMPONENT_ENABLED_STATE_DISABLED

            try {
                pm.setComponentEnabledSetting(comp, newState, PackageManager.DONT_KILL_APP)
                Log.i("MainActivity", "Set $className → ${if (newState == PackageManager.COMPONENT_ENABLED_STATE_ENABLED) "ENABLED" else "DISABLED"}")
            } catch (e: IllegalArgumentException) {
                throw Exception("Component not found in manifest: $className", e)
            }
        }
    }
}