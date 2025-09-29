import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';
import 'package:planetbrand/components/common_shimmer_effect.dart';
import 'package:planetbrand/pages/home/controller/home_controller.dart';
import 'package:planetbrand/pages/shop/shop_detail_screen.dart';
import 'package:planetbrand/utils/app_colors.dart';
import 'package:planetbrand/utils/app_helpers.dart';
import 'package:planetbrand/utils/config.dart';

class GroceryShopScreen extends StatelessWidget {
  GroceryShopScreen({super.key});

  final HomeController homeController = Get.put(HomeController());

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
      ),
      body: Obx(() {
        return homeController.loader.value
            ? CommonShimmerEffect()
            : homeController.groceriesModel.value?.data == null &&
                homeController.groceriesModel.value!.data!.isEmpty
            ? const Center(child: Text("No Shops Found"))
            : RefreshIndicator(
              onRefresh: () async {
                await homeController.fetchGroceriesShop();
              },
              child: Column(
                children: [
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
                          homeController.groceriesModel.value?.data?.length ??
                          0,
                      itemBuilder: (context, index) {
                        final shop =
                            homeController.groceriesModel.value?.data?[index];
                        return GestureDetector(
                          onTap: () {
                            Get.to(
                              () => ShopDetailScreen(shopID: shop?.id ?? 0),
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
                                    "$imageBaseUrl${shop?.logo}",
                                  ),
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  width: 100,
                                  child: Text(
                                    shop?.shopName ?? '',
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


///
/// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:heroicons/heroicons.dart';
// import 'package:planetbrand/components/common_shimmer_effect.dart';
// import 'package:planetbrand/pages/home/controller/home_controller.dart';
// import 'package:planetbrand/pages/shop/shop_detail_screen.dart';
// import 'package:planetbrand/utils/app_colors.dart';
// import 'package:planetbrand/utils/app_helpers.dart';
// import 'package:planetbrand/utils/config.dart';
//
// class GroceryShopScreen extends StatelessWidget {
//   GroceryShopScreen({super.key});
//
//   final HomeController homeController = Get.put(HomeController());
//
//   final RxInt _selectedIndex = 0.obs; // To keep track of the selected button
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         scrolledUnderElevation: 0,
//
//         backgroundColor: AppColors.whiteColor,
//         automaticallyImplyLeading: false,
//         elevation: 0,
//         title: Text(
//           "Stalls & Malls",
//           style: GoogleFonts.montserrat(
//             fontSize: 20,
//             fontWeight: FontWeight.w400,
//           ),
//         ),
//         leading: IconButton(
//           onPressed: () {
//             Get.back();
//           },
//           icon: HeroIcon(HeroIcons.arrowLeft, size: 20),
//         ),
//       ),
//       body: Obx(() {
//         return homeController.loader.value
//             ? CommonShimmerEffect()
//             : homeController.groceriesModel.value?.data == null &&
//                 homeController.groceriesModel.value!.data!.isEmpty
//                 ? const Center(child: Text("No Shops Found"))
//                 : Column(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.symmetric(
//                             vertical: 10.0, horizontal: 16.0),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceAround,
//                           children: [
//                             Expanded(
//                               child: ElevatedButton(
//                                 onPressed: () {
//                                   _selectedIndex.value = 0;
//                                 },
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: _selectedIndex.value == 0
//                                       ? AppColors.primaryColor
//                                       : AppColors.bgColor,
//                                   foregroundColor: _selectedIndex.value == 0
//                                       ? AppColors.whiteColor
//                                       : AppColors.primaryColor,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(8.0),
//                                   ),
//                                 ),
//                                 child: Text("Stalls"),
//                               ),
//                             ),
//                             const SizedBox(width: 10),
//                             Expanded(
//                               child: ElevatedButton(
//                                 onPressed: () {
//                                   _selectedIndex.value = 1;
//                                 },
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: _selectedIndex.value == 1
//                                       ? AppColors.primaryColor
//                                       : AppColors.bgColor,
//                                   foregroundColor: _selectedIndex.value == 1
//                                       ? AppColors.whiteColor
//                                       : AppColors.primaryColor,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(8.0),
//                                   ),
//                                 ),
//                                 child: Text("Malls"),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Expanded(
//                         child: Obx(() {
//                           if (_selectedIndex.value == 0) {
//                             // Stalls Section
//                             return RefreshIndicator(
//                               onRefresh: () async {
//                                 await homeController
//                                     .fetchGroceriesShop(); // Assuming this fetches stalls
//                               },
//                               child: GridView.builder(
//                                 padding: const EdgeInsets.all(10),
//                                 gridDelegate:
//                                     const SliverGridDelegateWithFixedCrossAxisCount(
//                                   crossAxisCount: 3,
//                                   mainAxisSpacing: 10,
//                                   crossAxisSpacing: 10,
//                                   mainAxisExtent: 150,
//                                 ),
//                                 itemCount: homeController.groceriesModel.value
//                                         ?.data?.length ??
//                                     0, // Replace with actual stall data
//                                 itemBuilder: (context, index) {
//                                   final shop = homeController
//                                       .groceriesModel.value?.data?[index];
//                                   return GestureDetector(
//                                     onTap: () {
//                                       Get.to(
//                                         () => ShopDetailScreen(
//                                             shopID: shop?.id ?? 0),
//                                       );
//                                     },
//                                     child: Container(
//                                       decoration: BoxDecoration(
//                                         borderRadius: BorderRadius.circular(5),
//                                         color: AppColors.whiteColor,
//                                         boxShadow: [
//                                           BoxShadow(
//                                             color: AppColors.lightGrayColor,
//                                             spreadRadius: 1,
//                                             blurRadius: 1,
//                                             offset: Offset(0, 1),
//                                           ),
//                                         ],
//                                       ),
//                                       child: Column(
//                                         children: [
//                                           ClipRRect(
//                                             borderRadius:
//                                                 BorderRadius.circular(10),
//                                             child: loadNetworkImage(
//                                               height: 80,
//                                               width: 80,
//                                               fit: BoxFit.cover,
//                                               "$imageBaseUrl${shop?.logo}",
//                                             ),
//                                           ),
//                                           const SizedBox(height: 10),
//                                           SizedBox(
//                                             width: 100,
//                                             child: Text(
//                                               shop?.shopName ?? '',
//                                               maxLines: 2,
//                                               textAlign: TextAlign.center,
//                                               style: GoogleFonts.montserrat(
//                                                   fontSize: 14),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               ),
//                             );
//                           } else {
//                             // Malls Section
//                             return RefreshIndicator(
//                               onRefresh: () async {
//                                 // await homeController.fetchMalls(); // Create a method to fetch malls
//                               },
//                               child: Center(
//                                 child: Text(
//                                   "Malls Section - Coming Soon!",
//                                   style: GoogleFonts.montserrat(fontSize: 16),
//                                 ),
//                               ),
//                             );
//                           }
//                         }),
//                       ),
//                     ],
//                   );
//       }),
//     );
//   }
// }
// //                     ),
// //                     Expanded(
// //                       child: TabBarView(
// //                         children: [
// //                           // Stalls Section
// //                           RefreshIndicator(
// //                             onRefresh: () async {
// //                               await homeController.fetchGroceriesShop(); // Assuming this fetches stalls
// //                             },
// //                             child: GridView.builder(
// //                               padding: const EdgeInsets.all(10),
// //                               gridDelegate:
// //                                   const SliverGridDelegateWithFixedCrossAxisCount(
// //                                 crossAxisCount: 3,
// //                                 mainAxisSpacing: 10,
// //                                 crossAxisSpacing: 10,
// //                                 mainAxisExtent: 150,
// //                               ),
// //                               itemCount: homeController
// //                                       .groceriesModel.value?.data?.length ??
// //                                   0, // Replace with actual stall data
// //                               itemBuilder: (context, index) {
// //                                 final shop = homeController
// //                                     .groceriesModel.value?.data?[index];
// //                                 return GestureDetector(
// //                                   onTap: () {
// //                                     Get.to(
// //                                       () => ShopDetailScreen(
// //                                           shopID: shop?.id ?? 0),
// //                                     );
// //                                   },
// //                                   child: Container(
// //                                     decoration: BoxDecoration(
// //                                       borderRadius: BorderRadius.circular(5),
// //                                       color: AppColors.whiteColor,
// //                                       boxShadow: [
// //                                         BoxShadow(
// //                                           color: AppColors.lightGrayColor,
// //                                           spreadRadius: 1,
// //                                           blurRadius: 1,
// //                                           offset: Offset(0, 1),
// //                                         ),
// //                                       ],
// //                                     ),
// //                                     child: Column(
// //                                       children: [
// //                                         ClipRRect(
// //                                           borderRadius:
// //                                               BorderRadius.circular(10),
// //                                           child: loadNetworkImage(
// //                                             height: 80,
// //                                             width: 80,
// //                                             fit: BoxFit.cover,
// //                                             "$imageBaseUrl${shop?.logo}",
// //                                           ),
// //                                         ),
// //                                         const SizedBox(height: 10),
// //                                         SizedBox(
// //                                           width: 100,
// //                                           child: Text(
// //                                             shop?.shopName ?? '',
// //                                             maxLines: 2,
// //                                             textAlign: TextAlign.center,
// //                                             style: GoogleFonts.montserrat(
// //                                                 fontSize: 14),
// //                                           ),
// //                                         ),
// //                                       ],
// //                                     ),
// //                                   ),
// //                                 );
// //                               },
// //                             ),
// //                           ),
// //                           // Malls Section - Replace with actual Malls UI and data
// //                           RefreshIndicator(
// //                             onRefresh: () async {
// //                               // await homeController.fetchMalls(); // Create a method to fetch malls
// //                             },
// //                             child: Center(
// //                               child: Text(
// //                                 "Malls Section - Coming Soon!",
// //                                 style: GoogleFonts.montserrat(fontSize: 16),
// //                               ),
// //                             ),
// //                             // Example GridView for Malls (replace with your actual implementation)
// //                             // child: GridView.builder(
// //                             //   padding: const EdgeInsets.all(10),
// //                             //   gridDelegate:
// //                             //       const SliverGridDelegateWithFixedCrossAxisCount(
// //                             //     crossAxisCount: 2, // Adjust as needed
// //                             //     mainAxisSpacing: 10,
// //                             //     crossAxisSpacing: 10,
// //                             //     mainAxisExtent: 200, // Adjust as needed
// //                             //   ),
// //                             //   itemCount: 0, // Replace with actual mall data count
// //                             //   itemBuilder: (context, index) {
// //                             //     // final mall = homeController.mallsModel.value?.data?[index]; // Example
// //                             //     return Container(
// //                             //       // Mall item UI
// //                             //       child: Center(child: Text("Mall ${index + 1}")),
// //                             //       color: Colors.blueGrey[100],
// //                             //     );
// //                             //   },
// //                             // ),
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                   ],
// //                                 ),
// //                               );
// //       }),
// //     );
// //   }
// // }