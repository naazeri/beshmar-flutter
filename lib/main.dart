import 'package:beshmar/utils/prefs.dart';
import 'package:beshmar/utils/showcase_helper.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

import 'page/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  final title = 'بشمار';

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      // debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: Colors.blue.shade600,
        ),
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.blue.shade400,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.blue.shade900,
        ),
      ),
      home: ShowCaseWidget(
        autoPlayDelay: const Duration(seconds: 3),
        builder: Builder(
          builder: (context) => HomePage(title: title),
        ),
        onComplete: (index, key) {
          if (index == ShowcaseHelper.keyList.length - 1) {
            Prefs.setShowcaseStatus(true);
          }
        },
        onFinish: () {
          debugPrint('**** all showcases finished');
        },
      ),
    );
  }
}
