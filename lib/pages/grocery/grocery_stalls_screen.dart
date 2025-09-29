import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';
import 'package:planetbrand/components/common_distance_filter_bottom_sheet.dart';
import 'package:planetbrand/components/common_shimmer_effect.dart';
import 'package:planetbrand/pages/grocery/controller/grocery_shop_controller.dart';
import 'package:planetbrand/pages/shop/shop_detail_screen.dart';
import 'package:planetbrand/utils/app_assets.dart'; // Add this import
import 'package:planetbrand/utils/app_colors.dart';
import 'package:planetbrand/utils/app_helpers.dart';
import 'package:planetbrand/utils/config.dart';

class GroceryStallsScreen extends StatelessWidget {
  const GroceryStallsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GroceryController controller = Get.find<GroceryController>();
    final ScrollController scrollController = ScrollController();

    // Add scroll listener for pagination
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 100 &&
          !controller.isFetchingMore.value) {
        controller.loadMore();
      }
    });

    return Obx(() {
      return controller.stallsLoader.value
          ? const CommonShimmerEffect()
          : controller.isStallsEmpty
          ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.store_outlined,
                  size: 64,
                  color: AppColors.lightGrayColor,
                ),
                const SizedBox(height: 16),
                Text(
                  "No Stalls Found",
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppColors.lightGrayColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Check back later for new stalls",
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    color: AppColors.lightGrayColor,
                  ),
                ),
              ],
            ),
          )
          : RefreshIndicator(
            onRefresh: () async {
              controller.currentPage.value = 1;
              await controller.refreshStalls();
            },
            child: Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.85,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                    itemCount:
                        controller.filteredStallsList.length +
                        (controller.isFetchingMore.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      // Show loading indicator at the end if fetching more data
                      if (controller.isFetchingMore.value &&
                          index == controller.filteredStallsList.length) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: getSimpleLoading(),
                          ),
                        );
                      }

                      final stall = controller.filteredStallsList[index];
                      // // Debug: Print the image URLs
                      // String imageUrl = '';
                      // if (stall.logo != null && stall.logo!.isNotEmpty) {
                      //   // Check if it's already a full URL
                      //   if (stall.logo!.startsWith('http')) {
                      //     imageUrl = stall.logo!;
                      //   } else {
                      //     imageUrl = "$imageBaseUrl${stall.logo}";
                      //   }
                      // } else if (stall.photo != null && stall.photo!.isNotEmpty) {
                      //   // Check if it's already a full URL
                      //   if (stall.photo!.startsWith('http')) {
                      //     imageUrl = stall.photo!;
                      //   } else {
                      //     imageUrl = "$imageBaseUrl${stall.photo}";
                      //   }
                      // } else {
                      //   imageUrl = AppAssets.logo;
                      // }
                      //
                      // // Print debug info
                      // if (index == 0) { // Only print for first item to avoid spam
                      //   print('Stall ID: ${stall.id}');
                      //   print('Stall Name: ${stall.shopName}');
                      //   print('Logo: ${stall.logo}');
                      //   print('Photo: ${stall.photo}');
                      //   print('Final Image URL: $imageUrl');
                      // }

                      return GestureDetector(
                        onTap: () {
                          Get.to(() => ShopDetailScreen(shopID: stall.id ?? 0));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: AppColors.whiteColor,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.lightGrayColor.withOpacity(
                                  0.3,
                                ),
                                spreadRadius: 1,
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// Stall Image
                              Expanded(
                                flex: 3,
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12),
                                    ),
                                    color: AppColors.lightGrayColor.withOpacity(
                                      0.1,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12),
                                    ),
                                    child: loadNetworkImage(
                                      height: double.infinity,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      // imageUrl,
                                      stall.photo ?? "",
                                    ),
                                  ),
                                ),
                              ),

                              /// Stall info
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        stall.shopName ?? 'Unknown Stall',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.montserrat(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.blackColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Show loading indicator at the bottom when fetching more data
                Obx(
                  () =>
                      controller.isFetchingMore.value
                          ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: getSimpleLoading(),
                          )
                          : const SizedBox.shrink(),
                ),
              ],
            ),
          );
    });
  }
}
