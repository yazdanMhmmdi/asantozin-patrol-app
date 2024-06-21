import 'dart:async';

import 'package:flutter/material.dart';
import 'package:patrol_application/constants/assets.dart';
import 'package:patrol_application/constants/i_colors.dart';
import 'package:patrol_application/constants/strings.dart';
import 'package:patrol_application/screen/home_page.dart';
import 'package:patrol_application/widget/i_typography.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  @override
  void initState() {
    Timer(const Duration(seconds: 4), () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          color: IColors.mainColor.withOpacity(0.4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        width: 200,
                        height: 200,
                        image: AssetImage(Assets.logo),
                        fit: BoxFit.fill, // use this
                      ),
                      const SizedBox(height: 32),
                      Text(
                        Strings.kMainTitle,
                        style: ITypography.Bold.copyWith(fontSize: 20, color: IColors.logFontColor),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        Strings.kSubTitle,
                        style: ITypography.Medium.copyWith(fontSize: 20, color: IColors.mainColor),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(
                    height: 32,
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
            ],
          ),
        ),
      ),
    );
  }
}
