import 'package:flutter/material.dart';

import 'constants/i_colors.dart';
import 'screen/intro_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'سیستم ثبت سفارشات آسان توزین',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: IColors.mainColor),
        useMaterial3: true,
        fontFamily: "IranSans",
      ),
      debugShowCheckedModeBanner: false,
      home: const IntroPage(),
    );
  }
}
