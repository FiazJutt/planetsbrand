import 'dart:convert';
import 'package:get/get.dart';
import 'package:planetbrand/pages/brands/models/brand_model.dart';
import 'package:planetbrand/pages/brands/models/brand_product_model.dart';
import 'package:planetbrand/utils/api_helper.dart';
import 'package:planetbrand/utils/config.dart';

class BrandController extends GetxController {
  RxBool loader = false.obs;
  Rx<BrandModel?> brandModel = Rx(null);

  RxInt currentPage = 1.obs;
  RxInt lastPage = 1.obs;
  RxBool isFetchingMore = false.obs;
  RxList<Products> brandProduct = <Products>[].obs;

  int? selectedBrandId;

  @override
  void onInit() {
    super.onInit();
    fetchBrands(); // Load brand list
  }

  Future<void> fetchBrands() async {
    loader(true);
    try {
      final response = await ApiHelper.getRequestWithToken(brandsEndPoint);
      final responseData = jsonDecode(response.body);
      if (responseData['status_code'] == 200) {
        brandModel.value = BrandModel.fromJson(responseData);
      }
    } catch (e) {
      rethrow;
    } finally {
      loader(false);
    }
  }

  Future<void> fetchBrandProduct({bool isLoadMore = false}) async {
    if (selectedBrandId == null) return;

    if (isLoadMore) {
      isFetchingMore.value = true;
    } else {
      loader(true);
    }

    try {
      final response = await ApiHelper.getRequestWithToken(
        '$brandProductEndPoint?brand_id=$selectedBrandId&page=${currentPage.value}',
      );
      final responseData = jsonDecode(response.body);

      if (responseData['status_code'] == 200) {
        final brandProductModel = BrandProductModel.fromJson(responseData);
        if (isLoadMore) {
          brandProduct.addAll(brandProductModel.products ?? []);
        } else {
          brandProduct.value = brandProductModel.products ?? [];
        }
        lastPage.value = brandProductModel.lastPage ?? 1;
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
      fetchBrandProduct(isLoadMore: true);
    }
  }
}
