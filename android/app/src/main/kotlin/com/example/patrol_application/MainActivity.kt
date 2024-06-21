package com.asantozinpatrol.app


import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.app.PendingIntent
import android.content.Intent
import android.content.IntentFilter
import android.content.BroadcastReceiver
import android.telephony.SmsManager
import java.util.logging.Logger
import android.content.Context
import android.app.Activity

import com.asantozinpatrol.app.Constants.ACTION_SMS_SENT
import com.asantozinpatrol.app.Constants.ACTION_SMS_DELIVERED
import com.asantozinpatrol.app.Constants.SMS_BODY
import com.asantozinpatrol.app.Constants.SMS_DELIVERED_BROADCAST_REQUEST_CODE
import com.asantozinpatrol.app.Constants.SMS_SENT_BROADCAST_REQUEST_CODE
import com.asantozinpatrol.app.Constants.SMS_TO
import androidx.core.content.ContextCompat
import	android.util.Log;
class MainActivity: FlutterActivity() {
    

    private val CHANNEL = "sms_channel"
    val TAG = "TRACK_SMS_STATUS"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Set up the MethodChannel with the same name as defined in Dart
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "sendSms") {
                var flutterMethod: MethodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL);
                // Perform platform-specific operations and obtain the result
                val data = sendSms(call.argument<String>("number"),call.argument<String>("message"), flutterMethod)
                

                // Send the result back to Flutter
                result.success(data)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun sendSms(phoneNumber: String?, message: String?, flutterMethod: MethodChannel) : String {
        val delivered = "SMS_DELIVERED"

        var sms: SmsManager = SmsManager.getDefault()

        // val sentPI: PendingIntent = PendingIntent.getBroadcast(this, 0, Intent("SMS_SENT"), 0)
        var parts: ArrayList<String> = sms.divideMessage(message)


        val pendingIntents = getMultiplePendingIntents(parts.size)


        sms.sendMultipartTextMessage(phoneNumber, null, parts, pendingIntents.first, pendingIntents.second)
        // return SmsManager.getDefault().sendTextMessage(phoneNumber, null, message, null, null).toString();

        //---when the SMS has been delivered---
        registerReceiver(object : BroadcastReceiver() {
            override fun onReceive(arg0: Context?, arg1: Intent?) {
                when (resultCode) {
                    Activity.RESULT_OK -> {
                        Log.d("KOTLIN_TAG", "OK RESULT")
                        flutterMethod.invokeMethod("getSmsStatus", "delivered");
                    }
                    Activity.RESULT_CANCELED -> {
                        Log.d("KOTLIN_TAG", "your log message")
                        flutterMethod.invokeMethod("getSmsStatus", "failure");

                    }
                }
            }
        }, IntentFilter(ACTION_SMS_DELIVERED), ContextCompat.RECEIVER_EXPORTED)

        return "1";
    }

    
    private fun getMultiplePendingIntents(size: Int): Pair<ArrayList<PendingIntent>, ArrayList<PendingIntent>> {
        val sentPendingIntents = arrayListOf<PendingIntent>()
        val deliveredPendingIntents = arrayListOf<PendingIntent>()
        for (i in 1..size) {
            val pendingIntents = getPendingIntents()
            sentPendingIntents.add(pendingIntents.first)
            deliveredPendingIntents.add(pendingIntents.second)
        }
        return Pair(sentPendingIntents, deliveredPendingIntents)
    }

        private fun getPendingIntents(): Pair<PendingIntent, PendingIntent> {
        val sentIntent = Intent(ACTION_SMS_SENT).apply {
            `package` = context.applicationContext.packageName
            flags = Intent.FLAG_RECEIVER_REGISTERED_ONLY
        }
        val sentPendingIntent = PendingIntent.getBroadcast(
            context,
            SMS_SENT_BROADCAST_REQUEST_CODE,
            sentIntent,
            PendingIntent.FLAG_ONE_SHOT or PendingIntent.FLAG_IMMUTABLE
        )

        val deliveredIntent = Intent(ACTION_SMS_DELIVERED).apply {
            `package` = context.applicationContext.packageName
            flags = Intent.FLAG_RECEIVER_REGISTERED_ONLY
        }
        val deliveredPendingIntent = PendingIntent.getBroadcast(
            context,
            SMS_DELIVERED_BROADCAST_REQUEST_CODE,
            deliveredIntent,
            PendingIntent.FLAG_ONE_SHOT or PendingIntent.FLAG_IMMUTABLE
        )

        return Pair(sentPendingIntent, deliveredPendingIntent)
    }
    
}
