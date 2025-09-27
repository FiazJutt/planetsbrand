import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CommonSnackBar {
  static show(String message, [int? sec]) {
    if (Get.isDialogOpen == false) {
      return Get.rawSnackbar(
        backgroundColor: const Color(0xff2d2d2d),
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: sec ?? 3),
        borderRadius: 5,
        messageText: Text(message, style: GoogleFonts.montserrat()),
        dismissDirection: DismissDirection.horizontal,
        margin: const EdgeInsets.all(10),
      );
    }
  }
}
