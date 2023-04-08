import 'package:beshmar/data/app_config.dart';
import 'package:flutter/material.dart';

import 'data/counter_model.dart';
import 'page/home_page.dart';
import 'page/introduction_page.dart';
import 'utils/prefs.dart';
import 'utils/showcase_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await loadData();

  runApp(const MyApp());
}

Future<void> loadData() async {
  ShowcaseHelper.seen = await Prefs.getShowcaseStatus();
  AppConfig.isFullVersion = await Prefs.getFullVersionStatus();
  AppConfig.isCountingLocked = await Prefs.getCountingLock();

  final result = await Prefs.getData();

  if (result != null) {
    CounterModel.list = CounterModel.decode(result);
  }
}

class MyApp extends StatelessWidget {
  final title = 'بشمار';

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      debugShowCheckedModeBanner: true,
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
      home: ShowcaseHelper.seen
          ? HomePage(title: title)
          : IntroductionPage(homeTitle: title),
      // home: ShowCaseWidget(
      //   autoPlayDelay: const Duration(seconds: 3),
      //   builder: Builder(
      //     builder: (context) => HomePage(title: title),
      //   ),
      //   onComplete: (index, key) {
      //     if (index == ShowcaseHelper.keyList.length - 1) {
      //       Prefs.setShowcaseStatus(true);
      //     }
      //   },
      //   onFinish: () {
      //     debugPrint('**** all showcases finished');
      //   },
      // ),
    );
  }
}
