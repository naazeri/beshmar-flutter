class Date {
  static String getTimeFormatted() {
    DateTime now = DateTime.now();
    return '${now.year}-${now.month}-${now.day}-${now.hour}-${now.minute}-${now.second}';
  }
}
