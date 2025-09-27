import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';
import 'package:planetbrand/components/common_bottom_sheet.dart';
import 'package:planetbrand/components/common_button.dart';
import 'package:planetbrand/components/common_outline_button.dart';
import 'package:planetbrand/pages/account/address_screen.dart';
import 'package:planetbrand/pages/account/change_password_screen.dart';
import 'package:planetbrand/pages/account/controller/account_controller.dart';
import 'package:planetbrand/pages/account/edit_profile.dart';
import 'package:planetbrand/pages/account/orders_screen.dart';
import 'package:planetbrand/pages/auth/login_screen.dart';
import 'package:planetbrand/pages/cart/cart_screen.dart';
import 'package:planetbrand/pages/favourites/favorite_product_screen.dart';
import 'package:planetbrand/pages/other_page/webview_screen.dart';
import 'package:planetbrand/utils/app_colors.dart';
import 'package:planetbrand/utils/app_helpers.dart';
import 'package:planetbrand/utils/config.dart';
import 'package:planetbrand/utils/local_stoarge.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  AccountController accountController = Get.put(AccountController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Obx(() {
              return accountController.loader.value
                  ? _profileShimmerEffect(context)
                  : _profileTile();
            }),
            drawerTile(
              index: 2,
              icon: HeroIcons.user,
              title: "Profile",
              onClick: () {
                Get.to(() => EditProfileScreen());
              },
            ),
            drawerTile(
              index: 2,
              icon: HeroIcons.mapPin,
              title: "Addresses",
              onClick: () {
                Get.to(() => AddressScreen());
              },
            ),
            drawerTile(
              index: 0,
              icon: HeroIcons.shoppingBag,
              title: "My Orders",
              onClick: () {
                Get.to(() => OrdersScreen());
              },
            ),
            drawerTile(
              index: 1,
              icon: HeroIcons.heart,
              title: "Favorites",
              onClick: () {
                Get.to(() => FavoriteProductScreen());
              },
            ),

            drawerTile(
              index: 3,
              icon: HeroIcons.shoppingCart,
              title: "My Cart",
              onClick: () {
                Get.to(() => CartScreen());
              },
            ),
            drawerTile(
              index: 4,
              icon: HeroIcons.lockClosed,
              title: "Change Password",
              onClick: () {
                Get.to(() => ChangePasswordScreen());
              },
            ),

            drawerTile(
              index: 5,
              icon: HeroIcons.star,
              title: "Rate Us",
              onClick: () {
                showCustomRatingBottomSheet(context);
              },
            ),

            drawerTile(
              index: 6,
              icon: HeroIcons.users,
              title: "Refer a Friend",
              onClick: () {
                SharePlus.instance.share(
                  ShareParams(
                    text:
                        'https://play.google.com/store/apps/details?id=com.planets.planetsbrand&pli=1',
                  ),
                );
              },
            ),
            drawerTile(
              index: 7,
              icon: HeroIcons.clipboardDocument,
              title: "Privacy Policy",
              onClick: () {
                Get.to(() => WebViewScreen(url: privacyPolicyUrl));
              },
            ),
            drawerTile(
              index: 7,
              icon: HeroIcons.commandLine,
              title: "Terms & Condition",
              onClick: () {
                Get.to(() => WebViewScreen(url: termsAndConditionUrl));
              },
            ),
            drawerTile(
              index: 7,
              icon: HeroIcons.informationCircle,
              title: "Return / Exchange policy",
              onClick: () {
                Get.to(() => WebViewScreen(url: returnExchangePolicyUrl));
              },
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
                            onPressed: () {
                              Get.offAll(() => LoginScreen());
                            },
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
    );
  }

  Container _profileTile() {
    return Container(
      width: double.infinity,
      height: 230,
      decoration: BoxDecoration(color: AppColors.green),
      child: Padding(
        padding: const EdgeInsets.only(top: 60.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              child: loadNetworkImage(
                width: 50,
                height: 50,
                accountController.profileModel.value?.customerProfile?.photo ??
                    "",
              ),
            ),
            const SizedBox(height: 5),
            Text(
              accountController.profileModel.value?.customerProfile?.name ?? "",
              style: GoogleFonts.montserrat(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              accountController.profileModel.value?.customerProfile?.email ??
                  "",
              style: GoogleFonts.montserrat(fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }

  Container _profileShimmerEffect(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 230,
      decoration: BoxDecoration(color: AppColors.green),
      child: Padding(
        padding: const EdgeInsets.only(top: 60.0),
        child: Column(
          children: [
            Shimmer.fromColors(
              baseColor:
                  Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey.shade700
                      : Colors.grey[300]!,
              highlightColor:
                  Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey.shade600
                      : Colors.grey[100]!,
              child: CircleAvatar(radius: 50, backgroundColor: Colors.white),
            ),
            const SizedBox(height: 10),
            Shimmer.fromColors(
              baseColor:
                  Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey.shade700
                      : Colors.grey[300]!,
              highlightColor:
                  Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey.shade600
                      : Colors.grey[100]!,
              child: Container(height: 16, width: 120, color: Colors.white),
            ),
            const SizedBox(height: 5),
            Shimmer.fromColors(
              baseColor:
                  Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey.shade700
                      : Colors.grey[300]!,
              highlightColor:
                  Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey.shade600
                      : Colors.grey[100]!,
              child: Container(height: 14, width: 200, color: Colors.white),
            ),
          ],
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
        onClick();
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6.0),
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                HeroIcon(icon, color: AppColors.blackColor, size: 25),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: GoogleFonts.montserrat(
                    color: AppColors.blackColor,
                    fontWeight: FontWeight.w400,
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

  void showCustomRatingBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor:
          Theme.of(context).brightness == Brightness.dark
              ? Colors.grey.shade900
              : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return const CustomRateBottomSheet();
      },
    );
  }
}

class CustomRateBottomSheet extends StatefulWidget {
  const CustomRateBottomSheet({super.key});

  @override
  State<CustomRateBottomSheet> createState() => _CustomRateBottomSheetState();
}

class _CustomRateBottomSheetState extends State<CustomRateBottomSheet> {
  int selectedStar = 0;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: 24 + 20, // bottom padding + safe area
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Rate Us',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'How was your experience?',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              final starIndex = index + 1;
              return IconButton(
                onPressed: () {
                  setState(() {
                    selectedStar = starIndex;
                  });
                },
                icon: Icon(
                  selectedStar >= starIndex ? Icons.star : Icons.star_border,
                  size: 40,
                  color: Colors.amber,
                ),
              );
            }),
          ),
          const SizedBox(height: 32),
          isLoading
              ? getLoading()
              : SizedBox(
                width: double.infinity,
                child: CommonButton(
                  titleName: "Submit",
                  onPressed:
                      selectedStar == 0
                          ? null
                          : () {
                            setState(() {
                              isLoading = true;
                            });
                            Future.delayed(const Duration(seconds: 3), () {
                              if (mounted) {
                                Get.back();
                                infoSnackBar(
                                  message: "Thank You! For Rating Us",
                                );
                              }
                            });
                          },
                ),
              ),
        ],
      ),
    );
  }
}
