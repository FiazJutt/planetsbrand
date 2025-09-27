import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';
import 'package:planetbrand/utils/app_colors.dart';

class RichAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final Function()? onBackPress;
  final Function()? onClick;
  final Function()? downloadClick;

  const RichAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    required this.onClick,
    required this.downloadClick,
    this.onBackPress,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor: AppColors.appbarBackgroundColor,
      elevation: 0,
      title: Text(
        title,
        style: GoogleFonts.montserrat(
          fontSize: 20,
          fontWeight: FontWeight.w400,
        ),
      ),

      actions: [
        GestureDetector(
          onTap: downloadClick,
          child: HeroIcon(
            HeroIcons.arrowDownTray,
            style: HeroIconStyle.solid,
            size: 22,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 12.0, left: 12),
          child: GestureDetector(
            onTap: onClick,
            child: HeroIcon(
              HeroIcons.funnel,
              style: HeroIconStyle.solid,
              size: 22,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
