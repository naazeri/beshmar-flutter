import 'package:flutter/material.dart';

class Responsive {
  static Size getScreenSize(BuildContext context) =>
      MediaQuery.of(context).size;
}
