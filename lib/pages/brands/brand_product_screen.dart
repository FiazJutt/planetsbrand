import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';
import 'package:planetbrand/components/common_not_found_tile.dart';
import 'package:planetbrand/components/common_shimmer_effect.dart';
import 'package:planetbrand/pages/brands/controller/brand_controller.dart';
import 'package:planetbrand/pages/product_details/product_detail_screen.dart';
import 'package:planetbrand/utils/app_colors.dart';
import 'package:planetbrand/utils/app_helpers.dart';

class BrandProductsScreen extends StatefulWidget {
  final int brandId;
  const BrandProductsScreen({super.key, required this.brandId});

  @override
  State<BrandProductsScreen> createState() => _BrandProductsScreenState();
}

class _BrandProductsScreenState extends State<BrandProductsScreen> {
  final BrandController brandController = Get.put(BrandController());
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Run after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      brandController.selectedBrandId = widget.brandId;
      brandController.currentPage.value = 1;
      brandController.fetchBrandProduct();
    });

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 100 &&
          !brandController.isFetchingMore.value &&
          brandController.currentPage.value < brandController.lastPage.value) {
        brandController.loadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Brand Products',
          style: GoogleFonts.montserrat(fontSize: 20),
        ),
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        leading: IconButton(
          icon: const HeroIcon(HeroIcons.arrowLeft),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (brandController.loader.value) {
          return const CommonShimmerEffect();
        } else if (brandController.brandProduct.isEmpty) {
          return CommonNotFoundTile();
        }

        return RefreshIndicator(
          onRefresh: () async {
            brandController.currentPage.value = 1;
            await brandController.fetchBrandProduct();
          },
          child: Column(
            children: [
              Expanded(
                child: GridView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.all(10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    mainAxisExtent: 310,
                  ),
                  itemCount: brandController.brandProduct.length,
                  itemBuilder: (context, index) {
                    final product = brandController.brandProduct[index];
                    return buildProductItem(product);
                  },
                ),
              ),
              Obx(
                () =>
                    brandController.isFetchingMore.value
                        ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: getSimpleLoading(
                            color: AppColors.primaryColor,
                          ),
                        )
                        : brandController.currentPage.value >=
                            brandController.lastPage.value
                        ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Text("No more products"),
                        )
                        : const SizedBox.shrink(),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget buildProductItem(product) {
    return GestureDetector(
      onTap: () {
        Get.to(
          () => ProductDetailScreen(
            productID: product.id ?? 0,
            imageUrl: product.photo ?? '',
            name: product.name ?? '',
            price: product.pprice?.toDouble() ?? 0,
            newPrice: product.cprice?.toDouble() ?? 0,
            description: product.description ?? '',
            isFavorite: product.isFavorite ?? false,
            deal: '0',
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
              blurRadius: 1,
              spreadRadius: 1,
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
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: SizedBox(
                height: 35,
                child: Text(
                  product.name ?? '',
                  maxLines: 2,
                  style: GoogleFonts.montserrat(fontSize: 14),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (i) {
                return Icon(
                  i < (product.rating ?? 0) ? Icons.star : Icons.star_border,
                  color: i < (product.rating ?? 0) ? Colors.amber : Colors.grey,
                  size: 16,
                );
              }),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    currencyFormatAmount(product.cprice?.toDouble() ?? 0),
                    style: GoogleFonts.montserrat(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  Text(
                    currencyFormatAmount(product.pprice?.toDouble() ?? 0),
                    style: GoogleFonts.montserrat(
                      fontSize: 11,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
