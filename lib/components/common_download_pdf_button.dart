import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';
import 'package:planetbrand/utils/app_colors.dart';

class CommonDownloadPdfButton extends StatelessWidget {
  final String titleName;
  final Color? containerColor;
  final Color textColor;
  final Function()? onPressed;
  // final HeroIcons icon;

  const CommonDownloadPdfButton({
    super.key,
    required this.titleName,
    this.onPressed,
    this.containerColor,
    // required this.icon,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.themeWhiteColor,
          border: Border.all(color: AppColors.textColor),
        ),
        height: 40,
        width: double.infinity,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              HeroIcon(
                HeroIcons.arrowDownTray,
                size: 20,
                color: AppColors.btnColor,
              ),
              const SizedBox(width: 10),
              Text(
                titleName,
                style: GoogleFonts.montserrat(
                  color: textColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
