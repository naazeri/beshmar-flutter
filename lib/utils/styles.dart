import 'package:beshmar/data/app_config.dart';
import 'package:flutter/material.dart';

class Styles {
  static String defaultFontFamily = 'Vazirmatn';
  static final listCardBackgroundColor = Colors.grey.shade50;

  static late TextStyle textHeader1;
  static late TextStyle textHeader2;
  static late TextStyle textHeader3;
  static late TextStyle textHeader3Bold;
  static late TextStyle textHeader3White;
  static late TextStyle textHeader4;

  static void updateStyles() {
    textHeader1 = TextStyle(
      fontSize: AppConfig.fontSize + 8.0,
      fontWeight: FontWeight.bold,
    );

    textHeader2 = TextStyle(
      fontSize: AppConfig.fontSize + 2.0,
    );

    textHeader3 = TextStyle(
      fontSize: AppConfig.fontSize,
    );

    textHeader3Bold = TextStyle(
      fontSize: AppConfig.fontSize,
      fontWeight: FontWeight.bold,
    );

    textHeader3White = TextStyle(
      fontSize: AppConfig.fontSize,
      color: Colors.white,
    );

    textHeader4 = TextStyle(
      fontSize: AppConfig.fontSize - 1.0,
    );
  }
}
