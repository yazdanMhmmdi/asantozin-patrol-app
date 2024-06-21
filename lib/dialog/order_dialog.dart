import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:patrol_application/util/i_sms.dart';
import 'package:patrol_application/widget/accept_button.dart';

import '../../../constants/i_colors.dart';
import '../constants/constants.dart';
import '../util/text_validator.dart';
import '../widget/i_typography.dart';
import '../widget/material_text_field.dart';

class OrderDialog extends StatefulWidget {
  List<String> products = ['', '', ''];
  bool isLoading = false;

  OrderDialog({
    super.key,
  });

  @override
  State<OrderDialog> createState() => _OrderDialogState();
}

class _OrderDialogState extends State<OrderDialog> {
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
                MaterialTextField(
                  labelText: "محصول اول",
                  onTextChanged: (text) {
                    setState(() {
                      widget.products[0] = text;
                    });
                  },
                  initialText: widget.products[0].toString(),
                  isPhoneNumber: true,
                  validator: (text) {
                    return TextValidator().orderItem(text);
                  },
                ),
                const SizedBox(height: 8),
                MaterialTextField(
                  labelText: "محصول دوم",
                  onTextChanged: (text) {
                    setState(() {
                      widget.products[1] = text;
                    });
                  },
                  initialText: widget.products[1].toString(),
                  isPhoneNumber: true,
                  validator: (text) {
                    return TextValidator().orderItem(text);
                  },
                ),
                const SizedBox(height: 8),
                MaterialTextField(
                  labelText: "محصول سوم",
                  onTextChanged: (text) {
                    setState(() {
                      widget.products[2] = text;
                    });
                  },
                  initialText: widget.products[2].toString(),
                  isPhoneNumber: true,
                  validator: (text) {
                    return TextValidator().orderItem(text);
                  },
                ),
                const SizedBox(height: 16),
                AcceptButton(
                    isLoading: widget.isLoading,
                    onTap: () {
                      setState(() {
                        widget.isLoading = true;
                      });
                      ISms iSms = ISms();
                      iSms.send(
                          reciverNumber: kRecieverNumber,
                          message: """
${widget.products[0]}
${widget.products[1]}
${widget.products[2]}
""",
                          onChanged: (SmsSendStatus status) {
                            if (status == SmsSendStatus.DELIVERED || status == SmsSendStatus.FAILURE) {
                              widget.isLoading = false;
                              setState(() {});
                              showSnackBar(context: context, text: 'ثبت سفارش با موفقیت انجام شد');

                              Navigator.pop(context);
                            }
                          });
                    },
                    buttonText: 'ثبت سفارش')
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

  showSnackBar({required BuildContext context, required String text}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(milliseconds: 5000),
        content: Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              text,
            ))));
  }
}
