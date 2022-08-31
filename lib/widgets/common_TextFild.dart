// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/material.dart';

///CommonTextFild----------------------------------------------------------///
class CommonTextFild extends StatelessWidget {
  CommonTextFild(
      {required this.name,
      required this.obscureText,
      required this.suffixIcon,
      required this.controller,
      required this.hintText,
      required this.errorText,
      required this.fillColor,
      required this.prefixIcon,
      required this.validator,
      Key? key})
      : super(key: key);
  String name;
  String hintText;
  bool obscureText = false;
  TextEditingController controller;
  Widget? suffixIcon;
  String? errorText;

  Color? fillColor;
  Widget? prefixIcon;
  String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,

      ///TextFormField--------------------------------------------------///
      child: TextFormField(
        validator: validator,
        style: const TextStyle(color: Colors.black),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: controller,
        decoration: InputDecoration(
          filled: true,
          hintText: hintText,
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none),
          fillColor: fillColor,
          prefixIcon: prefixIcon,
        ),
        obscureText: obscureText,
      ),
    );
  }
}

///BuildTextFild--------------------------------------------------------///
class BuildTextFild extends StatelessWidget {
  BuildTextFild(
      {required this.controller,
      required this.hintText,
      required this.fillColor,
      required this.prefixIcon,
      required this.keyboardType,
      required this.maxLength,
      required this.errorText,
      required this.validator,
      Key? key})
      : super(key: key);
  TextEditingController controller;
  String? hintText;
  Color? fillColor;
  Widget? prefixIcon;
  TextInputType? keyboardType;
  int? maxLength;

  String? errorText;
  String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,

      ///TextFormField--------------------------------------------------------///
      child: TextFormField(
        validator: validator,
        maxLength: maxLength,
        keyboardType: keyboardType,
        controller: controller,
        decoration: InputDecoration(
          errorText: errorText,
          prefixIcon: prefixIcon,
          filled: true,
          hintText: hintText,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none),
          fillColor: fillColor,
        ),
      ),
    );
  }
}
