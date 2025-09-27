import 'dart:convert';
import 'package:get/get.dart';
import 'package:planetbrand/pages/shop/model/shop_detail_product_model.dart';
import 'package:planetbrand/pages/shop/model/shop_model.dart';
import 'package:planetbrand/utils/api_helper.dart';
import 'package:planetbrand/utils/config.dart';

class ShopController extends GetxController {
  RxBool loader = false.obs;
  RxBool isFetchingMore = false.obs;
  RxList<Data> shops = <Data>[].obs;
  RxInt currentPage = 1.obs;
  RxInt lastPage = 1.obs;

  Rx<ShopAndProductModel?> shopProductsModel = Rx(null);

  @override
  void onInit() {
    super.onInit();
    fetchShops();
  }

  Future<void> fetchShops({bool isLoadMore = false}) async {
    if (isLoadMore) {
      isFetchingMore.value = true;
    } else {
      loader(true);
    }

    try {
      final response = await ApiHelper.getRequestWithToken(
        '$shopsEndPoint?page=${currentPage.value}',
      );
      final responseData = jsonDecode(response.body);

      if (responseData['status_code'] == 200) {
        final shopModel = ShopModel.fromJson(responseData);
        if (isLoadMore) {
          shops.addAll(shopModel.data ?? []);
        } else {
          shops.value = shopModel.data ?? [];
        }
        lastPage.value = shopModel.lastPage ?? 1;
      }
    } catch (e) {
      rethrow;
    } finally {
      loader(false);
      isFetchingMore.value = false;
    }
  }

  void loadMore() {
    if (currentPage.value < lastPage.value && !isFetchingMore.value) {
      currentPage++;
      fetchShops(isLoadMore: true);
    }
  }

  Future<void> fetchShopDetails({required int shopID}) async {
    loader(true);
    try {
      final response = await ApiHelper.getRequestWithToken(
        "$groceryshopEndPoint/$shopID",
      );
      final responseData = jsonDecode(response.body);
      if (responseData['status_code'] == 200) {
        shopProductsModel.value = ShopAndProductModel.fromJson(responseData);
      }
    } catch (e) {
      rethrow;
    } finally {
      loader(false);
    }
  }
}
