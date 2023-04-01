import 'package:flutter/material.dart';

import '../widget/app_bar_title.dart';
import '../widget/scaffold_rtl.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldRTL(
      appBar: AppBar(
        title: const AppBarTitle('راهنما'),
      ),
      body: Text(''),
    );
  }
}
