import 'package:flutter/material.dart';

class FormTextField extends StatefulWidget {
  final TextEditingController? controller;
  final Widget suffixIcon;
  final TextInputType keyboardtype;
  final bool isPass;
  final String? Function(String?)? function;
  final int? maxLength;
  final void Function(String)? onSubmitted;
  const FormTextField(
      {Key? key,
      required this.controller,
      required this.suffixIcon,
      this.keyboardtype = TextInputType.text,
      this.isPass = false,
      this.function,
      this.maxLength,
      this.onSubmitted})
      : super(key: key);

  @override
  State<FormTextField> createState() => _FormTextFieldState();
}

class _FormTextFieldState extends State<FormTextField> {
  bool isVisible = true;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      keyboardType: widget.keyboardtype,
      obscureText: widget.isPass ? isVisible : false,
      maxLength: widget.maxLength,
      onSubmitted: widget.onSubmitted,
      decoration: InputDecoration(
          counterText: "",
          isDense: true,
          fillColor: Colors.grey.withOpacity(0.2),
          filled: true,
          suffixIcon: GestureDetector(
              onTap: () {
                if (widget.isPass == true) {
                  setState(() {
                    isVisible = !isVisible;
                  });
                }
              },
              child: widget.suffixIcon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
          )),
    );
  }
}
