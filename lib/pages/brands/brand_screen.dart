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
      ),
      body: Obx(() {
        return brandController.loader.value
            ? CommonShimmerEffect()
            : brandController.brandModel.value?.brands == null &&
                brandController.brandModel.value!.brands!.isEmpty
            ? const Center(child: Text("No Brand Found"))
            : RefreshIndicator(
              onRefresh: () async {
                await brandController.fetchBrands();
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
                          brandController.brandModel.value?.brands?.length ?? 0,
                      itemBuilder: (context, index) {
                        final brand =
                            brandController.brandModel.value?.brands?[index];
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
