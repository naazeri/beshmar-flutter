import 'package:beshmar/data/app_config.dart';
import 'package:beshmar/utils/prefs.dart';
import 'package:beshmar/utils/styles.dart';
import 'package:flutter/material.dart';

import '../widget/app_bar_title.dart';
import '../widget/scaffold_rtl.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  // double _currentSliderValue = 20;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldRTL(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // don't use const otherwise font change not apply
        // ignore: prefer_const_constructors
        title: AppBarTitle('تنظیمات'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'اندازه متن: ${AppConfig.fontSize.round()}',
                  style: Styles.textNormal,
                ),
                Text(
                  'مقدار پیشنهادی: 16',
                  style:
                      Styles.textSmall2.copyWith(color: Colors.grey.shade500),
                ),
              ],
            ),
            Slider(
              value: AppConfig.fontSize,
              min: 10,
              max: 30,
              label: AppConfig.fontSize.round().toString(),
              onChanged: (value) {
                setState(() {
                  AppConfig.fontSize = value.roundToDouble();
                  Styles.updateStyles();
                });

                Prefs.setFontSize(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
