import 'package:beshmar/data/app_config.dart';
import 'package:beshmar/utils/show.dart';
import 'package:flutter/material.dart';

import 'showcase_helper.dart';

class ChangeLog {
  static void show(BuildContext context) {
    if (ShowcaseHelper.seen &&
        AppConfig.currentBuildNumber > AppConfig.lastBuildNumber) {
      Show.dialog(context, 'تغییرات', _getChangelogText(), [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('بستن'))
      ]);
    }
  }

  static String _getChangelogText() {
    return """نسخه 1.1.0
    - اضافه شدن
    - 
    - 
    - 
    - 
    - 
    - 
    - 
    - 
    - 
    - 
    - 
    - 
    - 
    - 
    - 
    - 
    - 
    - 
    - 
    - 
    - 
    - 
    - 
    - 
    - 
    - 
    - 
    - 
    - 
    - 
    - 
    - 
    - 
    - 
    - 1
    - 1
    - 1
    - 1
    - 1
    - 1
    - 1
    - 1
    - 1
    - 1
    - 1
    - 1
    - 1
    - 1
    - 1
    - 1
    - 2
    """;
  }
}
