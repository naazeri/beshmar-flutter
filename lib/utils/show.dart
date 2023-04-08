import 'package:flutter/material.dart';

class Show {
  static void snackBar(BuildContext context, String text, {int seconds = 3}) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(text),
        duration: Duration(seconds: seconds),
      ),
    );
  }

  static void dialog(
    BuildContext context,
    String title,
    String content,
    List<Widget>? actions,
  ) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: actions,
      ),
    );
  }
}
