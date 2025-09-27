import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:planetbrand/utils/app_colors.dart';

class CommonOutlineButton extends StatelessWidget {
  final String titleName;
  final Color? containerColor;
  final Color textColor;
  final Function()? onPressed;

  const CommonOutlineButton({
    super.key,
    required this.titleName,
    this.onPressed,
    this.containerColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: SizedBox(
        height: 45,
        child: DottedBorder(
          borderType: BorderType.RRect,
          radius: const Radius.circular(20),
          color: textColor,
          strokeWidth: 1.2,
          dashPattern: [4, 3],
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: containerColor ?? AppColors.themeWhiteColor,
            ),
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
        ),
      ),
    );
  }
}
