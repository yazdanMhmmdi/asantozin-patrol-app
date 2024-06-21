import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:patrol_application/constants/constants.dart';
import 'package:patrol_application/util/call_utils.dart';
import 'package:patrol_application/util/log.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../constants/i_colors.dart';

import '../constants/assets.dart';
import '../widget/i_typography.dart';

class AboutUsDialog extends StatelessWidget {
  String title;
  AboutUsDialog({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        alignment: Alignment.center,
        child: Container(
          width: 296,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                offset: Offset(3, 3),
                blurRadius: 12,
                color: Colors.black12,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(21),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  child: Image(
                    width: 120,
                    height: 120,
                    image: AssetImage(Assets.logo),
                    fit: BoxFit.fill, // use this
                  ),
                ),

                // SvgPicture.asset(
                //   Assets.dangerTriangle,
                //   width: 117,
                // ),
                const SizedBox(height: 8),
                Text(
                  kAboutUs,
                  textAlign: TextAlign.justify,
                  style: ITypography.Regular.copyWith(
                    fontSize: 14,
                    height: 1.8,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),

                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () async {
                      if (await canLaunchUrl(Uri.parse('https://$kSite'))) {
                        await launchUrl(Uri.parse('https://$kSite'));
                      } else {
                        throw 'Could not launch https://$kSite';
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.all(4),
                      child: Text(
                        kSite,
                        style: ITypography.Medium.copyWith(fontSize: 16, color: Colors.blue),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'تماس از 9 تا 19:',
                      style: ITypography.Medium.copyWith(fontSize: 14),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          CallUtils.openDialer(kSupportPhoneNumber);
                        },
                        child: Container(
                          margin: const EdgeInsets.all(4),
                          child: Text(
                            kSupportPhoneNumber,
                            style: ITypography.Medium.copyWith(fontSize: 16, color: Colors.blue),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'تماس 24 ساعته:',
                      style: ITypography.Medium.copyWith(fontSize: 14),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          CallUtils.openDialer(kavehSupportPhoneNumber);
                        },
                        child: Container(
                          margin: const EdgeInsets.all(4),
                          child: Text(
                            kavehSupportPhoneNumber,
                            style: ITypography.Medium.copyWith(fontSize: 16, color: Colors.blue),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: deleteButton(context),
                    ),
                    // const SizedBox(width: 16),
                    // Expanded(
                    //   flex: 1,
                    //   child: refuseButton(context),
                    // ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container refuseButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[400],
        borderRadius: BorderRadius.circular(4),
        boxShadow: const [
          BoxShadow(
            offset: Offset(2, 3),
            blurRadius: 12,
            color: Colors.black12,
          )
        ],
      ),
      child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => Navigator.pop(context, false),
            borderRadius: BorderRadius.circular(4),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'انصراف',
                  style: ITypography.Medium.copyWith(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )),
    );
  }

  Container deleteButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: IColors.mainColor,
        borderRadius: BorderRadius.circular(4),
        boxShadow: const [
          BoxShadow(
            offset: Offset(2, 3),
            blurRadius: 12,
            color: Colors.black12,
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.pop(context),
          borderRadius: BorderRadius.circular(4),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'بستن',
                style: ITypography.Medium.copyWith(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
