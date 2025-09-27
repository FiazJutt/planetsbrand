import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';
import 'package:planetbrand/components/common_shimmer_effect.dart';
import 'package:planetbrand/pages/product_details/product_detail_screen.dart';
import 'package:planetbrand/pages/shop/controller/shop_controller.dart';
import 'package:planetbrand/utils/app_assets.dart';
import 'package:planetbrand/utils/app_colors.dart';
import 'package:planetbrand/utils/app_helpers.dart';
import 'package:planetbrand/utils/config.dart';
import 'package:url_launcher/url_launcher.dart';

class ShopDetailScreen extends StatefulWidget {
  final int shopID;
  const ShopDetailScreen({super.key, required this.shopID});

  @override
  State<ShopDetailScreen> createState() => _ShopDetailScreenState();
}

class _ShopDetailScreenState extends State<ShopDetailScreen> {
  final ShopController shopController = Get.put(ShopController());

  @override
  void initState() {
    super.initState();
    // Fetch after first frame safely
    WidgetsBinding.instance.addPostFrameCallback((_) {
      shopController.fetchShopDetails(shopID: widget.shopID);
    });
  }

  @override
  Widget build(BuildContext context) {
    final shop = shopController.shopProductsModel.value?.topshop;
    return Scaffold(
      body: Obx(() {
        return shopController.loader.value
            ? CommonShimmerEffect()
            : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        height: 350,
                        child: loadNetworkImage(
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          "$imageBaseUrl${shopController.shopProductsModel.value?.topshop?.logo}",
                        ),
                      ),
                      Positioned(
                        top: 40,
                        left: 20,
                        child: IconButton(
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              AppColors.primaryColor,
                            ),
                          ),
                          color: AppColors.whiteColor,
                          onPressed: () {
                            Get.back();
                          },
                          icon: HeroIcon(HeroIcons.arrowLeft, size: 20),
                        ),
                      ),
                    ],
                  ),
                  ListTile(
                    title: Text(
                      shopController.shopProductsModel.value?.topshop?.name ??
                          "",
                      style: GoogleFonts.montserrat(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      shopController.shopProductsModel.value?.topshop?.email ??
                          "",
                      style: GoogleFonts.montserrat(fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Text(
                      "Social Links",
                      style: GoogleFonts.montserrat(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Builder(
                    builder: (_) {
                      final hasSocialLinks =
                          shop?.fUrl != null ||
                          shop?.gUrl != null ||
                          shop?.tUrl != null ||
                          shop?.lUrl != null ||
                          shop?.iUrl != null ||
                          shop?.wUrl != null;

                      if (!hasSocialLinks) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 20,
                          ),
                          child: Text(
                            "No social links found",
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              color: AppColors.borderColor,
                            ),
                          ),
                        );
                      }

                      return SizedBox(
                        height: 80,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            if (shop?.fUrl != null)
                              socialLink(
                                imagePath: AppAssets.facebookLogo,
                                onClick: () {
                                  launchUrl(Uri.parse(shop?.fUrl ?? ""));
                                },
                              ),

                            if (shop?.gUrl != null)
                              socialLink(
                                imagePath: AppAssets.googleLogo,
                                onClick: () {
                                  launchUrl(Uri.parse(shop?.gUrl ?? ""));
                                },
                              ),

                            if (shop?.tUrl != null)
                              socialLink(
                                imagePath: AppAssets.twitterLogo,
                                onClick: () {
                                  launchUrl(Uri.parse(shop?.tUrl ?? ""));
                                },
                              ),

                            if (shop?.lUrl != null)
                              socialLink(
                                imagePath: AppAssets.linkedInLogo,
                                onClick: () {
                                  launchUrl(Uri.parse(shop?.lUrl ?? ""));
                                },
                              ),

                            if (shop?.iUrl != null)
                              socialLink(
                                imagePath: AppAssets.instagramLogo,
                                onClick: () {
                                  launchUrl(Uri.parse(shop?.iUrl ?? ""));
                                },
                              ),

                            if (shop?.wUrl != null)
                              socialLink(
                                imagePath: AppAssets.whatsappLogo,
                                onClick: () {
                                  final phone = shop?.wUrl!;
                                  final uri = Uri.parse("https://wa.me/$phone");
                                  launchUrl(uri);
                                },
                              ),
                          ],
                        ),
                      );
                    },
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Text(
                      "Products",
                      style: GoogleFonts.montserrat(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: _buildFeatureProducts(),
                  ),
                ],
              ),
            );
      }),
    );
  }

  Widget socialLink({required String imagePath, required Function() onClick}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: GestureDetector(
        onTap: onClick,
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 25,
          child: Image.asset(imagePath, width: 40, height: 40),
        ),
      ),
    );
  }

  Widget _buildFeatureProducts() {
    if (shopController.shopProductsModel.value?.topshop?.products == null ||
        shopController.shopProductsModel.value!.topshop!.products!.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            "No Products Found",
            style: GoogleFonts.montserrat(
              fontSize: 15,
              color: AppColors.borderColor,
            ),
          ),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15),
        SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount:
                shopController
                    .shopProductsModel
                    .value
                    ?.topshop
                    ?.products
                    ?.length ??
                0,
            itemBuilder: (context, index) {
              final product =
                  shopController
                      .shopProductsModel
                      .value
                      ?.topshop
                      ?.products?[index];
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
                      isFavorite: false,
                      deal: product?.dealOfTheDay ?? "0",
                    ),
                  );
                },
                child: _productCard(
                  name: product?.name ?? '',
                  imageUrl: product?.photo ?? '',
                  price: product?.cprice?.toDouble() ?? 0,
                  oldPrice: product?.pprice?.toDouble() ?? 0,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _productCard({
    required String name,
    required String imageUrl,
    required double price,
    required double oldPrice,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.whiteColor,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 5,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              child: loadNetworkImage(
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                "$imageBaseUrl$imageUrl",
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 40,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  name,
                  style: GoogleFonts.montserrat(fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    currencyFormatAmount(price),
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    currencyFormatAmount(oldPrice),
                    style: GoogleFonts.montserrat(
                      fontSize: 13,
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey,
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
