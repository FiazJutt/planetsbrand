import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';
import 'package:planetbrand/components/common_shimmer_effect.dart';
import 'package:planetbrand/pages/brands/brand_product_screen.dart';
import 'package:planetbrand/pages/brands/controller/brand_controller.dart';
import 'package:planetbrand/utils/app_colors.dart';
import 'package:planetbrand/utils/app_helpers.dart';

class BrandScreen extends StatelessWidget {
  BrandScreen({super.key});
  final BrandController brandController = Get.put(BrandController());

  @override
  Widget build(BuildContext context) {
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
          Obx(() => IconButton(
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
          )),
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
                await brandController.fetchBrands();
              },
              child: Column(
                children: [
                  // Search Field with animation
                  Obx(() => AnimatedSize(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: brandController.isSearchVisible.value
                        ? Container(
                      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryColor.withOpacity(0.08),
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
                          suffixIcon: brandController.searchQuery.value.isNotEmpty
                              ? IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: AppColors.hintColor,
                              size: 20,
                            ),
                            onPressed: () {
                              brandController.searchController.clear();
                              brandController.setSearchQuery('');
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
                  )),
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(10),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            mainAxisExtent: 150,
                          ),
                      itemCount:
                          brandController.filteredBrandModel.value?.brands?.length ?? 0,
                      itemBuilder: (context, index) {
                        final brand =
                            brandController.filteredBrandModel.value?.brands?[index];
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
                ],
              ),
            );
      }),
    );
  }
}