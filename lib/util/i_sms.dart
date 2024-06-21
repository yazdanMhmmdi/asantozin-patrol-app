// import 'package:another_telephony/telephony.dart';
import 'dart:ffi';

import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:patrol_application/util/log.dart';
// import 'package:telephony/telephony.dart';

enum SmsSendStatus { SENT, DELIVERED, FAILURE }

class ISms {
  // Permission? permission;
  // Telephony? _telephony;
  // Create an instance of the MethodChannel
  final MethodChannel platformChannel = const MethodChannel('sms_channel');

  init() {
    // _telephony = Telephony.instance;
  }

  Future<void> send({required String reciverNumber, required String message, required Function(SmsSendStatus) onChanged}) async {
    try {
      await platformChannel.invokeMethod("sendSms", {"number": reciverNumber, "message": message});

      // counter for method listener to prevent from repeatition
      var callCounter = 0;
      platformChannel.setMethodCallHandler((call) async {
        if (call.method == "getSmsStatus" && callCounter < 1) {
          Log().i('flutter gets SMS from kotlin ${call.arguments}');
          if (call.arguments == "delivered") {
            onChanged.call(SmsSendStatus.DELIVERED);
            callCounter++;
          } else {
            onChanged.call(SmsSendStatus.FAILURE);
          }
        } else {}
      });
    } catch (e) {
      onChanged.call(SmsSendStatus.FAILURE);
    }
    // await _telephony!.sendSms(
    //     to: reciverNumber,
    //     message: message,
    //     isMultipart: true,
    //     statusListener: (SendStatus status) {
    //       // Handle the status
    //       if (status == SendStatus.SENT) {
    //         Log().i('ISms:SENT');
    //         onChanged.call(SmsSendStatus.SENT);
    //       } else if (status == SendStatus.DELIVERED) {
    //         Log().i('ISms:DELIVERED');
    //         onChanged.call(SmsSendStatus.DELIVERED);
    //       }
    //     });
  }

  Future<bool> grantPermission() async {
    bool? p = await Permission.sms.request().isGranted;
    if (p != null) {
      return p;
    } else {
      return false;
    }
  }
}
