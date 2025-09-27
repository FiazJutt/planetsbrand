import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planetbrand/utils/app_helpers.dart';

class CommonLoader {
  static void showLoader() {
    if (Get.isSnackbarOpen == false) {
      if (Platform.isIOS) {
        showIOSLoader();
      } else {
        showAndroidLoader();
      }
    }
  }

  static void showIOSLoader() {
    Get.dialog(
      const CupertinoAlertDialog(
        content: Row(
          children: [
            CupertinoActivityIndicator(),
            SizedBox(width: 10),
            Text("Please wait..."),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }

  static void showAndroidLoader() {
    Get.dialog(
      AlertDialog(
        content: Row(
          children: [
            getSimpleLoading(),
            SizedBox(width: 10),
            Text("Please wait..."),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }
}
