import 'package:flutter/material.dart';

import '../utils/styles.dart';

class AppBarTitle extends StatelessWidget {
  final String title;

  const AppBarTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Styles.textHeader1,
    );
  }
}
