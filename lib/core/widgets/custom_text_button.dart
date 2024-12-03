import 'package:dev2dev/core/config/size_config.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton(
      {super.key,
      required this.onPressedFunction,
      required this.buttonText,
      required this.backgroundColor,
      required this.foregroundColor});
  final VoidCallback? onPressedFunction;
  final Widget buttonText;
  final Color foregroundColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: SizeConfig.height(50),
      child: TextButton(
          style: TextButton.styleFrom(
              foregroundColor:
                  onPressedFunction == null ? Colors.grey : foregroundColor,
              backgroundColor: onPressedFunction == null
                  ? Colors.grey[500]
                  : backgroundColor,
              side: const BorderSide(width: 1, color: Colors.grey),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(SizeConfig.width(10)))),
          onPressed: onPressedFunction,
          child: buttonText),
    );
  }
}
