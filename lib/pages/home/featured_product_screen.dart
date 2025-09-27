import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';
import 'package:planetbrand/components/common_shimmer_effect.dart';
import 'package:planetbrand/pages/home/controller/home_controller.dart';
import 'package:planetbrand/pages/product_details/product_detail_screen.dart';
import 'package:planetbrand/utils/app_colors.dart';
import 'package:planetbrand/utils/app_helpers.dart';
import 'package:planetbrand/utils/config.dart';

class FeaturedProductScreen extends StatelessWidget {
  FeaturedProductScreen({super.key});

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
          "Featured Product",
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
            : homeController.featureProductModel.value?.data == null &&
                homeController.featureProductModel.value!.data!.isEmpty
            ? const Center(child: Text("No Product Found"))
            : RefreshIndicator(
              onRefresh: () async {
                await homeController.fetchFeaturedProducts();
              },
              child: Column(
                children: [
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(10),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 5,
                            crossAxisSpacing: 5,
                            mainAxisExtent: 290,
                          ),
                      itemCount:
                          homeController
                              .featureProductModel
                              .value
                              ?.data
                              ?.length ??
                          0,
                      itemBuilder: (context, index) {
                        final product =
                            homeController
                                .featureProductModel
                                .value
                                ?.data?[index];
                        return GestureDetector(
                          onTap: () {
                            Get.to(
                              () => ProductDetailScreen(
                                productID: product?.id ?? 0,
                                imageUrl: product?.photo ?? "",
                                name: product?.name ?? "",
                                price: product?.pprice?.toDouble() ?? 0,
                                newPrice: product?.cprice?.toDouble() ?? 0,
                                description: product?.description ?? "",
                                isFavorite: product?.isFavorite ?? false,
                                deal: product?.dealOfTheDay ?? "0",
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
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
                                    height: 200,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    "$imageBaseUrl${product?.photo}",
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 4.0,
                                  ),
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: 35,
                                    child: Text(
                                      product?.name ?? '',
                                      maxLines: 2,
                                      style: GoogleFonts.montserrat(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 5),
                                SizedBox(
                                  width: double.infinity,
                                  height: 30,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 5,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          currencyFormatAmount(
                                            product?.cprice?.toDouble() ?? 0,
                                          ),
                                          style: GoogleFonts.montserrat(
                                            fontSize: 13,
                                            color: AppColors.primaryColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          currencyFormatAmount(
                                            product?.pprice?.toDouble() ?? 0,
                                          ),
                                          style: GoogleFonts.montserrat(
                                            fontSize: 11,
                                            decoration:
                                                TextDecoration.lineThrough,
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
                ],
              ),
            );
      }),
    );
  }
}
