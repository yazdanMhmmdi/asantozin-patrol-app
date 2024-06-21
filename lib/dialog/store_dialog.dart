import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:patrol_application/widget/accept_button.dart';

import '../util/text_validator.dart';
import '../widget/material_text_field.dart';

class StoreDialog extends StatefulWidget {
  Function(String) onTap;

  StoreDialog({super.key, required this.onTap});

  @override
  State<StoreDialog> createState() => _StoreDialogState();
}

class _StoreDialogState extends State<StoreDialog> {
  late GlobalKey<FormState> _form;
  String storeId = "1";
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
                  const SizedBox(height: 16),
                  AcceptButton(
                      onTap: () {
                        if (_form.currentState!.validate()) {
                          widget.onTap.call(storeId);
                          Navigator.pop(context);
                        }
                      },
                      buttonText: 'تایید')
                ],
              )),
        ),
      ),
    );
  }

  void init() {
    _form = GlobalKey<FormState>();
  }
}
