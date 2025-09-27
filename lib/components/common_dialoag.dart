import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';
import 'package:planetbrand/components/common_button.dart';
import 'package:planetbrand/utils/app_colors.dart';

class CommonDialog extends StatelessWidget {
  final HeroIcons icon;
  final String title;
  final String message;
  final VoidCallback onYesPressed;
  final VoidCallback onNoPressed;

  const CommonDialog({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    required this.onYesPressed,
    required this.onNoPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        HeroIcon(icon, size: 50, color: Colors.redAccent),
        const SizedBox(height: 16),
        Text(
          title,
          style: GoogleFonts.montserrat(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          message,
          textAlign: TextAlign.center,
          style: GoogleFonts.montserrat(fontSize: 16),
        ),
        const SizedBox(height: 20),
        CommonButton(
          onPressed: onYesPressed,
          textColor: AppColors.borderColor,
          titleName: "Yes",
        ),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Text(
            "Close",
            style: GoogleFonts.montserrat(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: AppColors.themeWhiteColor,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

void showCustomDialog({
  required HeroIcons icon,
  required String title,
  required String message,
  required VoidCallback onYesPressed,
  required VoidCallback onNoPressed,
}) {
  Get.defaultDialog(
    title: '',
    content: CommonDialog(
      icon: icon,
      title: title,
      message: message,
      onYesPressed: onYesPressed,
      onNoPressed: onNoPressed,
    ),
    barrierDismissible: true,
  );
}
