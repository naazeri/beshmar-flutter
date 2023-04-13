import 'package:beshmar/utils/show.dart';
import 'package:flutter/material.dart';

import 'styles.dart';

class ChangeLog {
  static void show(BuildContext context) {
    Show.dialog(context, 'تغییرات اخیر', _getChangelogText(), [
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text(
          'بستن',
          style: Styles.textNormal,
        ),
      )
    ]);
  }

  static String _getChangelogText() {
    return """
نسخه 1.2.0:
    - رنگبندی آیتم ها
    - تغییر اندازه متن در تنظیمات

نسخه 1.1.0:
    - امکان قفل کردن دکمه افزایش و کاهش تعداد
    - دکمه به اشتراک گذاری اپ
    """;
  }
}
