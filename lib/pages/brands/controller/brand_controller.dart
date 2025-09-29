import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:planetbrand/pages/brands/models/brand_model.dart';
import 'package:planetbrand/pages/brands/models/brand_product_model.dart';
import 'package:planetbrand/utils/api_helper.dart';
import 'package:planetbrand/utils/config.dart';

class BrandController extends GetxController {
  RxBool loader = false.obs;
  Rx<BrandModel?> brandModel = Rx(null);
  Rx<BrandModel?> filteredBrandModel = Rx(null);

  RxInt currentPage = 1.obs;
  RxInt lastPage = 1.obs;
  RxBool isFetchingMore = false.obs;
  RxList<Products> brandProduct = <Products>[].obs;

  // Search state
  var isSearchVisible = false.obs;
  final TextEditingController searchController = TextEditingController();
  RxString searchQuery = ''.obs;

  int? selectedBrandId;

  @override
  void onInit() {
    super.onInit();
    fetchBrands(); // Load brand list
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> fetchBrands() async {
    loader(true);
    try {
      final response = await ApiHelper.getRequestWithToken(brandsEndPoint);
      final responseData = jsonDecode(response.body);
      if (responseData['status_code'] == 200) {
        brandModel.value = BrandModel.fromJson(responseData);
        // Initialize filtered brands with all brands
        filteredBrandModel.value = BrandModel.fromJson(responseData);
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

  /// Update search query and filter brands
  void setSearchQuery(String query) {
    searchQuery.value = query;
    filterBrands(query);
  }

  /// Filter brands based on search query
  void filterBrands(String query) {
    if (brandModel.value == null) return;

    if (query.isEmpty) {
      // If query is empty, show all brands
      filteredBrandModel.value = brandModel.value;
    } else {
      // Filter brands based on name or shop name
      final filteredBrands =
          brandModel.value!.brands!.where((brand) {
            final name = (brand.name ?? '').toLowerCase();
            final shopName = (brand.shopName ?? '').toLowerCase();
            final searchTerm = query.toLowerCase();
            return name.contains(searchTerm) || shopName.contains(searchTerm);
          }).toList();

      // Update filtered brand model
      filteredBrandModel.value = BrandModel(
        statusCode: brandModel.value!.statusCode,
        status: brandModel.value!.status,
        brands: filteredBrands,
      );
    }
  }

  // Add this method
  void toggleSearch() {
    isSearchVisible.value = !isSearchVisible.value;
  }
}
