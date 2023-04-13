import 'package:beshmar/data/app_config.dart';
import 'package:flutter/material.dart';

class Styles {
  static String defaultFontFamily = 'Vazirmatn';
  static final listCardBackgroundColor = Colors.grey.shade50;

  static late TextStyle textHeader1;
  static late TextStyle textHeader2;
  static late TextStyle textNormal;
  static late TextStyle textNormalBold;
  static late TextStyle textNormalWhite;
  static late TextStyle textSmall1;
  static late TextStyle textSmall2;

  static void updateStyles() {
    textHeader1 = TextStyle(
      fontSize: AppConfig.fontSize + 8.0,
      fontWeight: FontWeight.bold,
    );

    textHeader2 = TextStyle(
      fontSize: AppConfig.fontSize + 2.0,
    );

    textNormal = TextStyle(
      fontSize: AppConfig.fontSize,
    );

    textNormalBold = TextStyle(
      fontSize: AppConfig.fontSize,
      fontWeight: FontWeight.bold,
    );

    textNormalWhite = TextStyle(
      fontSize: AppConfig.fontSize,
      color: Colors.white,
    );

    textSmall1 = TextStyle(
      fontSize: AppConfig.fontSize - 1.0,
    );

    textSmall2 = TextStyle(
      fontSize: AppConfig.fontSize - 2.0,
    );
  }
}
