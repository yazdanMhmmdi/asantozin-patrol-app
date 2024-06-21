import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../constants/i_colors.dart';

class MaterialTextField extends StatefulWidget {
  String? labelText;
  bool? obscureText;
  double? width;
  String? Function(String)? validator;
  bool? isRTL;
  bool isPhoneNumber = false;
  bool isEnable = true;
  Function(String) onTextChanged;
  String initialText;
  MaterialTextField({
    super.key,
    required this.labelText,
    this.obscureText = false,
    required this.onTextChanged,
    required this.initialText,
    this.validator,
    this.isRTL = false,
    this.width,
    this.isPhoneNumber = false,
    this.isEnable = true,
  });

  @override
  State<MaterialTextField> createState() => _MaterialTextFieldState();
}

class _MaterialTextFieldState extends State<MaterialTextField> {
  String? errorText;
  var maskFormatter = MaskTextInputFormatter(mask: '# ### ### ## ##', filter: {"#": RegExp(r'[0-9]')}, type: MaskAutoCompletionType.lazy);
  TextEditingController? controller;
  @override
  void initState() {
    controller = TextEditingController(text: /*widget.isPhoneNumber ? maskFormatter.maskText(widget.initialText) :*/ widget.initialText);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SizedBox(
        width: widget.width ?? double.infinity,
        child: TextFormField(
          enabled: widget.isEnable,
          controller: controller,
          keyboardType: widget.isPhoneNumber ? TextInputType.phone : TextInputType.text,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          /*inputFormatters: [widget.isPhoneNumber ? maskFormatter : MaskTextInputFormatter()],*/
          onChanged: (s) {
            String text = s;
            //!
            // if (maskFormatter.unmaskText(s).isNotEmpty && widget.isPhoneNumber) {
            //   text = maskFormatter.unmaskText(s);
            // }
            widget.onTextChanged.call(text);
            // setState(() {
            //   errorText = widget.validator!.call(text);
            // });
          },
          validator: (text) {
            // if (maskFormatter.unmaskText(text!).isNotEmpty && widget.isPhoneNumber) {
            //   text = maskFormatter.unmaskText(text);
            // }
            return widget.validator!.call(text!);
          },
          textDirection: widget.isRTL! ? TextDirection.rtl : TextDirection.ltr,
          obscureText: widget.obscureText!,
          style: const TextStyle(),
          textAlign: widget.isRTL! ? TextAlign.right : TextAlign.left,
          decoration: InputDecoration(
            labelText: widget.labelText,
            fillColor: Colors.white,
            errorText: errorText,
            helperText: " ",
            //  helperStyle: <Your errorStyle>,
            filled: true,
            hintTextDirection: widget.isRTL! ? TextDirection.rtl : TextDirection.ltr,
            labelStyle: const TextStyle(
              color: IColors.mainColor,
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black38,
              ), //<-- SEE HERE
            ),
            border: const OutlineInputBorder(
              borderSide: BorderSide(
                color: IColors.mainColor,
              ), //<-- SEE HERE
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: IColors.mainColor, width: 2), //<-- SEE HERE
            ),

            // suffixIcon: Icon(
            //   Icons.person,
            //   color: IColors.blue,
            // ),
          ),
        ),
      ),
    );
  }
}
