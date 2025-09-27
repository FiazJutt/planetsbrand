import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';
import 'package:planetbrand/components/common_not_found_tile.dart';
import 'package:planetbrand/components/common_shimmer_effect.dart';
import 'package:planetbrand/pages/account/controller/order_controller.dart';
import 'package:planetbrand/pages/account/model/order_model.dart';
import 'package:planetbrand/pages/account/track_order_screen.dart';
import 'package:planetbrand/utils/app_colors.dart';
import 'package:planetbrand/utils/app_helpers.dart';
import 'package:planetbrand/utils/config.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final OrderController orderController = Get.put(OrderController());
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 100 &&
          orderController.currentPage.value < orderController.lastPage.value &&
          !orderController.isFetchingMore.value) {
        orderController.loadMoreOrders();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        title: Text(
          "My Orders",
          style: GoogleFonts.montserrat(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: GestureDetector(
              onTap: () => Get.to(() => TrackOrderScreen()),
              child: HeroIcon(HeroIcons.mapPin),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (orderController.loader.value && orderController.allOrders.isEmpty) {
          return const CommonShimmerEffect();
        }

        if (orderController.allOrders.isEmpty) {
          return const CommonNotFoundTile();
        }

        return RefreshIndicator(
          onRefresh: () async => await orderController.getOrders(),
          child: ListView.separated(
            controller: scrollController,
            itemCount: orderController.allOrders.length + 1,
            padding: const EdgeInsets.all(16),
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              if (index < orderController.allOrders.length) {
                final order = orderController.allOrders[index];
                return InkWell(
                  onTap: () => Get.to(() => OrderDetailScreen(order: order)),
                  child: _orderCard(order),
                );
              } else {
                if (orderController.isFetchingMore.value) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: getSimpleLoading()),
                  );
                } else if (orderController.currentPage.value >=
                    orderController.lastPage.value) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: Text("No more orders")),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              }
            },
          ),
        );
      }),
    );
  }

  Widget _orderCard(Data order) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Order # ${order.orderNumber}",
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () => copyToClipboard(order.orderNumber ?? ""),
                child: HeroIcon(
                  HeroIcons.clipboard,
                  size: 20,
                  color: AppColors.btnColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _orderRow(Icons.payment, "Payment", order.method),
          _orderRow(Icons.shopping_bag_outlined, "Items", order.totalItems),
          _orderRow(
            Icons.currency_rupee_rounded,
            "Total",
            currencyFormatAmount(double.parse(order.payAmount.toString())),
          ),
          _orderRow(Icons.payment, "Payment Status", order.payment),
          Row(
            children: [
              const Icon(
                Icons.access_time,
                size: 18,
                color: AppColors.primaryColor,
              ),
              const SizedBox(width: 8),
              Text(
                "${order.status?.toUpperCase()}",
                style: GoogleFonts.montserrat(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _orderRow(IconData icon, String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primaryColor),
          const SizedBox(width: 8),
          Text(
            "$label: ",
            style: GoogleFonts.montserrat(fontWeight: FontWeight.w500),
          ),
          Text("$value", style: GoogleFonts.montserrat()),
        ],
      ),
    );
  }
}

class OrderDetailScreen extends StatelessWidget {
  final Data order;
  const OrderDetailScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final cartItems = order.cart ?? [];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        title: Text(
          "Order Details",
          style: GoogleFonts.montserrat(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Order Summary",
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Divider(),
                _infoRow("Payment Method", order.method),
                _infoRow("Shipping", order.shipping),
                _infoRow(
                  "Shipping Cost",
                  currencyFormatAmount(
                    double.parse((order.shippingCost).toString()),
                  ),
                ),
                _infoRow("Coupon Discount", order.couponDiscount ?? "-"),
                _infoRow("Total Items", order.totalItems),
                _infoRow(
                  "Total Paid",
                  currencyFormatAmount(
                    double.parse((order.payAmount).toString()),
                  ),
                ),
                _infoRow("Order Notes", order.orderNote ?? "-"),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Products",
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(),
          ...cartItems.map((prod) {
            final imageUrl = "$imageBaseUrl${prod.photo}";
            final qty = prod.selectedQty ?? 1;
            final price = prod.cprice ?? 0;
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
                    child:
                        prod.photo != null
                            ? loadNetworkImage(
                              imageUrl,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            )
                            : const Icon(Icons.image, size: 60),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          prod.name ?? "Product",
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Qty: $qty x PKR ${currencyFormatAmount(double.parse(price.toString()))}",
                          style: GoogleFonts.montserrat(fontSize: 13),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "Subtotal: PKR ${currencyFormatAmount(double.parse((qty * price).toString()))}",
                          style: GoogleFonts.montserrat(
                            fontSize: 13,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _infoRow(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: GoogleFonts.montserrat(fontSize: 14)),
          Flexible(
            child: Text(
              value ?? "-",
              textAlign: TextAlign.right,
              style: GoogleFonts.montserrat(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
