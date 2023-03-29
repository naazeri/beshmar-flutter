// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'date.dart';
import 'permission_helper.dart';
import 'show.dart';

class Backup {
  static Future<void> backupData(String data, BuildContext context) async {
    if (!(await PermissionHelper.checkStoragePermission(context))) {
      return;
    }

    final backupFileName = 'beshmar-${Date.getTimeFormatted()}.backup';

    try {
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

      if (selectedDirectory == null) {
        // User canceled the picker
        return;
      }

      final file = File('$selectedDirectory/$backupFileName');
      await file.writeAsString(data);

      Show.snackBar(context, 'پشتیبان گیری با موفقیت انجام شد');
    } catch (e) {
      Show.snackBar(context, 'خطا در پشتیبان گیری', seconds: 4);
    }
  }

  static Future<String?> importData(BuildContext context) async {
    if (!(await PermissionHelper.checkStoragePermission(context))) {
      return null;
    }

    try {
      final result = await FilePicker.platform.pickFiles(
        dialogTitle: 'انتخاب فایل پشتیبان',
      );

      if (result != null) {
        final path = result.files.single.path;
        if (path != null) {
          // Read the file
          final file = File(path);
          return await file.readAsString();
        }
      } else {
        // User canceled the picker
      }
    } catch (e) {
      Show.snackBar(context, 'فایل پشتیبان نامعتبر است', seconds: 4);
    }

    return null;
  }
}
