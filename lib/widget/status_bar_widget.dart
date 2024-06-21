import 'package:flutter/material.dart';

import '../../constants/i_colors.dart';

class StatusBarWidget extends StatelessWidget {
  Color color;
  StatusBarWidget({super.key, this.color = IColors.mainColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      height: MediaQuery.of(context).viewPadding.top,
    );
  }
}
