import 'package:beshmar/data/app_config.dart';
import 'package:beshmar/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'data/counter_model.dart';
import 'page/home_page.dart';
import 'page/introduction_page.dart';
import 'utils/prefs.dart';
import 'utils/showcase_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await loadAppInfo();
  await loadData();

  // if (AppConfig.devMode) {
  //   ShowcaseHelper.seen = true;
  // }

  runApp(const MyApp());
}

Future<void> loadAppInfo() async {
  final packageInfo = await PackageInfo.fromPlatform();

  AppConfig.appName = packageInfo.appName;
  AppConfig.packageName = packageInfo.packageName;
  // AppConfig.currentBuildNumber = int.parse(packageInfo.buildNumber);
}

Future<void> loadData() async {
  ShowcaseHelper.seen = await Prefs.getShowcaseStatus();
  AppConfig.isFullVersion = await Prefs.getFullVersionStatus();
  AppConfig.isCountingLocked = await Prefs.getCountingLock();

  AppConfig.fontSize = await Prefs.getFontSize();
  Styles.updateStyles();

  final result = await Prefs.getData();

  if (result != null) {
    CounterModel.list = CounterModel.decode(result);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: Colors.blue.shade600,
        ),
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.blue.shade400,
        fontFamily: Styles.defaultFontFamily,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.blue.shade900,
        ),
      ),
      home: ShowcaseHelper.seen ? const HomePage() : const IntroductionPage(),
    );
  }
}
