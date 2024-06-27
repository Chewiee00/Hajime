import 'package:flutter/material.dart';
import 'package:flutter_test1/common/color_extension.dart';

class RoundTextField extends StatelessWidget {
  const RoundTextField({
    Key? key,
    this.controller,
    required this.hintText,
    this.margin,
    this.keyboardType,
    this.validator,
    this.obscureText = false,
  }) : super(key: key);

  final TextEditingController? controller;
  final String hintText;
  final EdgeInsets? margin;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: TColor.lightGray,
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        keyboardType: keyboardType,
        controller: controller,
        obscureText: obscureText,
        validator: validator, // Assigning the validator function here
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(color: TColor.gray, fontSize: 16),
        ),
      ),
    );
  }
}
