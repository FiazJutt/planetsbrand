import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';
import 'package:planetbrand/components/common_distance_filter_bottom_sheet.dart';
import 'package:planetbrand/utils/app_colors.dart';
import 'controller/grocery_shop_controller.dart';
import 'grocery_malls_screen.dart';
import 'grocery_stalls_screen.dart';

class GroceryMainScreen extends StatelessWidget {
  const GroceryMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GroceryController controller = Get.put(GroceryController());

    // Method to show distance filter bottom sheet
    void showDistanceFilterBottomSheet() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder:
            (context) => DistanceFilterBottomSheet(
              distanceOptions: controller.distanceOptions,
              selectedDistance: controller.selectedDistance.value,
              onDistanceSelected: (distance) {
                controller.updateDistanceFilter(distance);
              },
              title: "Select Distance Range",
            ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.whiteColor,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Text(
          "Grocery",
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
              controller.isSearchVisible.value
                  ? HeroIcons.xMark
                  : HeroIcons.magnifyingGlass,
              color: AppColors.primaryColor,
            ),
            onPressed: () {
              controller.toggleSearch();
              if (!controller.isSearchVisible.value) {
                // Clear search when closing
                controller.searchController.clear();
                controller.setSearchQuery('');
              }
            },
          )),
          // IconButton(
          //   icon: HeroIcon(
          //     HeroIcons.magnifyingGlass,
          //     color: AppColors.primaryColor,
          //   ),
          //   onPressed: () {
          //     // Handle search action
          //   },
          // ),
          // Distance filter button
          IconButton(
            icon: Stack(
              children: [
                HeroIcon(
                  HeroIcons.adjustmentsHorizontal,
                  color: AppColors.primaryColor,
                ),
                if (controller.selectedDistance.value > 0)
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
            onPressed: showDistanceFilterBottomSheet,
          ),
        ],
      ),

      body: Column(
        children: [
          // Search Field with animation
          Obx(() => AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: controller.isSearchVisible.value
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
                controller: controller.searchController,
                autofocus: true,
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: 'Search stalls or malls...',
                  hintStyle: GoogleFonts.montserrat(
                    fontSize: 14,
                    color: AppColors.hintColor,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: AppColors.primaryColor,
                    size: 22,
                  ),
                  suffixIcon: controller.searchQuery.value.isNotEmpty
                      ? IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: AppColors.hintColor,
                      size: 20,
                    ),
                    onPressed: () {
                      controller.searchController.clear();
                      controller.setSearchQuery('');
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
                  controller.setSearchQuery(value);
                },
              ),
            )
                : const SizedBox.shrink(),
          )),

          // Distance filter chip (shows current selection)
          Obx(() {
            // Show the correct count based on the selected tab
            int itemCount =
                controller.selectedTabIndex.value == 0
                    ? controller.stallsList.length
                    : controller.mallsList.length;

            return controller.selectedDistance.value > 0
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
                              "Within ${controller.selectedDistance.value}km",
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppColors.green,
                              ),
                            ),
                            const SizedBox(width: 4),
                            GestureDetector(
                              onTap: () => controller.resetDistanceFilter(),
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
                        "${itemCount} ${controller.selectedTabIndex.value == 0 ? 'stalls' : 'malls'} found",
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

          // Tab Bar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.scafoldBackgroundColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.lightGrayColor),
            ),
            child: Obx(
              () => Row(
                children: [
                  // Stalls Tab
                  Expanded(
                    child: GestureDetector(
                      onTap: () => controller.changeTab(0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color:
                              controller.selectedTabIndex.value == 0
                                  ? AppColors.green
                                  : Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          "Stalls",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color:
                                controller.selectedTabIndex.value == 0
                                    ? AppColors.whiteColor
                                    : AppColors.hintColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Malls Tab
                  Expanded(
                    child: GestureDetector(
                      onTap: () => controller.changeTab(1),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color:
                              controller.selectedTabIndex.value == 1
                                  ? AppColors.green
                                  : Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          "Malls",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color:
                                controller.selectedTabIndex.value == 1
                                    ? AppColors.whiteColor
                                    : AppColors.hintColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Tab Content
          Expanded(
            child: Obx(() {
              if (controller.selectedTabIndex.value == 0) {
                return const GroceryStallsScreen();
              } else {
                return const GroceryMallsScreen(); // Show malls screen when tab is 1
              }
            }),
          ),
        ],
      ),
    );
  }
}
