import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';
import 'package:planetbrand/components/common_shimmer_effect.dart';
import 'package:planetbrand/components/common_text_filed.dart';
import 'package:planetbrand/utils/app_colors.dart';
import 'package:planetbrand/utils/app_helpers.dart';
import 'package:planetbrand/utils/config.dart';
import 'package:planetbrand/pages/account/controller/order_controller.dart';

class TrackOrderScreen extends StatelessWidget {
  TrackOrderScreen({super.key});

  final OrderController orderController = Get.put(OrderController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        title: Text(
          "Track Order",
          style: GoogleFonts.montserrat(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CommonTextField(
              hitText: 'Enter Order Number',
              labelText: 'Enter Order Number',
              suffixIcons: IconButton(
                onPressed: () async {
                  await orderController.trackOrder();
                },
                icon: HeroIcon(HeroIcons.magnifyingGlass),
              ),
              textEditingController: orderController.orderTrackingController,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Obx(() {
                if (orderController.loader.value) {
                  return const CommonShimmerEffect();
                }

                final data = orderController.trackOrderModel.value?.data;

                if (data == null || data.isEmpty) {
                  return const Center(
                    child: Text(
                      "No Order Details Found.",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }

                final order = data.first;

                return ListView(
                  children: [
                    _infoRow("Order Number", order.orderNumber),
                    _infoRow("Payment Method", order.method),
                    _infoRow("Order Notes", order.orderNote),
                    _infoRow("Shipping", order.shipping),
                    _infoRow("Shipping Cost", order.shippingCost),
                    _infoRow("Coupon", order.couponCode ?? '-'),
                    _infoRow("Discount", order.couponDiscount),
                    _infoRow("Total Items", order.totalItems),
                    _infoRow("Total Paid", order.payAmount),
                    _infoRow("Order Status", order.status),
                    _infoRow("Payment Status", order.payment),
                    const Divider(height: 30),
                    Text(
                      "Products:",
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...order.cart?.map((prod) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.whiteColor,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: loadNetworkImage(
                                    "$imageBaseUrl${prod.photo}",
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(prod.name ?? "Product"),
                                      const SizedBox(height: 4),
                                      Text(
                                        "Qty: ${prod.selectedQty} x PKR ${currencyFormatAmount(double.parse(prod.cprice.toString()))}",
                                      ),
                                      Text(
                                        "Subtotal: PKR ${currencyFormatAmount((double.parse((prod.selectedQty ?? 1).toString())) * (prod.cprice ?? 0))}",
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList() ??
                        [const Text("No Order Found")],
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          Flexible(
            child: Text(
              value ?? '-',
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
