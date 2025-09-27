import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:heroicons/heroicons.dart';
import 'package:planetbrand/utils/app_colors.dart';

class SimpleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackButton;
  final Function()? onBackPress;

  const SimpleAppBar({super.key, this.showBackButton = true, this.onBackPress});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0,

      backgroundColor: AppColors.appbarBackgroundColor,
      automaticallyImplyLeading: false,
      elevation: 0,

      leading: IconButton(
        onPressed: () {
          Get.back();
        },
        icon: HeroIcon(HeroIcons.arrowLeft, size: 20),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}
