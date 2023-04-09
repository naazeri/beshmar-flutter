import 'package:beshmar/utils/show.dart';
import 'package:flutter/material.dart';

class ChangeLog {
  static void show(BuildContext context) {
    Show.dialog(context, 'تغییرات اخیر', _getChangelogText(), [
      TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('بستن'))
    ]);
  }

  static String _getChangelogText() {
    return """
نسخه 1.1.0:
    - امکان قفل کردن دکمه افزایش و کاهش تعداد
    - نمایش تغییرات اخیر
    - اضافه کردن دکمه به اشتراک گذاری اپ
    - اصلاحات و بهبود های گرافیکی
    """;
  }
}
