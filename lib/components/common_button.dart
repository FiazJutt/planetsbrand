import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:planetbrand/utils/app_colors.dart';

class CommonButton extends StatelessWidget {
  final String titleName;
  final Color? containerColor;
  final Color textColor;
  final Function()? onPressed;

  const CommonButton({
    super.key,
    required this.titleName,
    this.onPressed,
    this.containerColor,
    this.textColor = AppColors.themeWhiteColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.green,
        ),
        height: 45,
        width: double.infinity,
        child: Center(
          child: Text(
            titleName,
            style: GoogleFonts.montserrat(
              color: textColor,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
