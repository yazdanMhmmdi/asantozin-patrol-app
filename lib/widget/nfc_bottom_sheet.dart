import 'package:flutter/material.dart';

import '../../../util/log.dart';
import '../../../util/nfc_utils.dart';
import 'i_typography.dart';

class NfcBottomSheet extends StatefulWidget {
  Function(String payload, String serialNumber) onTagScanned;

  NfcBottomSheet({super.key, required this.onTagScanned});

  @override
  State<NfcBottomSheet> createState() => _NfcBottomSheetState();
}

class _NfcBottomSheetState extends State<NfcBottomSheet> {
  NfcUtils nfcUtils = NfcUtils();

  Color iconColor = Colors.blue;

  @override
  void initState() {
    nfcUtils.checkAvailability().then((availble) {
      if (availble) {
        nfcUtils.startSession((payload, serialNumber) {
          Log().i(serialNumber);
          setState(() {
            iconColor = Colors.green;
          });
          Future.delayed(const Duration(milliseconds: 800)).then((value) {
            widget.onTagScanned.call(payload, serialNumber);
            Navigator.pop(context);
          });

          // patrol(rfidSerial: serialNumber);
        });
      } else {}
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Icon(
                  Icons.nfc,
                  color: iconColor,
                  size: 74,
                ),
                const SizedBox(height: 16),
                Text(
                  'برای اسکن دستگاه را نزدیک تگ کنید',
                  style: ITypography.Regular.copyWith(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    nfcUtils.closeSession();
    super.dispose();
  }
}
