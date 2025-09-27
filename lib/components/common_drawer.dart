import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';
import 'package:planetbrand/components/common_bottom_sheet.dart';
import 'package:planetbrand/components/common_button.dart';
import 'package:planetbrand/components/common_outline_button.dart';
import 'package:planetbrand/pages/auth/login_screen.dart';
import 'package:planetbrand/utils/app_colors.dart';
import 'package:planetbrand/utils/app_helpers.dart';
import 'package:planetbrand/utils/local_stoarge.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  int _selectedIndex = -1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
        child: ListView(
          children: [
            ListTile(
              leading: CircleAvatar(child: loadNetworkImage("")),
              title: Text(
                "Hi, ",
                style: GoogleFonts.montserrat(fontWeight: FontWeight.w500),
              ),
              subtitle: Text("", style: GoogleFonts.montserrat()),
              trailing: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: CircleAvatar(
                  backgroundColor: AppColors.btnColor,
                  radius: 12,
                  child: HeroIcon(
                    HeroIcons.xMark,
                    size: 16,
                    color: AppColors.themeWhiteColor,
                  ),
                ),
              ),
            ),
            drawerTile(
              index: 0,
              icon: HeroIcons.squares2x2,
              title: "Dashboard",
              onClick: () {
                Get.back();
              },
            ),
            drawerTile(
              index: 1,
              icon: HeroIcons.user,
              title: "Accounts",
              onClick: () {
                Get.back();
              },
            ),
            drawerTile(
              index: 2,
              icon: HeroIcons.creditCard,
              title: "Purchase",
              onClick: () {
                Get.back();
              },
            ),
            drawerTile(
              index: 3,
              icon: HeroIcons.chartBarSquare,
              title: "Sales",
              onClick: () {
                Get.back();
              },
            ),
            drawerTile(
              index: 4,
              icon: HeroIcons.identification,
              title: "Vouchers",
              onClick: () {},
            ),

            drawerTile(
              index: 5,
              icon: HeroIcons.documentChartBar,
              title: "Reports",
              onClick: () {},
            ),

            drawerTile(
              index: 6,
              icon: HeroIcons.receiptPercent,
              title: "Dip Settings",
              onClick: () {},
            ),

            drawerTile(
              index: 7,
              icon: HeroIcons.shoppingCart,
              title: "Products",
              onClick: () {},
            ),

            drawerTile(
              index: 8,
              icon: HeroIcons.cog,
              title: "Settings",
              onClick: () {},
            ),

            drawerTile(
              index: 12,
              icon: HeroIcons.arrowLeftStartOnRectangle,
              title: "Logout",
              onClick: () {
                showModalBottomSheet(
                  backgroundColor:
                      Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey.shade800
                          : Colors.white,
                  context: context,
                  builder: (context) {
                    return CommonButtonSheet(
                      icon: HeroIcons.arrowLeftStartOnRectangle,
                      iconColor: AppColors.textColor,
                      title: 'Logout'.toUpperCase(),
                      subtitle: 'Are you sure to logout?',
                      actionButtons: [
                        Expanded(
                          child: CommonOutlineButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            titleName: "No",
                            textColor:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: CommonButton(
                            onPressed: () {
                              setState(() {
                                LocalStorage.clearAll();
                              });

                              Get.offAll(() => LoginScreen());
                            },
                            titleName: "Yes, Logout",
                            textColor: AppColors.themeWhiteColor,
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            drawerTile(
              index: 13,
              icon: HeroIcons.trash,
              title: "Delete Account",
              onClick: () {
                showModalBottomSheet(
                  backgroundColor:
                      Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey.shade800
                          : Colors.white,
                  context: context,
                  builder: (context) {
                    return CommonButtonSheet(
                      icon: HeroIcons.arrowLeftStartOnRectangle,
                      iconColor: AppColors.textColor,
                      title: 'Delete'.toUpperCase(),
                      subtitle: 'Are you sure to Delete Account?',
                      actionButtons: [
                        Expanded(
                          child: CommonOutlineButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            titleName: "No",
                            textColor:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: CommonButton(
                            onPressed: () {},
                            titleName: "Yes, Delete",
                            textColor: AppColors.themeWhiteColor,
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: GestureDetector(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color:
                Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey.shade800
                    : Colors.white,
          ),
          child: HeroIcon(
            HeroIcons.sun,
            color: AppColors.btnColor,
            style: HeroIconStyle.solid,
          ),
        ),
      ),
    );
  }

  Widget subTile(String title, Widget screen) {
    return Padding(
      padding: const EdgeInsets.only(left: 60.0, top: 6, bottom: 6),
      child: GestureDetector(
        onTap: () {
          Get.back();
          Get.to(() => screen);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.bgColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              HeroIcon(
                HeroIcons.chevronRight,
                color: AppColors.blackColor,
                size: 20,
              ),
              const SizedBox(width: 16),
              Text(
                title,
                style: GoogleFonts.montserrat(
                  color: AppColors.blackColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget drawerTile({
    required int index,
    required HeroIcons icon,
    required String title,
    required Function() onClick,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
        onClick();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6.0),
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color:
              _selectedIndex == index
                  ? Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey.shade800
                      : AppColors.btnColor
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                HeroIcon(
                  icon,
                  color:
                      _selectedIndex == index
                          ? AppColors.themeWhiteColor
                          : AppColors.blackColor,
                  size: 25,
                ),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: GoogleFonts.montserrat(
                    color:
                        _selectedIndex == index
                            ? AppColors.themeWhiteColor
                            : AppColors.blackColor,
                    fontWeight:
                        _selectedIndex == index
                            ? FontWeight.w600
                            : FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
