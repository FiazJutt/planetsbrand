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

  // Distance filter state
  RxInt selectedDistance = 0.obs;
  RxList<Map<String, dynamic>> distanceOptions =
      <Map<String, dynamic>>[
        {'label': 'All', 'value': 0, 'isSelected': true},
        {'label': '20 km', 'value': 20, 'isSelected': false},
        {'label': '50 km', 'value': 50, 'isSelected': false},
      ].obs;

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

  Future<void> fetchBrands({bool isLoadMore = false}) async {
    if (isLoadMore) {
      isFetchingMore.value = true;
    } else {
      loader(true);
    }

    try {
      // Add distance parameter to the API call if a distance is selected
      String apiUrl = '$brandsEndPoint?page=${currentPage.value}';
      if (selectedDistance.value > 0) {
        apiUrl += '&distance=${selectedDistance.value}';
      }

      final response = await ApiHelper.getRequestWithToken(apiUrl);
      final responseData = jsonDecode(response.body);
      if (responseData['status_code'] == 200) {
        final brandModelResponse = BrandModel.fromJson(responseData);
        if (isLoadMore) {
          // Add new data to existing list
          brandModel.value?.brands?.addAll(brandModelResponse.brands ?? []);
        } else {
          // Replace existing data
          brandModel.value = brandModelResponse;
          // Initialize filtered brands with all brands
          filteredBrandModel.value = BrandModel.fromJson(responseData);
        }
        // Update pagination info if available in response
        if (responseData.containsKey('last_page')) {
          lastPage.value = responseData['last_page'];
        } else {
          // If no pagination info in response, assume single page
          lastPage.value = 1;
        }
      }
    } catch (e) {
      rethrow;
    } finally {
      loader(false);
      isFetchingMore.value = false;
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
      fetchBrands(isLoadMore: true);
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

  // Refresh method for pull to refresh
  Future<void> refreshBrands() async {
    currentPage.value = 1; // Reset to first page
    await fetchBrands();
  }

  // Add these methods for distance filter
  /// Update selected distance
  void updateDistanceFilter(int distance) {
    selectedDistance.value = distance;
    // Update selection status in distance options
    for (var option in distanceOptions) {
      option['isSelected'] = option['value'] == distance;
    }
    distanceOptions.refresh();

    // Refresh data
    refreshBrands();
  }

  /// Reset distance filter
  void resetDistanceFilter() {
    updateDistanceFilter(0);
  }
}
