import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';
import 'package:planetbrand/components/common_outline_button.dart';
import 'package:planetbrand/pages/account/address_screen.dart';
import 'package:planetbrand/pages/account/controller/account_controller.dart';
import 'package:planetbrand/pages/cart/controller/cart_controller.dart';
import 'package:planetbrand/utils/app_colors.dart';
import 'package:planetbrand/utils/app_helpers.dart';

class PaymentScreen extends StatelessWidget {
  PaymentScreen({super.key});

  final AccountController accountController = Get.put(AccountController());
  final CartController cartController = Get.put(CartController());

  final TextEditingController noteController = TextEditingController();

  final RxnString selectedPaymentMethod = RxnString();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        title: Text(
          "Payments",
          style: GoogleFonts.montserrat(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Obx(
        () => RefreshIndicator(
          onRefresh: () async {
            await accountController.getAddress();
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Text(
                  "Order Note",
                  style: GoogleFonts.montserrat(fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: TextField(
                  controller: noteController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: "Write order note (optional)...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Default Address
              Obx(() {
                if (accountController.addressLoader.value) {
                  return Center(
                    child: getSimpleLoading(color: AppColors.primaryColor),
                  );
                }

                final defaultAddress = accountController
                    .addressResponse
                    .value
                    ?.addresses
                    .firstWhereOrNull((a) => a.isDefault);

                if (defaultAddress != null) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Text(
                          "Delivery Address",
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 15.0),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.whiteColor,
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "${defaultAddress.address}, ${defaultAddress.city}, ${defaultAddress.province}, ${defaultAddress.country}, ZIP: ${defaultAddress.zip ?? "-"}",
                          style: GoogleFonts.montserrat(fontSize: 14),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15.0),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "No Default Address Found",
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 100.0,
                          ),
                          child: SizedBox(
                            height: 35,
                            child: CommonOutlineButton(
                              onPressed: () {
                                Get.to(() => AddressScreen());
                              },
                              titleName: "Add",
                              textColor: AppColors.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              }),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Text(
                  "Select Payment Method",
                  style: GoogleFonts.montserrat(fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: paymentOptionTile(
                  title: "Cash on Delivery",
                  value: "Cash on Delivery",
                  icon: HeroIcons.banknotes,
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: paymentOptionTile(
                  title: "Bank Alfalah",
                  value: "Bank Alfalah",
                  icon: HeroIcons.buildingOffice,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15.0,
                  vertical: 20,
                ),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 2,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Total
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Total:",
                          style: GoogleFonts.montserrat(fontSize: 14),
                        ),
                        Text(
                          currencyFormatAmount(cartController.cartTotal),
                          style: GoogleFonts.montserrat(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        final defaultAddr = accountController
                            .addressResponse
                            .value
                            ?.addresses
                            .firstWhereOrNull((a) => a.isDefault);

                        if (defaultAddr == null) {
                          errorSnackBar(
                            message: "Please select a default address.",
                          );
                          return;
                        }

                        if (selectedPaymentMethod.value == null) {
                          errorSnackBar(
                            message: "Please select a payment method.",
                          );
                          return;
                        }

                        cartController.placeOrder(
                          address: {
                            "name":
                                accountController
                                    .profileModel
                                    .value
                                    ?.customerProfile
                                    ?.name ??
                                "",
                            "phone":
                                accountController
                                    .profileModel
                                    .value
                                    ?.customerProfile
                                    ?.phone ??
                                "",
                            "email":
                                accountController
                                    .profileModel
                                    .value
                                    ?.customerProfile
                                    ?.email ??
                                "",
                            "address": defaultAddr.address,
                            "country": defaultAddr.country,
                            "province": defaultAddr.province,
                            "id": defaultAddr.id,
                            "city": defaultAddr.city,
                            "zip": defaultAddr.zip,
                          },
                          paymentMethod: selectedPaymentMethod.value!,
                          note: noteController.text,
                        );
                      },
                      child:
                          cartController.loader.value
                              ? getSimpleLoading(color: AppColors.whiteColor)
                              : Text(
                                "Confirm Order",
                                style: GoogleFonts.montserrat(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget paymentOptionTile({
    required String title,
    required String value,
    required HeroIcons icon,
  }) {
    return Obx(() {
      final isSelected = selectedPaymentMethod.value == value;
      return InkWell(
        onTap: () => selectedPaymentMethod.value = value,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? AppColors.primaryColor : Colors.grey.shade300,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(12),
            color:
                isSelected
                    ? AppColors.primaryColor.withOpacity(0.05)
                    : Colors.white,
          ),
          child: Row(
            children: [
              HeroIcon(
                icon,
                color: isSelected ? AppColors.primaryColor : Colors.grey,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(
                isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: isSelected ? AppColors.primaryColor : Colors.grey,
              ),
            ],
          ),
        ),
      );
    });
  }
}
