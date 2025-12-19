import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Textfield_Custom extends StatelessWidget {
  Textfield_Custom(
      {super.key,
      this.inputFormatters,
      this.obscureText = false,
      this.validator,
      this.keyboardType,
      this.labelText,
      this.onChanged,
      this.prefixIcon,
      this.suffixIcon,
      this.controller,
      this.autovalidateMode,
      this.initialValue});
  String? Function(String?)? validator;
  bool obscureText;
  List<TextInputFormatter>? inputFormatters;
  void Function(String)? onChanged;
  TextInputType? keyboardType;
  String? labelText;
  Widget? prefixIcon, suffixIcon;
  AutovalidateMode? autovalidateMode;
  TextEditingController? controller;
  String? initialValue;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 12,
        right: 12,
      ),
      child: TextFormField(
        initialValue: initialValue,
        autovalidateMode: autovalidateMode,
        validator: validator,
        obscureText: obscureText,
        controller: controller,
        inputFormatters: inputFormatters,
        onChanged: onChanged,
        keyboardType: keyboardType,
        decoration: InputDecoration(
            labelText: labelText,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
                borderRadius: BorderRadius.circular(10))),
      ),
    );
  }
}