package com.example.flutter_facetec_sdk

import android.app.Activity
import android.content.Intent
import android.icu.lang.UCharacter.GraphemeClusterBreak.L
import android.util.Log
import androidx.annotation.NonNull
import com.example.flutter_facetec_sdk.facetec.Config
import com.example.flutter_facetec_sdk.facetec.LivenessCheckProcessor
import com.example.flutter_facetec_sdk.facetec.NetworkingHelpers
import com.example.flutter_facetec_sdk.facetec.Processor
import com.facetec.sdk.FaceTecSDK
import com.facetec.sdk.FaceTecSDK.InitializeCallback

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import okhttp3.Call
import okhttp3.Callback
import okhttp3.Request
import okhttp3.Response
import org.json.JSONException
import org.json.JSONObject
import java.io.IOException

/** FlutterFacetecSdkPlugin */
class FlutterFacetecSdkPlugin : FlutterPlugin, MethodCallHandler, ActivityAware,
    PluginRegistry.ActivityResultListener {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var flutterPluginBinding: FlutterPlugin.FlutterPluginBinding
    private lateinit var activityPluginBinding: ActivityPluginBinding
    private var latestProcessor: Processor? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        this.flutterPluginBinding = flutterPluginBinding
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flutter_facetec_sdk")
        channel.setMethodCallHandler(this)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        this.activityPluginBinding = binding
        binding.addActivityResultListener(this)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activityPluginBinding = null!!
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activityPluginBinding = binding
        binding.addActivityResultListener(this)
    }

    override fun onDetachedFromActivity() {
        activityPluginBinding = null!!
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (requestCode == 1002 && resultCode == Activity.RESULT_OK) {
            if (latestProcessor != null) {
                return if (latestProcessor?.isSuccess == true) {
                    channel.invokeMethod("onFaceVerifyResponse", true)
                    true
                } else {
                    channel.invokeMethod("onFaceVerifyResponse", false)
                    false
                }
            }
        }

        return false
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "getPlatformVersion" -> {
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
            }

            "initialize" -> {
                // Optional - Preload resources related to the FaceTec SDK so that it can be run as soon as possible.
                //            Run this as soon as you think you might use the SDK for optimal start up performance.
                FaceTecSDK.preload(flutterPluginBinding.applicationContext)

                // Initialize FaceTec SDK

                // Initialize FaceTec SDK
                Config.initializeFaceTecSDKFromAutogeneratedConfig(
                    flutterPluginBinding.applicationContext,
                    object : InitializeCallback() {
                        override fun onCompletion(successful: Boolean) {
                            if (successful) {
                                Log.d(
                                    "FaceTecSDKSampleApp",
                                    "FaceTec SDK initialization was successful."
                                )
                            } else {
                                Log.d(
                                    "FaceTecSDKSampleApp",
                                    "FaceTec SDK initialization was unsuccessful."
                                )

                                Log.d(
                                    "FaceTecSDKSampleApp",
                                    FaceTecSDK.getStatus(flutterPluginBinding.applicationContext)
                                        .toString()
                                )
                            }
                        }
                    })

                result.success("start")
            }

            "startLiveCheckProcess" -> {
                startLiveCheckProcess()
                result.success("start")
            }

            else -> {
                result.notImplemented()
            }
        }
    }

    private fun startLiveCheckProcess() {
        getSessionToken(object : SessionTokenCallback {
            override fun onSessionTokenReceived(sessionToken: String?) {
                println("sessionToken: $sessionToken")
                latestProcessor =
                    LivenessCheckProcessor(sessionToken, activityPluginBinding.activity, channel)
            }
        })
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    interface SessionTokenCallback {
        fun onSessionTokenReceived(sessionToken: String?)
    }

    private fun getSessionToken(sessionTokenCallback: SessionTokenCallback) {
        // Do the network call and handle result
        val request = Request.Builder()
            .header("X-Device-Key", Config.DeviceKeyIdentifier)
            .header("User-Agent", FaceTecSDK.createFaceTecAPIUserAgentString(""))
            .header("X-User-Agent", FaceTecSDK.createFaceTecAPIUserAgentString(""))
            .url(Config.BaseURL + "/session-token")
            .get()
            .build()
        NetworkingHelpers.getApiClient().newCall(request).enqueue(object : Callback {
            override fun onFailure(call: Call, e: IOException) {
                e.printStackTrace()
                Log.d("FaceTecSDKSampleApp", "Exception raised while attempting HTTPS call.")

                // If this comes from HTTPS cancel call, don't set the sub code to NETWORK_ERROR.
                if (e.message != NetworkingHelpers.OK_HTTP_RESPONSE_CANCELED) {
                    Log.d("FaceTecSDKSampleApp", "Setting sub code to NETWORK_ERROR.")
                }
            }

            @Throws(IOException::class)
            override fun onResponse(call: Call, response: Response) {
                val responseString = response.body()!!.string()
                response.body()!!.close()
                try {
                    val responseJSON = JSONObject(responseString)
                    if (responseJSON.has("sessionToken")) {
                        Log.d("FaceTecSDKSampleApp", "Session token received.")
                        sessionTokenCallback.onSessionTokenReceived(responseJSON.getString("sessionToken"))
                    } else {
                        Log.d(
                            "FaceTecSDKSampleApp",
                            "JSON response did not contain session token."
                        )
                    }
                } catch (e: JSONException) {
                    e.printStackTrace()
                    Log.d(
                        "FaceTecSDKSampleApp",
                        "Exception raised while attempting to parse JSON result."
                    )
                }
            }
        })
    }

}
