import 'package:flutter/material.dart';

import '../utils/styles.dart';

class MyOutlinedButton extends StatelessWidget {
  final String text;
  final Color? textColor;
  final Color? borderColor;
  final void Function()? onPressed;

  const MyOutlinedButton({
    required this.text,
    this.onPressed,
    required this.textColor,
    this.borderColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: textColor ?? Theme.of(context).primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 30),
        side: BorderSide(
          width: 1.0,
          color: borderColor ?? Theme.of(context).primaryColor,
        ),
      ),
      child: Text(text, style: Styles.textHeader3),
    );
  }
}
