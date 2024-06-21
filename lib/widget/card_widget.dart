import 'package:flutter/material.dart';
import 'package:patrol_application/constants/i_colors.dart';
import 'package:patrol_application/widget/i_typography.dart';

class CardWidget extends StatelessWidget {
  final Icon icon;
  final String? title, subTitle;
  final Function onTap;
  final BorderRadius borderRadius;

  final bool isLoading;

  CardWidget({
    super.key,
    required this.icon,
    required this.subTitle,
    required this.title,
    required this.onTap,
    required this.borderRadius,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: IColors.mainColor.withOpacity(0.2),
        borderRadius: borderRadius,
      ),
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                onTap.call();
              },
              borderRadius: borderRadius,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(width: 8),
                    if (isLoading) ...[_progressLoading()] else ...[icon],
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title!,
                          style: ITypography.Medium.copyWith(color: Colors.black87, fontSize: 14),
                        ),
                        subTitle != null
                            ? Text(
                                subTitle!,
                                style: ITypography.Medium.copyWith(color: Colors.black54, fontSize: 14),
                              )
                            : Container(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _progressLoading() {
    return Center(
      child: Container(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }
}
