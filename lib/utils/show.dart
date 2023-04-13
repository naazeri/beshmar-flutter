import 'package:beshmar/utils/styles.dart';
import 'package:flutter/material.dart';

class Show {
  static void snackBar(
    BuildContext context,
    String text, {
    int seconds = 3,
    bool clearQueue = false,
  }) {
    final scaffold = ScaffoldMessenger.of(context);

    if (clearQueue) {
      scaffold.clearSnackBars();
    }

    scaffold.showSnackBar(
      SnackBar(
        content: Text(
          text,
          style: Styles.textHeader3.copyWith(
            fontFamily: Styles.defaultFontFamily,
          ),
        ),
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
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          actionsAlignment: MainAxisAlignment.start,
          title: Text(title, style: Styles.textHeader1),
          content: SingleChildScrollView(
            child: Text(content, style: Styles.textHeader3),
          ),
          actions: actions,
        ),
      ),
    );
  }
}
