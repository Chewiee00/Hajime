import 'package:flutter/material.dart';

class TabButton extends StatelessWidget {
  final String iconNormal;
  final String iconActive;
  final VoidCallback onTap;
  final bool isActive;
  const TabButton(
      {super.key,
      required this.iconNormal,
      required this.iconActive,
      required this.isActive,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            isActive ? iconActive : iconNormal,
            width: 35,
            height: 35,
            fit: BoxFit.fitWidth,
          )
        ],
      ),
    );
  }
}
