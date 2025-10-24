import 'dart:convert';
import 'dart:developer';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:planetbrand/pages/brands/models/brand_model.dart';
import 'package:planetbrand/pages/grocery/models/grocery_malls_model.dart';
import 'package:planetbrand/pages/grocery/models/grocery_stalls_model.dart';
import 'package:planetbrand/pages/search/model/search_product_model.dart';
import 'package:planetbrand/pages/search/model/vendor_model.dart';
import 'package:planetbrand/utils/api_helper.dart';
import 'package:planetbrand/utils/config.dart';

import '../../product_details/countries_model.dart';

enum SearchFilter { all, products, shops, brands, malls }

class SearchProductController extends GetxController {
  // Single search controller
  TextEditingController searchController = TextEditingController();

  // Filter state
  Rx<SearchFilter> selectedFilter = SearchFilter.all.obs;

  // Loading states
  RxBool isLoading = false.obs;
  RxBool isFetchingMore = false.obs;

  // Pagination
  RxInt currentPage = 1.obs;
  RxInt lastPage = 1.obs;

  // Search results
  RxList<Products> products = <Products>[].obs;
  RxList<Vendors> vendors = <Vendors>[].obs;
  RxList<Brands> brands = <Brands>[].obs;
  RxList<MallData> malls = <MallData>[].obs;

  // Location/Countries functionality
  Rx<CountriesModel?> countriesModel = Rx(null);
  var selectedCountry = Rxn<Countries>();
  var selectedProvince = Rxn<Provinces>();
  var provinces = <Provinces>[].obs;
  var cities = <Cities>[].obs;
  var showCountryDropdown = true.obs;
  var showProvinceDropdown = false.obs;
  var showCityDropdown = false.obs;
  RxString selectedCity = "".obs;

  // Legacy controllers for backward compatibility
  TextEditingController searchProductController = TextEditingController();
  TextEditingController searchShopController = TextEditingController();
  TextEditingController unifiedSearchController = TextEditingController();

  // Legacy loading states for backward compatibility
  RxBool loader = false.obs;
  RxBool isFetchingMoreVendors = false.obs;
  RxBool isBrandLoading = false.obs;
  RxBool isFetchingMoreBrands = false.obs;
  RxBool isMallLoading = false.obs;
  RxBool isFetchingMoreMalls = false.obs;
  RxBool isUnifiedSearchLoading = false.obs;

  // Legacy pagination for backward compatibility
  RxInt vendorCurrentPage = 1.obs;
  RxInt vendorLastPage = 1.obs;
  RxInt brandCurrentPage = 1.obs;
  RxInt brandLastPage = 1.obs;
  RxInt mallCurrentPage = 1.obs;
  RxInt mallLastPage = 1.obs;

  // Getters
  bool get hasResults {
    switch (selectedFilter.value) {
      case SearchFilter.all:
        return products.isNotEmpty ||
            vendors.isNotEmpty ||
            brands.isNotEmpty ||
            malls.isNotEmpty;
      case SearchFilter.products:
        return products.isNotEmpty;
      case SearchFilter.shops:
        return vendors.isNotEmpty;
      case SearchFilter.brands:
        return brands.isNotEmpty;
      case SearchFilter.malls:
        return malls.isNotEmpty;
    }
  }

  // bool get canLoadMore {
  //   return currentPage.value < lastPage.value;
  // }

  bool get canLoadMore {
    switch (selectedFilter.value) {
      case SearchFilter.products:
        return currentPage.value < lastPage.value;
      case SearchFilter.shops:
        return vendorCurrentPage.value < vendorLastPage.value;
      case SearchFilter.brands:
        return brandCurrentPage.value < brandLastPage.value;
      case SearchFilter.malls:
        return mallCurrentPage.value < mallLastPage.value;
      case SearchFilter.all:
        return false; // No pagination for "All" view
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchCountries();

    // Sync legacy controllers with main search controller
    searchController.addListener(() {
      searchProductController.text = searchController.text;
      searchShopController.text = searchController.text;
      unifiedSearchController.text = searchController.text;
    });
  }

  @override
  void onClose() {
    searchController.dispose();
    searchProductController.dispose();
    searchShopController.dispose();
    unifiedSearchController.dispose();
    super.onClose();
  }

  // Set filter and perform search
  void setFilter(SearchFilter filter) {
    selectedFilter.value = filter;
    if (searchController.text.isNotEmpty) {
      performSearch();
    }
  }

  // Clear all results
  void clearResults() {
    products.clear();
    vendors.clear();
    brands.clear();
    malls.clear();
    _resetPagination();
  }

  void _resetPagination() {
    currentPage.value = 1;
    lastPage.value = 1;
    vendorCurrentPage.value = 1;
    vendorLastPage.value = 1;
    brandCurrentPage.value = 1;
    brandLastPage.value = 1;
    mallCurrentPage.value = 1;
    mallLastPage.value = 1;
  }

  // Main search method
  Future<void> performSearch({bool isLoadMore = false}) async {
    if (searchController.text.isEmpty) {
      clearResults();
      return;
    }

    if (isLoadMore) {
      isFetchingMore.value = true;
      // Set legacy loading states
      switch (selectedFilter.value) {
        case SearchFilter.shops:
          isFetchingMoreVendors.value = true;
          break;
        case SearchFilter.brands:
          isFetchingMoreBrands.value = true;
          break;
        case SearchFilter.malls:
          isFetchingMoreMalls.value = true;
          break;
        default:
          break;
      }
    } else {
      isLoading.value = true;
      // Set legacy loading states
      loader.value = true;
      isBrandLoading.value = selectedFilter.value == SearchFilter.brands;
      isMallLoading.value = selectedFilter.value == SearchFilter.malls;
      isUnifiedSearchLoading.value = selectedFilter.value == SearchFilter.all;

      if (selectedFilter.value != SearchFilter.all) {
        clearResults();
      }
      _resetPagination();
    }

    try {
      switch (selectedFilter.value) {
        case SearchFilter.all:
          await _searchAll();
          break;
        case SearchFilter.products:
          await _searchProducts(isLoadMore);
          break;
        case SearchFilter.shops:
          await _searchShops(isLoadMore);
          break;
        case SearchFilter.brands:
          await _searchBrands(isLoadMore);
          break;
        case SearchFilter.malls:
          await _searchMalls(isLoadMore);
          break;
      }
    } catch (e) {
      log("Error in search: $e");
    } finally {
      isLoading.value = false;
      isFetchingMore.value = false;
      // Reset legacy loading states
      loader.value = false;
      isFetchingMoreVendors.value = false;
      isBrandLoading.value = false;
      isFetchingMoreBrands.value = false;
      isMallLoading.value = false;
      isFetchingMoreMalls.value = false;
      isUnifiedSearchLoading.value = false;
    }
  }

  // Load more for pagination
  Future<void> loadMore() async {
    if (!canLoadMore || isFetchingMore.value) return;

    switch (selectedFilter.value) {
      case SearchFilter.products:
        currentPage.value++;
        break;
      case SearchFilter.shops:
        vendorCurrentPage.value++;
        break;
      case SearchFilter.brands:
        brandCurrentPage.value++;
        break;
      case SearchFilter.malls:
        mallCurrentPage.value++;
        break;
      case SearchFilter.all:
        return; // No pagination for "All" view
    }

    await performSearch(isLoadMore: true);
  }

  // Search all categories (for "All" filter)
  Future<void> _searchAll() async {
    clearResults();

    // Perform all searches in parallel
    await Future.wait([
      _searchProducts(false, limit: 4),
      _searchShops(false, limit: 3),
      _searchBrands(false, limit: 3),
      _searchMalls(false, limit: 3),
    ]);
  }

  // Search products
  Future<void> _searchProducts(bool isLoadMore, {int? limit}) async {
    try {
      final query = searchController.text;
      final page = isLoadMore ? currentPage.value : 1;

      final response = await ApiHelper.getRequestWithToken(
        "product_search?query=$query&page=$page",
      );

      final responseData = jsonDecode(response.body);
      final searchResponse = SearchProductModel.fromJson(responseData);

      if (searchResponse.statusCode == 200) {
        List<Products> fetchedProducts = searchResponse.products ?? [];

        // Apply limit if specified (for "All" view)
        if (limit != null) {
          fetchedProducts = fetchedProducts.take(limit).toList();
        }

        if (isLoadMore) {
          products.addAll(fetchedProducts);
        } else {
          products.value = fetchedProducts;
        }

        // Only update pagination for individual product search
        if (selectedFilter.value == SearchFilter.products) {
          lastPage.value = searchResponse.lastPage ?? 1;
        }
      }
    } catch (e) {
      log("Error fetching products: $e");
    }
  }

  // Search shops/vendors
  Future<void> _searchShops(bool isLoadMore, {int? limit}) async {
    try {
      final query = searchController.text;
      final page = isLoadMore ? vendorCurrentPage.value : 1;

      // Use 'search' parameter instead of 'query' for better API compatibility
      final response = await ApiHelper.getRequest(
        'search/shops?query=$query&page=$page&per_page=20',
      );
      final json = jsonDecode(response.body);

      List<Vendors> fetchedVendors =
          (json['vendors'] as List)
              .map((item) => Vendors.fromJson(item))
              .toList();

      // Apply limit if specified (for "All" view)
      if (limit != null) {
        fetchedVendors = fetchedVendors.take(limit).toList();
      }

      if (isLoadMore) {
        vendors.addAll(fetchedVendors);
      } else {
        vendors.value = fetchedVendors;
      }

      // Only update pagination for individual shop search
      if (selectedFilter.value == SearchFilter.shops) {
        vendorLastPage.value = json['last_page'] ?? 1;
      }
    } catch (e) {
      log("Error fetching vendors: $e");
    }
  }

  // Search brands
  Future<void> _searchBrands(bool isLoadMore, {int? limit}) async {
    try {
      final query = searchController.text;
      final page = isLoadMore ? brandCurrentPage.value : 1;

      // Use 'search' parameter instead of 'name' for better API compatibility
      final response = await ApiHelper.getRequestWithToken(
        'search/brands?query=$query&page=$page',
      );
      final responseData = jsonDecode(response.body);

      if (responseData['status_code'] == 200) {
        final brandModel = BrandModel.fromJson(responseData);
        List<Brands> fetchedBrands = brandModel.brands ?? [];

        // Apply limit if specified (for "All" view)
        if (limit != null) {
          fetchedBrands = fetchedBrands.take(limit).toList();
        }

        if (isLoadMore) {
          brands.addAll(fetchedBrands);
        } else {
          brands.value = fetchedBrands;
        }

        // Only update pagination for individual brand search
        if (selectedFilter.value == SearchFilter.brands) {
          brandLastPage.value = brandModel.lastPage ?? 1;
        }
      }
    } catch (e) {
      log("Error fetching brands: $e");
    }
  }

  // Search malls
  Future<void> _searchMalls(bool isLoadMore, {int? limit}) async {
    try {
      final query = searchController.text;
      final page = isLoadMore ? mallCurrentPage.value : 1;

      // Use 'search' parameter for mall search as well
      final response = await ApiHelper.getRequestWithToken(
        '$groceryShopsEndPoints?query=$query&page=$page',
      );
      final responseData = jsonDecode(response.body);

      if (responseData['status_code'] == 200) {
        final mallModel = GroceryMallsModel.fromJson(responseData);
        List<MallData> fetchedMalls = mallModel.data ?? [];

        // Apply limit if specified (for "All" view)
        if (limit != null) {
          fetchedMalls = fetchedMalls.take(limit).toList();
        }

        if (isLoadMore) {
          malls.addAll(fetchedMalls);
        } else {
          malls.value = fetchedMalls;
        }

        // Only update pagination for individual mall search
        if (selectedFilter.value == SearchFilter.malls) {
          mallLastPage.value = mallModel.lastPage ?? 1;
        }
      }
    } catch (e) {
      log("Error fetching malls: $e");
    }
  }

  // ============ LOCATION/COUNTRIES FUNCTIONALITY ============
  Future<void> fetchCountries() async {
    try {
      final response = await ApiHelper.getRequestWithToken("countries");
      final responseData = jsonDecode(response.body);
      if (responseData['status_code'] == 200) {
        countriesModel.value = CountriesModel.fromJson(responseData);
      }
    } catch (e) {
      log("Error fetching countries: $e");
    }
  }

  void onCountrySelected(Countries country) {
    selectedCountry.value = null; // Force update
    selectedCountry.value = country;

    selectedProvince.value = null;
    selectedCity.value = '';

    provinces.value = country.provinces ?? [];
    if (provinces.isNotEmpty) {
      showCountryDropdown.value = false;
      showProvinceDropdown.value = true;
      showCityDropdown.value = false;
    } else {
      showCountryDropdown.value = true;
      showProvinceDropdown.value = false;
      showCityDropdown.value = false;
    }
  }

  void onProvinceSelected(Provinces province) {
    selectedProvince.value = province;
    cities.value = province.cities ?? [];
    selectedCity.value = '';

    if (cities.isNotEmpty) {
      showProvinceDropdown.value = false;
      showCityDropdown.value = true;
    } else {
      showProvinceDropdown.value = true;
      showCityDropdown.value = false;
    }
  }

  void onCitySelected(String city) {
    selectedCity.value = city;
    searchController.text = city; // Set the search text to the selected city
    selectedFilter.value = SearchFilter.shops; // Set filter to shops
    performSearch(); // Perform search with the selected city

    // Reset location selection
    selectedCountry.value = null;
    selectedProvince.value = null;
    selectedCity.value = '';

    provinces.clear();
    cities.clear();

    showCountryDropdown.value = true;
    showProvinceDropdown.value = false;
    showCityDropdown.value = false;
  }

  // Future<void> fetchVendorsByLocation({
  //   bool isLoadMore = false,
  //   required bool loading,
  // }) async {
  //   if (isLoadMore) {
  //     isFetchingMoreVendors.value = true;
  //   } else {
  //     isLoading.value = loading;
  //     vendorCurrentPage.value = 1;
  //   }
  //
  //   try {
  //     final response = await ApiHelper.getRequest(
  //       'road_search?location=${selectedCity.value}&page=${vendorCurrentPage.value}&per_page=20',
  //     );
  //     final json = jsonDecode(response.body);
  //
  //     final List<Vendors> fetched = (json['vendors'] as List)
  //         .map((item) => Vendors.fromJson(item))
  //         .toList();
  //
  //     if (isLoadMore) {
  //       vendors.addAll(fetched);
  //     } else {
  //       vendors.value = fetched;
  //     }
  //
  //     vendorLastPage.value = json['last_page'] ?? 1;
  //   } catch (e) {
  //     log("Error fetching vendors by location: $e");
  //   } finally {
  //     isLoading.value = false;
  //     isFetchingMoreVendors.value = false;
  //   }
  // }

  // ============ LEGACY METHODS FOR BACKWARD COMPATIBILITY ============
  Future<void> fetchSearchedProducts({
    bool isLoadMore = false,
    required bool loading,
  }) async {
    selectedFilter.value = SearchFilter.products;
    await performSearch(isLoadMore: isLoadMore);
  }

  Future<void> fetchVendors({
    bool isLoadMore = false,
    required bool loading,
  }) async {
    selectedFilter.value = SearchFilter.shops;
    await performSearch(isLoadMore: isLoadMore);
  }

  Future<void> fetchBrands({
    bool isLoadMore = false,
    required bool loading,
  }) async {
    selectedFilter.value = SearchFilter.brands;
    await performSearch(isLoadMore: isLoadMore);
  }

  Future<void> fetchMalls({
    bool isLoadMore = false,
    required bool loading,
  }) async {
    selectedFilter.value = SearchFilter.malls;
    await performSearch(isLoadMore: isLoadMore);
  }

  // Legacy method for unified search (if called from elsewhere)
  Future<void> performUnifiedSearch({required bool loading}) async {
    selectedFilter.value = SearchFilter.all;
    await performSearch();
  }

  // Legacy load more methods
  void loadMoreVendors() {
    if (vendorCurrentPage.value < vendorLastPage.value &&
        !isFetchingMoreVendors.value) {
      vendorCurrentPage.value++;
      fetchVendors(isLoadMore: true, loading: false);
    }
  }

  void loadMoreBrands() {
    if (brandCurrentPage.value < brandLastPage.value &&
        !isFetchingMoreBrands.value) {
      brandCurrentPage.value++;
      fetchBrands(isLoadMore: true, loading: false);
    }
  }

  void loadMoreMalls() {
    if (mallCurrentPage.value < mallLastPage.value &&
        !isFetchingMoreMalls.value) {
      mallCurrentPage.value++;
      fetchMalls(isLoadMore: true, loading: false);
    }
  }

  // ============ UTILITY METHODS ============
  void clearAllSearch() {
    products.clear();
    vendors.clear();
    brands.clear();
    malls.clear();
    _resetPagination();
  }

  // Sync search controllers (useful for legacy code)
  void syncSearchControllers() {
    searchProductController.text = searchController.text;
    searchShopController.text = searchController.text;
    unifiedSearchController.text = searchController.text;
  }
}
