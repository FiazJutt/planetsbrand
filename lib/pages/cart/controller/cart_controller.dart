import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planetbrand/pages/cart/model/cart_model.dart';
import 'package:planetbrand/pages/cart/payment_webview.dart';
import 'package:planetbrand/pages/landing/landing_screen.dart';
import 'package:planetbrand/utils/api_helper.dart';
import 'package:planetbrand/utils/app_helpers.dart';
import 'package:planetbrand/utils/config.dart';

class CartController extends GetxController {
  RxBool loader = false.obs;
  TextEditingController amountController = TextEditingController();

  Rx<CartProductModel?> cartProductModel = Rx(null);

  @override
  void onInit() {
    super.onInit();
    fetchCartProducts();
  }

  Future<void> fetchCartProducts() async {
    loader(true);
    try {
      final response = await ApiHelper.getRequestWithToken(getCartEndPoint);
      final responseData = jsonDecode(response.body);
      if (responseData['status_code'] == 200) {
        cartProductModel.value = CartProductModel.fromJson(responseData);
      }
    } catch (e) {
      rethrow;
    } finally {
      loader(false);
    }
  }

  Future<void> fetchCartWithoutLoading() async {
    try {
      final response = await ApiHelper.getRequestWithToken(getCartEndPoint);
      final responseData = jsonDecode(response.body);
      if (responseData['status_code'] == 200) {
        cartProductModel.value = CartProductModel.fromJson(responseData);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteItemCart({required int cartID}) async {
    try {
      final response = await ApiHelper.getRequestWithToken(
        "$deleteItemEndPoint/$cartID",
      );
      final responseData = jsonDecode(response.body);
      if (responseData['status_code'] == 200) {
        fetchCartWithoutLoading();
        successSnackBar(message: responseData['message']);
      } else {
        errorSnackBar(message: responseData['message']);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateCartQty({
    required int productID,
    required int currentQty,
  }) async {
    try {
      final response = await ApiHelper.postRequestWithToken(addcartEndPoint, {
        'product_id': productID,
        'product_qty': currentQty,
      });
      final responseData = jsonDecode(response.body);
      if (responseData['status_code'] == 200) {
        fetchCartWithoutLoading();
        successSnackBar(message: responseData['message']);
      } else {
        errorSnackBar(message: responseData['message']);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateCartQtyDetails({
    required int productID,
    required int currentQty,
  }) async {
    try {
      loader(true);
      final response = await ApiHelper.postRequestWithToken(addcartEndPoint, {
        'product_id': productID,
        'product_qty': currentQty,
      });
      final responseData = jsonDecode(response.body);
      if (responseData['status_code'] == 200) {
        fetchCartWithoutLoading();
        successSnackBar(message: responseData['message']);
      } else {
        errorSnackBar(message: responseData['message']);
      }
    } catch (e) {
      rethrow;
    } finally {
      loader(false);
    }
  }

  double get cartTotal {
    final data = cartProductModel.value?.data ?? [];
    return data.fold(0.0, (total, cart) {
      final price =
          double.tryParse(cart.product?.cprice?.toString() ?? "0") ?? 0;
      final qty = int.tryParse(cart.productQty?.toString() ?? "1") ?? 1;
      return total + (price * qty);
    });
  }

  Future<void> fetchShippingMethod() async {
    loader(true);
    try {
      final response = await ApiHelper.getRequestWithToken(
        "get/shipping/methods",
      );
      final responseData = jsonDecode(response.body);
      if (responseData['status_code'] == 200) {
        cartProductModel.value = CartProductModel.fromJson(responseData);
      }
    } catch (e) {
      rethrow;
    } finally {
      loader(false);
    }
  }

  Future<void> fetchPaymentMethods() async {
    loader(true);
    try {
      final response = await ApiHelper.getRequestWithToken(
        "get/payment/methods",
      );
      final responseData = jsonDecode(response.body);
      if (responseData['status_code'] == 200) {
        cartProductModel.value = CartProductModel.fromJson(responseData);
      }
    } catch (e) {
      rethrow;
    } finally {
      loader(false);
    }
  }

  placeOrder({
    required Map<String, dynamic> address,
    required String paymentMethod,
    required String? note,
  }) async {
    if (address.isEmpty) {
      errorSnackBar(message: "Please add Default Address");
      return;
    } else if (paymentMethod.isEmpty) {
      errorSnackBar(message: "Please Select Payment Method");
      return;
    }

    try {
      loader(true);

      final cartItems = cartProductModel.value?.data ?? [];

      final items =
          cartItems.map((item) {
            return {
              "id": int.tryParse(item.productId ?? "0"),
              "qty": int.tryParse(item.productQty ?? "1"),
            };
          }).toList();

      final payload = {
        "address_id": address["id"],
        "method_id": paymentMethod == "Cash on Delivery" ? 6 : 7,
        "shipping_id": 1,
        "shipping_cost": 0,
        "order_note": note ?? "",
        "coupon_discount": "",
        "coupon_code": "",
        "cart": jsonEncode(items),
      };

      final response = await ApiHelper.postRequestWithToken(
        "user/create/order",
        payload,
      );
      final responseData = jsonDecode(response.body);

      if (responseData['status_code'] == 200 && responseData['status'] == 1) {
        fetchCartWithoutLoading();
        successSnackBar(message: responseData['message']);
        if (paymentMethod == "Cash on Delivery") {
          Get.offAll(() => LandingScreen());
        } else {
          Get.off(
            () => BankAlfalahWebView(
              orderId: responseData['order_number'],
              amount: responseData['amount'],
            ),
          );
        }
      } else {
        errorSnackBar(message: responseData['message'] ?? "Order failed");
      }
    } catch (e) {
      errorSnackBar(message: "Something went wrong: $e");
    } finally {
      loader(false);
    }
  }
}
