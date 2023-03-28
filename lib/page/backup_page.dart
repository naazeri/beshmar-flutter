import 'package:flutter/material.dart';

import '../widget/app_bar_title.dart';
import '../widget/scaffold_rtl.dart';

class BackupPage extends StatelessWidget {
  const BackupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldRTL(
      appBar: _getAppBar(),
      body: Column(
        children: [
          Text('بکاپ گیری'),
          ElevatedButton(
            onPressed: () {},
            child: Text('hi'),
          ),
        ],
      ),
    );
  }

  AppBar _getAppBar() {
    return AppBar(
      title: const AppBarTitle('پشتیبان گیری'),
    );
  }
}
