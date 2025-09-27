import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';
import 'package:planetbrand/components/common_button.dart';
import 'package:planetbrand/components/common_not_found_tile.dart';
import 'package:planetbrand/pages/cart/controller/cart_controller.dart';
import 'package:planetbrand/pages/cart/payment_screen.dart';
import 'package:planetbrand/utils/app_colors.dart';
import 'package:planetbrand/utils/app_helpers.dart';
import 'package:planetbrand/utils/config.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CartScreen extends StatelessWidget {
  CartScreen({super.key});

  final CartController cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.whiteColor,
        // automaticallyImplyLeading: false,
        elevation: 0,
        title: Text(
          "Cart",
          style: GoogleFonts.montserrat(
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: Obx(() {
        return RefreshIndicator(
          onRefresh: () async {
            await cartController.fetchCartProducts();
          },
          child: Skeletonizer(
            enabled: cartController.loader.value,
            child:
                cartController.cartProductModel.value?.data != null &&
                        cartController.cartProductModel.value!.data!.isNotEmpty
                    ? ListView.builder(
                      itemCount:
                          cartController.cartProductModel.value?.data?.length ??
                          0,
                      itemBuilder: (context, index) {
                        final cart =
                            cartController.cartProductModel.value?.data?[index];

                        // 👇 FIX: convert to int
                        final currentQty =
                            int.tryParse(cart?.productQty.toString() ?? '1') ??
                            1;

                        return Container(
                          height: 100,
                          margin: const EdgeInsets.only(bottom: 5, top: 5),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.whiteColor,
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 25,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: loadNetworkImage(
                                  "$imageBaseUrl${cart?.product?.photo ?? ""}",
                                ),
                              ),
                            ),
                            title: Text(cart?.product?.name ?? ""),
                            subtitle: Text(
                              currencyFormatAmount(
                                double.parse(
                                  cart?.product?.cprice.toString() ?? "0",
                                ),
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // + button
                                GestureDetector(
                                  onTap: () {
                                    cartController.updateCartQty(
                                      productID: int.parse(
                                        cart?.productId ?? "0",
                                      ),
                                      currentQty: currentQty + 1,
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(5),
                                        bottomLeft: Radius.circular(5),
                                      ),
                                      border: Border.all(
                                        color: AppColors.borderColor,
                                      ),
                                    ),
                                    child: HeroIcon(
                                      HeroIcons.plus,
                                      size: 20,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                ),
                                // Quantity Display
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: AppColors.borderColor,
                                    ),
                                  ),
                                  child: Text(
                                    "$currentQty",
                                    style: GoogleFonts.montserrat(fontSize: 18),
                                  ),
                                ),
                                // - button
                                GestureDetector(
                                  onTap: () {
                                    if (currentQty > 1) {
                                      cartController.updateCartQty(
                                        productID: int.parse(
                                          cart?.productId ?? "0",
                                        ),
                                        currentQty: currentQty - 1,
                                      );
                                    } else {
                                      cartController.deleteItemCart(
                                        cartID: cart?.id ?? 0,
                                      );
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(5),
                                        bottomRight: Radius.circular(5),
                                      ),
                                      border: Border.all(
                                        color: AppColors.borderColor,
                                      ),
                                    ),
                                    child: HeroIcon(
                                      HeroIcons.minus,
                                      size: 20,
                                      color: AppColors.red,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                    : CommonNotFoundTile(),
          ),
        );
      }),
      bottomNavigationBar: Obx(() {
        return cartController.cartTotal == 0.0
            ? SizedBox.shrink()
            : Container(
              height: 120,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 6,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total:",
                        style: GoogleFonts.montserrat(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        currencyFormatAmount(cartController.cartTotal),
                        style: GoogleFonts.montserrat(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: CommonButton(
                      titleName: "Countinue",
                      onPressed: () {
                        Get.to(() => PaymentScreen());
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
