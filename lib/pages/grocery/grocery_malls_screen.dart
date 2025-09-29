import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:planetbrand/components/common_shimmer_effect.dart';
import 'package:planetbrand/pages/grocery/controller/grocery_shop_controller.dart';
import 'package:planetbrand/pages/shop/shop_detail_screen.dart';
import 'package:planetbrand/utils/app_assets.dart';
import 'package:planetbrand/utils/app_colors.dart';
import 'package:planetbrand/utils/app_helpers.dart';
import 'package:planetbrand/utils/config.dart';

class GroceryMallsScreen extends StatelessWidget {
  const GroceryMallsScreen({super.key});

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
      return controller.mallsLoader.value
          ? const CommonShimmerEffect()
          : controller.isMallsEmpty
          ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.store_mall_directory_outlined,
                  size: 64,
                  color: AppColors.lightGrayColor,
                ),
                const SizedBox(height: 16),
                Text(
                  "No Malls Found",
                  style: GoogleFonts.montserrat(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppColors.lightGrayColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Check back later for new malls",
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    color: AppColors.lightGrayColor,
                  ),
                ),
              ],
            ),
          )
          : // Content Area with RefreshIndicator
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                controller.currentPage.value = 1;
                await controller.refreshMalls();
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
                          controller.filteredMallsList.length +
                          (controller.isFetchingMore.value ? 1 : 0),
                      itemBuilder: (context, index) {
                        // Show loading indicator at the end if fetching more data
                        if (controller.isFetchingMore.value &&
                            index == controller.filteredMallsList.length) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: getSimpleLoading(),
                            ),
                          );
                        }

                        final mall = controller.filteredMallsList[index];

                        // Debug: Print the image URLs
                        String imageUrl = '';
                        if (mall.logo != null && mall.logo!.isNotEmpty) {
                          // Check if it's already a full URL
                          if (mall.logo!.startsWith('http')) {
                            imageUrl = mall.logo!;
                          } else {
                            imageUrl = "$imageBaseUrl${mall.logo}";
                          }
                        } else if (mall.photo != null &&
                            mall.photo!.isNotEmpty) {
                          // Check if it's already a full URL
                          if (mall.photo!.startsWith('http')) {
                            imageUrl = mall.photo!;
                          } else {
                            imageUrl = "$imageBaseUrl${mall.photo}";
                          }
                        } else {
                          imageUrl = AppAssets.logo;
                        }

                        return GestureDetector(
                          onTap: () {
                            Get.to(
                              () => ShopDetailScreen(shopID: mall.id ?? 0),
                            );
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
                                /// Mall Image
                                Expanded(
                                  flex: 3,
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        topRight: Radius.circular(12),
                                      ),
                                      color: AppColors.lightGrayColor
                                          .withOpacity(0.1),
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
                                        imageUrl, // Use the computed URL directly
                                      ),
                                    ),
                                  ),
                                ),

                                /// Mall info
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          mall.shopName ?? 'Unknown Mall',
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
            ),
          );
    });
  }
}
