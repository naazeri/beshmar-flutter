import 'package:flutter/material.dart';

class Show {
  static void snackBar(BuildContext context, String text, {int seconds=3}) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(text),
        duration: Duration(seconds: seconds),
      ),
    );
  }
}
