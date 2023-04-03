import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'show.dart';

class PermissionHelper {
  static Future<bool> checkStoragePermission(BuildContext context) async {
    if (await Permission.storage.request().isGranted) {
      return true;
    }

    // ignore: use_build_context_synchronously
    Show.snackBar(context, 'دسترسی مورد نیاز داده نشده است');
    return false;
  }
}
