import 'package:flutter/material.dart';

import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';
import 'package:planetbrand/components/common_drawer.dart';
import 'package:planetbrand/utils/app_colors.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final Function()? onBackPress;

  const CommonAppBar({
    super.key,
    required this.title,
    this.showBackButton = true,
    this.onBackPress,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0,
      centerTitle: true,
      backgroundColor: AppColors.appbarBackgroundColor,
      automaticallyImplyLeading: false,
      elevation: 0,
      title: Text(
        title,
        style: GoogleFonts.montserrat(
          fontSize: 20,
          fontWeight: FontWeight.w400,
        ),
      ),
      leading: IconButton(
        onPressed: () {
          Get.to(() => MyDrawer());
        },
        icon: HeroIcon(HeroIcons.bars3),
      ),
      actions: [
        IconButton(
          onPressed: () {
            // Get.to(() => SettingScreen());
          },
          icon: HeroIcon(HeroIcons.userCircle),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
