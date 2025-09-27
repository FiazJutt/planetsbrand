import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';
import 'package:planetbrand/components/common_not_found_tile.dart';
import 'package:planetbrand/components/common_shimmer_effect.dart';
import 'package:planetbrand/components/common_text_filed.dart';
import 'package:planetbrand/pages/product_details/search_detail_product_screen.dart';
import 'package:planetbrand/pages/search/controller/search_controller.dart';
import 'package:planetbrand/utils/app_colors.dart';
import 'package:planetbrand/utils/app_helpers.dart';

class SearchProductScreen extends StatelessWidget {
  SearchProductScreen({super.key});

  final SearchProductController productController = Get.put(
    SearchProductController(),
  );
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 100 &&
          !productController.isFetchingMore.value &&
          productController.currentPage.value <
              productController.lastPage.value) {
        productController.loadMore();
      }
    });

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.whiteColor,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Text(
          "Search Products",
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
        if (productController.loader.value) {
          return CommonShimmerEffect();
        }

        return RefreshIndicator(
          onRefresh: () async {
            productController.currentPage.value = 1;
            await productController.fetchSearchedProducts(loading: true);
          },
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: CommonTextField(
                  textEditingController:
                      productController.searchProductController,
                  hitText: "Search products...",
                  labelText: "Search products...",
                  onChange: (value) async {
                    productController.currentPage.value = 1;
                    await productController.fetchSearchedProducts(
                      loading: false,
                    );
                  },
                  suffixIcons: IconButton(
                    onPressed: () async {
                      productController.currentPage.value = 1;
                      await productController.fetchSearchedProducts(
                        loading: true,
                      );
                    },
                    icon: HeroIcon(HeroIcons.magnifyingGlass),
                  ),
                ),
              ),

              // Empty state
              if (productController.products.isEmpty)
                const Expanded(child: CommonNotFoundTile())
              else
                Expanded(
                  child: GridView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.all(10),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          mainAxisExtent: 310,
                        ),
                    itemCount: productController.products.length,
                    itemBuilder: (context, index) {
                      final product = productController.products[index];

                      return GestureDetector(
                        onTap: () {
                          Get.to(
                            () => SearchDetailProductScreen(
                              productID: product.id ?? 0,
                              imageUrl: product.photo ?? "",
                              name: product.name ?? "",
                              price: double.parse(product.pprice.toString()),
                              newPrice: double.parse(product.cprice.toString()),
                              description: product.description ?? "",
                              isFavorite: product.isFavorite ?? false,
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
                                offset: const Offset(0, 1),
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
                                  product.photo ?? '',
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
                                    product.name ?? '',
                                    maxLines: 2,
                                    style: GoogleFonts.montserrat(fontSize: 14),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: double.infinity,
                                height: 20,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(5, (starIndex) {
                                    if (starIndex < (product.rating ?? 0)) {
                                      return const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 16,
                                      );
                                    } else {
                                      return const Icon(
                                        Icons.star_border,
                                        color: Colors.grey,
                                        size: 16,
                                      );
                                    }
                                  }),
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
                                          (product.cprice ?? 0).toDouble(),
                                        ),
                                        style: GoogleFonts.montserrat(
                                          fontSize: 13,
                                          color: AppColors.primaryColor,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      if ((product.pprice ?? 0) > 0)
                                        Text(
                                          currencyFormatAmount(
                                            (product.pprice ?? 0).toDouble(),
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

              Obx(() {
                return productController.isFetchingMore.value
                    ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: getSimpleLoading(color: AppColors.primaryColor),
                    )
                    : productController.currentPage.value >=
                        productController.lastPage.value
                    ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Text("No more products"),
                    )
                    : const SizedBox.shrink();
              }),
            ],
          ),
        );
      }),
    );
  }
}
