import 'package:beshmar/utils/styles.dart';
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

  static Showcase getShowcase({
    required GlobalKey key,
    String? title,
    required String? description,
    required Widget child,
  }) {
    return Showcase(
      titleAlignment: TextAlign.end,
      descriptionAlignment: TextAlign.end,
      descTextStyle: Styles.textHeader4,
      titlePadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      // descriptionPadding:
      //     const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
      key: key,
      title: title,
      description: description,
      child: child,
    );
  }
}
