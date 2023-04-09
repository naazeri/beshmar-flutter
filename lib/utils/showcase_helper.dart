import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

class ShowcaseHelper {
  static List<GlobalKey> keyList = List.generate(5, (index) => GlobalKey());
  static bool seen = false;

  static statrt(BuildContext context) {
    if (!seen) {
      ShowCaseWidget.of(context).startShowCase(keyList);
    }
  }
}
