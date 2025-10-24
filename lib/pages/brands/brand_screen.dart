import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';
import 'package:planetbrand/components/common_distance_filter_bottom_sheet.dart';
import 'package:planetbrand/components/common_shimmer_effect.dart';
import 'package:planetbrand/pages/brands/brand_product_screen.dart';
import 'package:planetbrand/pages/brands/controller/brand_controller.dart';
import 'package:planetbrand/utils/app_colors.dart';
import 'package:planetbrand/utils/app_helpers.dart';

class BrandScreen extends StatelessWidget {
  BrandScreen({super.key});
  final BrandController brandController = Get.put(BrandController());
  final ScrollController scrollController = ScrollController();

  // Method to show distance filter bottom sheet
  void showDistanceFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => DistanceFilterBottomSheet(
            distanceOptions: brandController.distanceOptions,
            selectedDistance: brandController.selectedDistance.value,
            onDistanceSelected: (distance) {
              brandController.updateDistanceFilter(distance);
            },
            title: "Select Distance Range",
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Add scroll listener for pagination
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 100 &&
          !brandController.isFetchingMore.value &&
          brandController.currentPage.value < brandController.lastPage.value) {
        brandController.loadMore();
      }
    });

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,

        backgroundColor: AppColors.whiteColor,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Text(
          "Brands",
          style: GoogleFonts.montserrat(
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: HeroIcon(HeroIcons.arrowLeft, size: 20),
        ),

        actions: [
          // Search icon button
          Obx(
            () => IconButton(
              icon: HeroIcon(
                brandController.isSearchVisible.value
                    ? HeroIcons.xMark
                    : HeroIcons.magnifyingGlass,
                color: AppColors.primaryColor,
              ),
              onPressed: () {
                brandController.toggleSearch();
                if (!brandController.isSearchVisible.value) {
                  // Clear search when closing
                  brandController.searchController.clear();
                  brandController.setSearchQuery('');
                }
              },
            ),
          ),
          // Distance filter button
          IconButton(
            icon: Stack(
              children: [
                HeroIcon(
                  HeroIcons.adjustmentsHorizontal,
                  color: AppColors.primaryColor,
                ),
                if (brandController.selectedDistance.value > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      height: 8,
                      width: 8,
                      decoration: BoxDecoration(
                        color: AppColors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: () => showDistanceFilterBottomSheet(context),
          ),
        ],
      ),
      body: Obx(() {
        return brandController.loader.value
            ? CommonShimmerEffect()
            : (brandController.filteredBrandModel.value?.brands == null &&
                brandController.filteredBrandModel.value!.brands!.isEmpty)
            ? const Center(child: Text("No Brand Found"))
            : RefreshIndicator(
              onRefresh: () async {
                brandController.currentPage.value = 1;
                await brandController.fetchBrands();
              },
              child: Column(
                children: [
                  // Search Field with animation
                  Obx(
                    () => AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child:
                          brandController.isSearchVisible.value
                              ? Container(
                                margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primaryColor.withOpacity(
                                        0.08,
                                      ),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: TextField(
                                  controller: brandController.searchController,
                                  autofocus: true,
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Search brands...',
                                    hintStyle: GoogleFonts.montserrat(
                                      fontSize: 14,
                                      color: AppColors.hintColor,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.search,
                                      color: AppColors.primaryColor,
                                      size: 22,
                                    ),
                                    suffixIcon:
                                        brandController
                                                .searchQuery
                                                .value
                                                .isNotEmpty
                                            ? IconButton(
                                              icon: Icon(
                                                Icons.clear,
                                                color: AppColors.hintColor,
                                                size: 20,
                                              ),
                                              onPressed: () {
                                                brandController.searchController
                                                    .clear();
                                                brandController.setSearchQuery(
                                                  '',
                                                );
                                              },
                                            )
                                            : null,
                                    filled: true,
                                    fillColor: AppColors.scafoldBackgroundColor,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide.none,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                        color: AppColors.lightGrayColor,
                                        width: 1,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                        color: AppColors.primaryColor,
                                        width: 2,
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 14,
                                    ),
                                  ),
                                  onChanged: (value) {
                                    brandController.setSearchQuery(value);
                                  },
                                ),
                              )
                              : const SizedBox.shrink(),
                    ),
                  ),
                  // Distance filter chip (shows current selection)
                  Obx(() {
                    return brandController.selectedDistance.value > 0
                        ? Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.green.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: AppColors.green),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      size: 16,
                                      color: AppColors.green,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      "Within ${brandController.selectedDistance.value}km",
                                      style: GoogleFonts.montserrat(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.green,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    GestureDetector(
                                      onTap:
                                          () =>
                                              brandController
                                                  .resetDistanceFilter(),
                                      child: Icon(
                                        Icons.close,
                                        size: 16,
                                        color: AppColors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "${brandController.filteredBrandModel.value?.brands?.length ?? 0} brands found",
                                style: GoogleFonts.montserrat(
                                  fontSize: 12,
                                  color: AppColors.hintColor,
                                ),
                              ),
                            ],
                          ),
                        )
                        : const SizedBox.shrink();
                  }),
                  Expanded(
                    child: GridView.builder(
                      /// remove this for on click load
                      controller: scrollController, // Add scroll controller
                      padding: const EdgeInsets.all(10),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            mainAxisExtent: 150,
                          ),
                      itemCount:
                          brandController
                              .filteredBrandModel
                              .value
                              ?.brands
                              ?.length ??
                          0,
                      itemBuilder: (context, index) {
                        final brand =
                            brandController
                                .filteredBrandModel
                                .value
                                ?.brands?[index];
                        return GestureDetector(
                          onTap: () {
                            Get.to(
                              () =>
                                  BrandProductsScreen(brandId: brand?.id ?? 0),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: AppColors.whiteColor,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.lightGrayColor,
                                  spreadRadius: 1,
                                  blurRadius: 1,
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: loadNetworkImage(
                                    height: 80,
                                    width: 80,
                                    fit: BoxFit.cover,
                                    brand?.photo ?? '',
                                  ),
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  width: 100,
                                  child: Text(
                                    brand?.shopName ?? '',
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.montserrat(fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // Add loading indicator for pagination
                  Obx(
                    () {
                      // Show loading indicator when fetching more data
                      if (brandController.isFetchingMore.value) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: getSimpleLoading(
                            color: AppColors.primaryColor,
                          ),
                        );
                      }
                      // Show "Load More" button if there are more pages
                      else if (brandController.currentPage.value <
                          brandController.lastPage.value) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: ElevatedButton(
                            onPressed: () {
                              brandController.loadMore();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              foregroundColor: AppColors.whiteColor,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              "Load More",
                              style: GoogleFonts.montserrat(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      }
                      // Show "No more brands" message when all data is loaded
                      else if (brandController.currentPage.value >=
                          brandController.lastPage.value) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Text("No more brands"),
                        );
                      }
                      // Hide if not needed
                      else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                ],
              ),
            );
      }),
    );
  }
}
