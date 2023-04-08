import 'package:flutter/material.dart';

class ShowcaseHelper {
  static List<GlobalKey> keyList = List.generate(5, (index) => GlobalKey());
  static bool seen = false;

  // static List<ShowcaseModel> caseList =
  //     List.generate(1, (index) => ShowcaseModel());

  // static List<bool> seenList = List.generate(1, (index) => false);

  // static List<GlobalKey> getMustShowKeys() {
  //   List<GlobalKey> list = List.empty(growable: true);

  //   for (var e in caseList) {
  //     if (!e.seen) {
  //       list.add(e.key);
  //     }
  //   }

  //   return list;
  // }

  // static void setSeenStatus(int index, bool seen) {
  //   if (index <= caseList.length - 1) {
  //     caseList[index].seen = seen;
  //   }
  // }
}

// class ShowcaseModel {
//   GlobalKey key = GlobalKey();
//   bool seen = false;
// }
