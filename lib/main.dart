import 'package:flutter/material.dart';

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
      home: HomePage(title: title),
    );
  }
}
