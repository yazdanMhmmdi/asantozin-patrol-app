import 'package:flutter/material.dart';
import 'package:patrol_application/widget/i_typography.dart';

import '../constants/constants.dart';
import '../constants/i_colors.dart';
import '../util/call_utils.dart';
import '../widget/card_widget.dart';
import '../widget/status_bar_widget.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StatusBarWidget(),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text(
                'تماس با واحد فروش کشتارگاه',
                style: ITypography.Medium.copyWith(fontSize: 18, color: Colors.black87),
              ),
            ),
            const SizedBox(height: 16),
            CardWidget(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
              ),
              onTap: () {
                CallUtils.openDialer(kSellPhoneNumber1);
              },
              icon: const Icon(
                Icons.call,
                color: IColors.mainColor,
                size: 28,
              ),
              title: 'آقای محمدی',
              subTitle: null,
            ),
            const SizedBox(height: 8),
            CardWidget(
              borderRadius: BorderRadius.zero,
              onTap: () {
                CallUtils.openDialer(kSellPhoneNumber2);
              },
              icon: const Icon(
                Icons.call,
                color: IColors.mainColor,
                size: 28,
              ),
              title: 'خانم بهزادی',
              subTitle: null,
            ),
            const SizedBox(height: 8),
            CardWidget(
              borderRadius: BorderRadius.zero,
              onTap: () {
                CallUtils.openDialer(kSellPhoneNumber3);
              },
              icon: const Icon(
                Icons.call,
                color: IColors.mainColor,
                size: 28,
              ),
              title: 'آقای فداکار',
              subTitle: null,
            ),
            const SizedBox(height: 8),
            CardWidget(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
              onTap: () {
                CallUtils.openDialer(kSellPhoneNumber4);
              },
              icon: const Icon(
                Icons.call,
                color: IColors.mainColor,
                size: 28,
              ),
              title: 'آقای کامیاب',
              subTitle: null,
            ),
          ],
        ),
      ),
    );
  }
}
