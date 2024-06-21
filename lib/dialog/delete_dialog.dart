import 'package:flutter/material.dart';
import '../../../constants/i_colors.dart';

import '../util/text_validator.dart';
import '../widget/i_typography.dart';
import '../widget/material_text_field.dart';

class DeleteDialog extends StatefulWidget {
  String title;
  Function(String) onDeleteTapped;
  DeleteDialog({
    super.key,
    required this.title,
    required this.onDeleteTapped,
  });

  @override
  State<DeleteDialog> createState() => _DeleteDialogState();
}

class _DeleteDialogState extends State<DeleteDialog> {
  String storeId = "1";
  late GlobalKey<FormState> _form;

  @override
  void initState() {
    init();
    super.initState();
  }

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
                const Icon(
                  Icons.warning_rounded,
                  color: IColors.mainColor,
                  size: 96,
                ),
                // SvgPicture.asset(
                //   Assets.dangerTriangle,
                //   width: 117,
                // ),
                const SizedBox(height: 8),
                Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: ITypography.Bold.copyWith(
                    fontSize: 18,
                    height: 1.5,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                Form(
                  key: _form,
                  child: MaterialTextField(
                    labelText: "شماره فروشگاه",
                    onTextChanged: (text) {
                      setState(() {
                        storeId = text;
                      });
                    },
                    initialText: storeId,
                    isPhoneNumber: true,
                    validator: (text) {
                      return TextValidator().storeId(text);
                    },
                  ),
                ),

                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: deleteButton(context),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 1,
                      child: refuseButton(context),
                    ),
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
          onTap: () {
            if (_form.currentState!.validate()) {
              widget.onDeleteTapped.call(storeId);
              Navigator.pop(context, true);
            }
          },
          borderRadius: BorderRadius.circular(4),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'بله',
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

  void init() {
    _form = GlobalKey<FormState>();
  }
}
