import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:patrol_application/constants/i_colors.dart';
import 'package:patrol_application/widget/i_typography.dart';

class AcceptButton extends StatelessWidget {
  Function onTap;
  String? buttonText;
  Color? buttonColor;
  bool? isLoading;
  Widget? icon;
  bool isDisable;
  AcceptButton({
    super.key,
    required this.onTap,
    required this.buttonText,
    this.isLoading = false,
    this.buttonColor = IColors.mainColor,
    this.icon,
    this.isDisable = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: isDisable ? Colors.grey : buttonColor, boxShadow: const [
        BoxShadow(
          blurRadius: 6,
          offset: Offset(2, 3),
          color: Colors.black26,
        ),
      ]),
      child: Stack(
        children: [
          Center(
              child: !isLoading!
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        icon ?? Container(),
                        icon != null ? const SizedBox(width: 8) : Container(),
                        Text(
                          buttonText!,
                          style: ITypography.Medium.copyWith(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    )
                  : LoadingAnimationWidget.prograssiveDots(color: Colors.white, size: 40)),
          Material(
            color: Colors.transparent,
            child: IgnorePointer(
              ignoring: isDisable,
              child: InkWell(
                borderRadius: BorderRadius.circular(4),
                onTap: !isLoading! ? () => onTap.call() : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
