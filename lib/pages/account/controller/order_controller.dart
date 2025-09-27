import 'dart:convert';
import 'dart:developer';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:planetbrand/pages/account/model/order_model.dart' as order;
import 'package:planetbrand/pages/account/model/track_order_model.dart';
import 'package:planetbrand/utils/api_helper.dart';
import 'package:planetbrand/utils/config.dart';

class OrderController extends GetxController {
  RxBool loader = false.obs;
  RxBool isFetchingMore = false.obs;

  Rx<order.OrdersModel?> orderModel = Rx(null);
  Rx<TrackOrderModel?> trackOrderModel = Rx(null);
  TextEditingController orderTrackingController = TextEditingController();

  RxList<order.Data> allOrders = <order.Data>[].obs;

  RxInt currentPage = 1.obs;
  RxInt lastPage = 1.obs;

  @override
  void onInit() {
    super.onInit();
    getOrders();
  }

  Future<void> getOrders({bool isLoadMore = false}) async {
    if (isLoadMore) {
      isFetchingMore(true);
    } else {
      loader(true);
      currentPage.value = 1;
      allOrders.clear();
    }

    try {
      final response = await ApiHelper.getRequestWithToken(
        "$customerOrdersEndPoint?page=${currentPage.value}",
      );
      final responseData = jsonDecode(response.body);
      if (responseData['status_code'] == 200) {
        final result = order.OrdersModel.fromJson(responseData);
        orderModel.value = result;

        if (isLoadMore) {
          allOrders.addAll(result.data ?? []);
        } else {
          allOrders.value = result.data ?? [];
        }

        lastPage.value = result.lastPage ?? 1;
      } else {
        log("ORDER RESPONSE ERROR: $responseData");
      }
    } catch (e) {
      rethrow;
    } finally {
      loader(false);
      isFetchingMore(false);
    }
  }

  void loadMoreOrders() {
    if (currentPage.value < lastPage.value && !isFetchingMore.value) {
      currentPage++;
      getOrders(isLoadMore: true);
    }
  }

  Future<void> trackOrder() async {
    try {
      loader(true);
      final response = await ApiHelper.postRequestWithToken(
        trackOrderEndPoint,
        {'order_number': orderTrackingController.text},
      );
      final responseData = jsonDecode(response.body);
      if (responseData['status_code'] == 200) {
        trackOrderModel.value = TrackOrderModel.fromJson(responseData);
      } else {
        log("Track Order Error: $responseData");
      }
    } catch (e) {
      rethrow;
    } finally {
      loader(false);
    }
  }
}
