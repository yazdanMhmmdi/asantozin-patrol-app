import 'dart:async';
import 'dart:convert';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/foundation.dart';
import 'package:nfc_manager/nfc_manager.dart';

class NfcUtils {
  Future<bool> checkAvailability() async {
    // Check availability
    return await NfcManager.instance.isAvailable();
  }

  startSession(Function(String payload, String serialNumber) onScanned) async {
    String payload, serialNumber;

    NfcManager.instance.startSession(
      onDiscovered: (NfcTag tag) async {
        // Do something with an NfcTag instance.
        //The NDEF Message was already parsed, if any

        debugPrint('tag serial number : ${getSerialNumber(tag)} ${getPayload(tag)}');

        payload = getPayload(tag);
        serialNumber = getSerialNumber(tag);

        onScanned.call(payload, serialNumber);
      },
    );
  }

  closeSession() {
    NfcManager.instance.stopSession();
  }

  String getSerialNumber(NfcTag tag) {
    Uint8List identifier = Uint8List.fromList(tag.data["mifareclassic"]['identifier']);
    return (identifier.map((e) => e.toRadixString(16).padLeft(2, '0')).join(':')).toUpperCase();
  }

  String getPayload(NfcTag tag) {
    Ndef? ndefTag = Ndef.from(tag);
    if (ndefTag == null) {
      print('Tag is not compatible with NDEF');
      return '';
    }

    if (ndefTag.cachedMessage != null) {
      var ndefMessage = ndefTag.cachedMessage!;
      //Each NDEF message can have multiple records, we will use the first one in our example
      if (ndefMessage.records.isNotEmpty && ndefMessage.records.first.typeNameFormat == NdefTypeNameFormat.nfcWellknown) {
        //If the first record exists as 1:Well-Known we consider this tag as having a value for us
        final wellKnownRecord = ndefMessage.records.first;
        debugPrint(wellKnownRecord.toString());

        ///Payload for a 1:Well Known text has the following format:
        ///[Encoding flag 0x02 is UTF8][ISO language code like en][content]

        if (wellKnownRecord.payload.first == 0x02) {
          //Now we know the encoding is UTF8 and we can skip the first byte
          final languageCodeAndContentBytes = wellKnownRecord.payload.skip(1).toList();
          //Note that the language code can be encoded in ASCI, if you need it be carfully with the endoding
          final languageCodeAndContentText = utf8.decode(languageCodeAndContentBytes);
          //Cutting of the language code
          final payload = languageCodeAndContentText.substring(2);

          return payload;
        }
      }
    }
    return '';
  }

  Future<void> openNFCSettings() async {
    await AppSettings.openAppSettings(type: AppSettingsType.nfc);
  }
}
