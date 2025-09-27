import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';
import 'package:planetbrand/pages/cart/controller/cart_controller.dart';
import 'package:planetbrand/pages/favourites/controller/favorite_controller.dart';
import 'package:planetbrand/utils/app_colors.dart';
import 'package:planetbrand/utils/app_helpers.dart';

// ignore: must_be_immutable
class SearchDetailProductScreen extends StatefulWidget {
  final int productID;
  final String imageUrl;
  final String name;
  final double price;
  final double newPrice;
  final String description;
  bool isFavorite;

  SearchDetailProductScreen({
    super.key,
    required this.productID,
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.newPrice,
    required this.description,
    required this.isFavorite,
  });

  @override
  State<SearchDetailProductScreen> createState() =>
      _SearchDetailProductScreenState();
}

class _SearchDetailProductScreenState extends State<SearchDetailProductScreen> {
  final CartController cartController = Get.put(CartController());

  final FavoriteController favoriteController = Get.put(FavoriteController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 350,
                  child: loadNetworkImage(
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    widget.imageUrl,
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: GoogleFonts.montserrat(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Text(
                        currencyFormatAmount(widget.newPrice),
                        style: GoogleFonts.montserrat(
                          fontSize: 15,
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Text(
                        currencyFormatAmount(widget.price),
                        style: GoogleFonts.montserrat(
                          fontSize: 15,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  HtmlWidget(
                    widget.description,
                    textStyle: GoogleFonts.montserrat(fontSize: 17),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(color: AppColors.whiteColor),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () {
                  if (widget.isFavorite == true) {
                    favoriteController.removeFromFavourite(
                      productID: widget.productID,
                    );
                    setState(() {
                      widget.isFavorite = false;
                    });
                  } else {
                    setState(() {
                      widget.isFavorite = true;
                    });
                    favoriteController.addToFavourite(
                      productID: widget.productID,
                    );
                  }
                },
                child: HeroIcon(
                  widget.isFavorite ? HeroIcons.heart : HeroIcons.heart,
                  color: AppColors.primaryColor,
                  style:
                      widget.isFavorite
                          ? HeroIconStyle.solid
                          : HeroIconStyle.outline,
                  size: 30,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Obx(() {
                return GestureDetector(
                  onTap: () {
                    cartController.updateCartQtyDetails(
                      productID: widget.productID,
                      currentQty: 1,
                    );
                  },
                  child:
                      cartController.loader.value
                          ? SizedBox(
                            height: 50,
                            child: getSimpleLoading(color: AppColors.btnColor),
                          )
                          : Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.btnColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                HeroIcon(
                                  HeroIcons.shoppingCart,
                                  color: AppColors.whiteColor,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  "Add to Cart",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 18,
                                    color: AppColors.whiteColor,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
