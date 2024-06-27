import 'package:flutter/material.dart';

import 'package:flutter_test1/common/color_extension.dart';

enum RoundButtonType { bgGradient, textGradient }

class RoundButton extends StatelessWidget {
  final RoundButtonType type;
  final String title;
  final VoidCallback onPressed;
  final bool disabled; // Add the disabled parameter

  const RoundButton({
    super.key,
    this.type = RoundButtonType.textGradient,
    required this.title,
    required this.onPressed,
    this.disabled = false, // Set default to not disabled
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: disabled ? null : onPressed, // Disable if 'disabled' is true
      height: 50,
      minWidth: double.maxFinite,
      color: disabled // Changes for disabled state
          ? Colors.grey // Use a greyed-out color when disabled
          : (type == RoundButtonType.bgGradient
              ? TColor.primaryColor1
              : TColor.white),
      textColor: disabled
          ? Colors.grey.shade400 // Softer color for text when disabled
          : (type == RoundButtonType.bgGradient
              ? TColor.white
              : TColor.primaryColor1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: Text(
        title,
        style: TextStyle(
            color: disabled
                ? Colors.grey.shade400
                : (type == RoundButtonType.bgGradient
                    ? TColor.white
                    : TColor.primaryColor1),
            fontSize: 20,
            fontWeight: FontWeight.w700),
      ),
    );
  }
}
