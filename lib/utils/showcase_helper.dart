import 'package:beshmar/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

class ShowcaseHelper {
  static List<GlobalKey> keyList = List.generate(4, (index) => GlobalKey());
  static bool seen = false;

  static statrt(BuildContext context) {
    if (!seen) {
      ShowCaseWidget.of(context).startShowCase(keyList);
    }
  }

  static Showcase getShowcase({
    required GlobalKey key,
    String? title,
    required String? description,
    required Widget child,
  }) {
    return Showcase(
      titleAlignment: TextAlign.end,
      descriptionAlignment: TextAlign.end,
      descTextStyle: Styles.textSmall1,
      titlePadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      key: key,
      title: title,
      description: description,
      child: child,
    );
  }
}
