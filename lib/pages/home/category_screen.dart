import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';
import 'package:planetbrand/components/common_shimmer_effect.dart';
import 'package:planetbrand/pages/category/category_product_screen.dart';
import 'package:planetbrand/pages/home/controller/home_controller.dart';
import 'package:planetbrand/utils/app_colors.dart';
import 'package:planetbrand/utils/app_helpers.dart';
import 'package:planetbrand/utils/config.dart';

class CategoryScreen extends StatelessWidget {
  CategoryScreen({super.key});
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
          "Category",
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
            : homeController.categoryModel.value?.categories == null &&
                homeController.categoryModel.value!.categories!.isEmpty
            ? const Center(child: Text("No Category Found"))
            : RefreshIndicator(
              onRefresh: () async {
                await homeController.fetchCategory();
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
                          homeController
                              .categoryModel
                              .value
                              ?.categories
                              ?.length ??
                          0,
                      itemBuilder: (context, index) {
                        final category =
                            homeController
                                .categoryModel
                                .value
                                ?.categories?[index];
                        return GestureDetector(
                          onTap: () {
                            Get.to(
                              () => CategoryProductScreen(
                                categoryID: category?.id ?? 0,
                                name: category?.catName ?? "",
                              ),
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
                                    "$imageBaseUrl${category?.photo}",
                                  ),
                                ),
                                const SizedBox(height: 10),
                                SizedBox(
                                  width: 100,
                                  child: Text(
                                    category?.catName ?? '',
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
