import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';
import 'package:planetbrand/pages/shop/shop_detail_screen.dart';
import 'package:planetbrand/utils/app_colors.dart';
import 'package:planetbrand/utils/app_helpers.dart';
import 'package:planetbrand/utils/config.dart';

class GroceryStaticScreen extends StatefulWidget {
  const GroceryStaticScreen({super.key});

  @override
  State<GroceryStaticScreen> createState() => _GroceryStaticScreenState();
}

class _GroceryStaticScreenState extends State<GroceryStaticScreen> {
  // Static tab selection (0 = Stalls, 1 = Malls)
  int selectedTabIndex = 0;

  // Distance filter options
  final List<Map<String, dynamic>> distanceOptions = [
    {'label': 'All', 'value': 0, 'isSelected': true},
    {'label': '20 km', 'value': 20, 'isSelected': false},
    {'label': '50 km', 'value': 50, 'isSelected': false},
  ];

  // Currently selected distance
  int selectedDistance = 0;

  // Static data for stalls
  final List<Map<String, dynamic>> stallsData = [
    {'id': 1, 'shopName': 'Fresh Vegetable Stall', 'logo': 'stall1.jpg'},
    {'id': 2, 'shopName': 'Fruit Paradise', 'logo': 'stall2.jpg'},
    {'id': 3, 'shopName': 'Organic Grocery', 'logo': 'stall3.jpg'},
    {'id': 4, 'shopName': 'Spice Corner', 'logo': 'stall4.jpg'},
    {'id': 5, 'shopName': 'Green Market', 'logo': 'stall5.jpg'},
    {'id': 6, 'shopName': 'Fresh Corner', 'logo': 'stall6.jpg'},
    {'id': 7, 'shopName': 'Daily Fresh', 'logo': 'stall7.jpg'},
    {'id': 8, 'shopName': 'Veggie Hub', 'logo': 'stall8.jpg'},
  ];

  // Static data for malls
  final List<Map<String, dynamic>> mallsData = [
    {'id': 9, 'shopName': 'Mega Mall Grocery', 'logo': 'mall1.jpg'},
    {'id': 10, 'shopName': 'City Center Store', 'logo': 'mall2.jpg'},
    {'id': 11, 'shopName': 'Super Market Hub', 'logo': 'mall3.jpg'},
    {'id': 12, 'shopName': 'Plaza Shopping', 'logo': 'mall4.jpg'},
    {'id': 13, 'shopName': 'Central Mall', 'logo': 'mall5.jpg'},
    {'id': 14, 'shopName': 'Grand Store', 'logo': 'mall6.jpg'},
    {'id': 15, 'shopName': 'Metro Mart', 'logo': 'mall7.jpg'},
    {'id': 16, 'shopName': 'Elite Shopping', 'logo': 'mall8.jpg'},
  ];

  // Method to change tab
  void changeTab(int index) {
    setState(() {
      selectedTabIndex = index;
    });
  }

  // Method to update distance filter
  void updateDistanceFilter(int distance) {
    setState(() {
      selectedDistance = distance;
      // Update selection status
      for (var option in distanceOptions) {
        option['isSelected'] = option['value'] == distance;
      }
    });
  }

  // Get base data based on tab selection
  List<Map<String, dynamic>> get baseData {
    return selectedTabIndex == 0 ? stallsData : mallsData;
  }

  // Filter data based on selected distance
  List<Map<String, dynamic>> get filteredData {
    // For now, just return all data regardless of filter
    // The filter UI will work but won't actually filter results
    return baseData;
  }

  // Get current data based on tab selection and filter
  List<Map<String, dynamic>> get currentData => filteredData;

  // Check if data is empty
  bool get isDataEmpty {
    return currentData.isEmpty;
  }

  // Show distance filter bottom sheet
  void showDistanceFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 8),
              height: 4,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Select Distance Range",
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, size: 20),
                    ),
                  ),
                ],
              ),
            ),

            // Distance options
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: distanceOptions.map((option) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      onTap: () {
                        updateDistanceFilter(option['value']);
                        Navigator.pop(context);
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: option['isSelected']
                                ? AppColors.green
                                : Colors.grey[300]!,
                            width: option['isSelected'] ? 2 : 1,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          color: option['isSelected']
                              ? AppColors.green.withOpacity(0.1)
                              : Colors.transparent,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              color: option['isSelected']
                                  ? AppColors.green
                                  : Colors.grey[600],
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                option['label'],
                                style: GoogleFonts.montserrat(
                                  fontSize: 16,
                                  fontWeight: option['isSelected']
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  color: option['isSelected']
                                      ? AppColors.green
                                      : Colors.black,
                                ),
                              ),
                            ),
                            if (option['isSelected'])
                              Icon(
                                Icons.check_circle,
                                color: AppColors.green,
                                size: 20,
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.whiteColor,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Text(
          "Grocery Shops",
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
          IconButton(
            icon: HeroIcon(HeroIcons.magnifyingGlass,
                color: AppColors.primaryColor),
            onPressed: () {
              // Handle search action
            },
          ),
          // Distance filter button
          IconButton(
            icon: Stack(
              children: [
                HeroIcon(HeroIcons.adjustmentsHorizontal, color: AppColors.primaryColor),
                if (selectedDistance > 0)
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
          // Distance filter chip (shows current selection)
          if (selectedDistance > 0)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                          size: 14,
                          color: AppColors.green,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "Within ${selectedDistance}km",
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.green,
                          ),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () => updateDistanceFilter(0),
                          child: Icon(
                            Icons.close,
                            size: 14,
                            color: AppColors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "${currentData.length} shops found",
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      color: AppColors.hintColor,
                    ),
                  ),
                ],
              ),
            ),

          // Tab Bar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.scafoldBackgroundColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.lightGrayColor),
            ),
            child: Row(
              children: [
                // Stalls Tab
                Expanded(
                  child: GestureDetector(
                    onTap: () => changeTab(0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: selectedTabIndex == 0
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
                          color: selectedTabIndex == 0
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
                    onTap: () => changeTab(1),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: selectedTabIndex == 1
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
                          color: selectedTabIndex == 1
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

          // Content Area
          Expanded(
            child: isDataEmpty
                ? _buildEmptyState()
                : RefreshIndicator(
              onRefresh: () async {
                // Simulate refresh - in real app you'd reload data
                setState(() {});
              },
              child: GridView.builder(
                padding: const EdgeInsets.all(10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  mainAxisExtent: 150, // Back to original height
                ),
                itemCount: currentData.length,
                itemBuilder: (context, index) {
                  final shop = currentData[index];
                  return _buildShopCard(
                    id: shop['id'],
                    shopName: shop['shopName'],
                    logo: shop['logo'],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Empty State Widget
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            selectedTabIndex == 0
                ? Icons.store_outlined
                : Icons.store_mall_directory_outlined,
            size: 64,
            color: AppColors.lightGrayColor,
          ),
          const SizedBox(height: 16),
          Text(
            selectedDistance > 0
                ? "No ${selectedTabIndex == 0 ? 'Stalls' : 'Malls'} Found in ${selectedDistance}km"
                : "No ${selectedTabIndex == 0 ? 'Stalls' : 'Malls'} Found",
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppColors.lightGrayColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            selectedDistance > 0
                ? "Try increasing the distance range"
                : "Check back later for new shops",
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              fontSize: 14,
              color: AppColors.lightGrayColor,
            ),
          ),
          if (selectedDistance > 0) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => updateDistanceFilter(0),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                "Show All",
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Shop Card Widget
  Widget _buildShopCard({
    required int id,
    required String shopName,
    required String logo,
  }) {
    return GestureDetector(
      onTap: () {
        Get.to(() => ShopDetailScreen(shopID: id));
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
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          children: [
            // Shop Image
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: loadNetworkImage(
                height: 80,
                width: 80,
                fit: BoxFit.cover,
                "$imageBaseUrl$logo",
              ),
            ),
            const SizedBox(height: 10),

            // Shop Name
            SizedBox(
              width: 100,
              child: Text(
                shopName,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
