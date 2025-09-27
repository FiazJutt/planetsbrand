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
