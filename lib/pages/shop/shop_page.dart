import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';
import 'package:planetbrand/components/common_shimmer_effect.dart';
import 'package:planetbrand/pages/shop/controller/shop_controller.dart';
import 'package:planetbrand/pages/shop/shop_detail_screen.dart';
import 'package:planetbrand/utils/app_colors.dart';
import 'package:planetbrand/utils/app_helpers.dart';

class ShopPage extends StatelessWidget {
  ShopPage({super.key});

  final ShopController shopController = Get.put(ShopController());
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 100 &&
          !shopController.isFetchingMore.value &&
          shopController.currentPage.value < shopController.lastPage.value) {
        shopController.loadMore();
      }
    });

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,

        backgroundColor: AppColors.whiteColor,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Text(
          "Shop",
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
        return shopController.loader.value
            ? CommonShimmerEffect()
            : shopController.shops.isEmpty
            ? const Center(child: Text("No Shops Found"))
            : RefreshIndicator(
              onRefresh: () async {
                shopController.currentPage.value = 1;
                await shopController.fetchShops();
              },
              child: Column(
                children: [
                  Expanded(
                    child: GridView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.all(10),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            mainAxisExtent: 150,
                          ),
                      itemCount: shopController.shops.length,
                      itemBuilder: (context, index) {
                        final shop = shopController.shops[index];
                        return GestureDetector(
                          onTap: () {
                            Get.to(
                              () => ShopDetailScreen(shopID: shop.id ?? 0),
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
                                    shop.photo ?? '',
                                  ),
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  width: 100,
                                  child: Text(
                                    shop.shopName ?? '',
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
                  Obx(
                    () =>
                        shopController.isFetchingMore.value
                            ? Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: getSimpleLoading(
                                color: AppColors.primaryColor,
                              ),
                            )
                            : shopController.currentPage.value >=
                                shopController.lastPage.value
                            ? const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Text("No more shops"),
                            )
                            : const SizedBox.shrink(),
                  ),
                ],
              ),
            );
      }),
    );
  }
}
