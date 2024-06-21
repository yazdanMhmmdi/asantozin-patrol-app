import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:patrol_application/dialog/order_dialog.dart';
import 'package:patrol_application/util/log.dart';
import 'package:permission_handler/permission_handler.dart';

import '../constants/constants.dart';
import '../constants/i_colors.dart';
import '../constants/strings.dart';
import '../dialog/about_us_dialog.dart';
import '../util/date_stuff.dart';
import '../util/i_sms.dart';
import '../util/nfc_utils.dart';
import '../util/store_on_device.dart';
import '../widget/card_widget.dart';
import '../widget/i_typography.dart';
import '../widget/nfc_bottom_sheet.dart';
import '../widget/status_bar_widget.dart';
import 'camera_page.dart';
import 'contact_page.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ISms sms = ISms();
  StoreOnDevice storeOnDevice = StoreOnDevice();
  NfcUtils nfcUtils = NfcUtils();
  bool barcodeBtnLoading = false, rfidBtnLoading = false;

  @override
  void initState() {
    sms.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StatusBarWidget(),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Strings.kMainTitle,
                        style: ITypography.Medium.copyWith(
                          fontSize: 18,
                          color: Colors.black87,
                          height: 1.7,
                        ),
                      ),
                      Text(
                        Strings.kSubTitle,
                        style: ITypography.Medium.copyWith(
                          fontSize: 18,
                          color: IColors.mainColor,
                          height: 1.7,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                CardWidget(
                  isLoading: barcodeBtnLoading,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                  onTap: () async {
                    grantPermissions().then((value) {
                      if (value) {
                        Navigator.push(context, MaterialPageRoute(builder: (c) => const CameraPage())).then((value) {
                          if (value != "-1") {
                            // patrol(activities: state.activities, routine: state.routine, tagKey: value, isNfc: false);
                            sendData(context, payload: value, isRFID: false);
                          }
                        });
                      } else {
                        showSnackBar(context: context, text: "دسترسی های لازم داده نشد");
                      }
                    });
                  },
                  icon: const Icon(
                    Icons.qr_code,
                    color: IColors.mainColor,
                    size: 28,
                  ),
                  title: 'اسکن بارکد',
                  subTitle: null,
                ),
                const SizedBox(height: 8),
                CardWidget(
                  isLoading: rfidBtnLoading,
                  borderRadius: BorderRadius.zero,
                  icon: const Icon(
                    Icons.nfc,
                    color: IColors.mainColor,
                    size: 28,
                  ),
                  title: 'اسکن RFID',
                  subTitle: null,
                  onTap: () async {
                    nfcUtils.checkAvailability().then((avaible) {
                      if (avaible) {
                        grantPermissions().then((value) {
                          if (value) {
                            showModalBottomSheet(
                                context: context,
                                isDismissible: false,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(16.0),
                                  ),
                                ),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                builder: (context) {
                                  return NfcBottomSheet(
                                    onTagScanned: (payload, serialNumber) {
                                      sendData(context, payload: serialNumber, isRFID: true);
                                    },
                                  );
                                });
                          } else {
                            showSnackBar(context: context, text: 'دسترسی های لازم داده نشد');
                          }
                        });
                      } else {
                        showSnackBar(context: context, text: 'NFC دستگاه شما خاموش است');
                        Future.delayed(const Duration(milliseconds: 1500)).then((value) => nfcUtils.openNFCSettings());
                      }
                    });
                  },
                ),
                const SizedBox(height: 8),
                CardWidget(
                  isLoading: rfidBtnLoading,
                  borderRadius: BorderRadius.zero,
                  icon: const Icon(
                    Icons.add_shopping_cart,
                    color: IColors.mainColor,
                    size: 28,
                  ),
                  title: 'ثبت سفارش',
                  subTitle: null,
                  onTap: () async {
                    showGeneralDialog(
                        context: context,
                        barrierLabel: "Barrier",
                        barrierDismissible: true,
                        barrierColor: Colors.black.withOpacity(0.5),
                        transitionDuration: const Duration(milliseconds: 300),
                        pageBuilder: (_, __, ___) {
                          return OrderDialog();
                        });
                  },
                ),
                const SizedBox(height: 8),
                CardWidget(
                  borderRadius: BorderRadius.zero,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ContactPage()));
                  },
                  icon: const Icon(
                    Icons.call,
                    color: IColors.mainColor,
                    size: 28,
                  ),
                  title: 'تماس با واحد فروش کشتارگاه',
                  subTitle: null,
                ),
                const SizedBox(height: 8),
                CardWidget(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                  onTap: () {
                    showGeneralDialog(
                        context: context,
                        barrierLabel: "Barrier",
                        barrierDismissible: true,
                        barrierColor: Colors.black.withOpacity(0.5),
                        transitionDuration: const Duration(milliseconds: 300),
                        pageBuilder: (_, __, ___) {
                          return AboutUsDialog(
                            title: 'درباره ما',
                          );
                        });
                  },
                  icon: const Icon(
                    Icons.question_mark,
                    color: IColors.mainColor,
                    size: 28,
                  ),
                  title: 'درباره...',
                  subTitle: null,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                'نگارش ${Strings.kAppVersion}',
                style: ITypography.Regular.copyWith(fontSize: 14, color: Colors.black45),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void sendData(BuildContext context, {required String payload, required bool isRFID}) async {
    late Position po;
    _startLoading(isRFID: isRFID);
    try {
      po = await _determinePosition();
    } catch (e) {
      if (e == "Location services are disabled.") {
        showSnackBar(context: context, text: 'لوکیشن غیر فعال است آنرا فعال کنید');
        Future.delayed(const Duration(seconds: 2)).then((value) => AppSettings.openAppSettings(type: AppSettingsType.location));
        _stopLoading(isRFID: isRFID);
        return;
      }
    }

    ISms sms = ISms();
    if (await sms.grantPermission()) {
      sms.send(
          reciverNumber: kRecieverNumber,
          message: """
${payload}
${po.latitude}
${po.longitude}
""",
          onChanged: (SmsSendStatus status) {
            if (status == SmsSendStatus.SENT) {
            } else if (status == SmsSendStatus.DELIVERED) {
              _stopLoading(isRFID: isRFID);

              showSnackBar(context: context, text: 'سرکشی با موفقیت انجام شد');
            } else {
              _stopLoading(isRFID: isRFID);
              showSnackBar(
                context: context,
                text: 'درخواست با خطا روبرو شد',
              );
            }
          });
    } else {
      showSnackBar(context: context, text: 'دسترسی های لازم داده نشد');
    }
  }

  showSnackBar({required BuildContext context, required String text}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(milliseconds: 5000),
        content: Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              text,
            ))));
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  Future<bool> grantPermissions() async {
    if (await Permission.camera.request().isGranted && await Permission.sms.request().isGranted && await Permission.location.request().isGranted) {
      return true;
    } else {
      return false;
    }
  }

  void _startLoading({required bool isRFID}) {
    if (isRFID) {
      rfidBtnLoading = true;
    } else {
      barcodeBtnLoading = true;
    }
    setState(() {});
  }

  void _stopLoading({required bool isRFID}) {
    if (isRFID) {
      rfidBtnLoading = false;
    } else {
      barcodeBtnLoading = false;
    }
    setState(() {});
  }
}
