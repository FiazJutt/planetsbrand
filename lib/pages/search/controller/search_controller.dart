import 'dart:convert';
import 'dart:developer';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:planetbrand/pages/product_details/countries_model.dart';
import 'package:planetbrand/pages/search/model/search_product_model.dart';
import 'package:planetbrand/pages/search/model/vendor_model.dart';
import 'package:planetbrand/utils/api_helper.dart';

class SearchProductController extends GetxController {
  // Product search state
  RxList<Products> products = <Products>[].obs;
  RxInt currentPage = 1.obs;
  RxInt lastPage = 1.obs;
  RxBool isFetchingMore = false.obs;
  RxBool loader = false.obs;

  // Vendor search state
  RxList<Vendors> vendors = <Vendors>[].obs;
  RxInt vendorCurrentPage = 1.obs;
  RxInt vendorLastPage = 1.obs;
  RxBool isFetchingMoreVendors = false.obs;
  RxBool isLoading = false.obs;

  // Search input controller
  TextEditingController searchProductController = TextEditingController();
  TextEditingController searchShopController = TextEditingController();
  RxString selectedCity = "".obs;

  @override
  void onInit() {
    super.onInit();
    fetchSearchedProducts(loading: true);
    fetchVendors(loading: true);
    fetchCountries();
  }

  Future<void> fetchSearchedProducts({
    bool isLoadMore = false,
    required bool loading,
  }) async {
    if (isLoadMore) {
      isFetchingMore.value = true;
    } else {
      loader.value = loading;
      currentPage.value = 1;
    }

    try {
      final response = await ApiHelper.getRequestWithToken(
        "product_search?query=${searchProductController.text}&page=${currentPage.value}",
      );

      final responseData = jsonDecode(response.body);
      final searchResponse = SearchProductModel.fromJson(responseData);

      if (searchResponse.statusCode == 200) {
        if (isLoadMore) {
          products.addAll(searchResponse.products ?? []);
        } else {
          products.value = searchResponse.products ?? [];
        }

        lastPage.value = searchResponse.lastPage ?? 1;
      }
    } catch (e) {
      log("Error: $e");
    } finally {
      loader.value = false;
      isFetchingMore.value = false;
    }
  }

  void loadMore() {
    if (currentPage.value < lastPage.value && !isFetchingMore.value) {
      currentPage.value++;
      fetchSearchedProducts(isLoadMore: true, loading: true);
    }
  }

  Future<void> fetchVendors({
    bool isLoadMore = false,
    required bool loading,
  }) async {
    if (isLoadMore) {
      isFetchingMoreVendors.value = true;
    } else {
      isLoading.value = loading;
      vendorCurrentPage.value = 1;
    }

    try {
      final response = await ApiHelper.getRequest(
        'road_search?location=${searchShopController.text}&page=${vendorCurrentPage.value}&per_page=20',
      );
      final json = jsonDecode(response.body);

      final List<Vendors> fetched =
          (json['vendors'] as List)
              .map((item) => Vendors.fromJson(item))
              .toList();

      if (isLoadMore) {
        vendors.addAll(fetched);
      } else {
        vendors.value = fetched;
      }

      vendorLastPage.value = json['last_page'];
    } catch (e) {
      log("Error fetching vendors: $e");
    } finally {
      isLoading.value = false;
      isFetchingMoreVendors.value = false;
    }
  }

  void loadMoreVendors() {
    if (vendorCurrentPage.value < vendorLastPage.value &&
        !isFetchingMoreVendors.value) {
      vendorCurrentPage.value++;
      fetchVendors(isLoadMore: true, loading: false);
    }
  }

  Rx<CountriesModel?> countriesModel = Rx(null);

  var selectedCountry = Rxn<Countries>();
  var selectedProvince = Rxn<Provinces>();

  var provinces = <Provinces>[].obs;
  var cities = <Cities>[].obs;

  var showCountryDropdown = true.obs;
  var showProvinceDropdown = false.obs;
  var showCityDropdown = false.obs;

  Future<void> fetchCountries() async {
    try {
      final response = await ApiHelper.getRequestWithToken("countries");
      final responseData = jsonDecode(response.body);
      if (responseData['status_code'] == 200) {
        countriesModel.value = CountriesModel.fromJson(responseData);
      }
    } catch (e) {
      rethrow;
    }
  }

  void onCountrySelected(Countries country) {
    selectedCountry.value = null; // 🔄 force update even if same country
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
    fetchVendorsByLocation(loading: false);
    selectedCountry.value = null;
    selectedProvince.value = null;
    selectedCity.value = '';

    provinces.clear();
    cities.clear();
    fetchCountries();
    showCountryDropdown.value = true;
    showProvinceDropdown.value = false;
    showCityDropdown.value = false;
  }

  Future<void> fetchVendorsByLocation({
    bool isLoadMore = false,
    required bool loading,
  }) async {
    if (isLoadMore) {
      isFetchingMoreVendors.value = true;
    } else {
      isLoading.value = loading;
      vendorCurrentPage.value = 1;
    }

    try {
      final response = await ApiHelper.getRequest(
        'road_search?location=${selectedCity.value}&page=${vendorCurrentPage.value}&per_page=20',
      );
      final json = jsonDecode(response.body);

      final List<Vendors> fetched =
          (json['vendors'] as List)
              .map((item) => Vendors.fromJson(item))
              .toList();

      if (isLoadMore) {
        vendors.addAll(fetched);
      } else {
        vendors.value = fetched;
      }

      vendorLastPage.value = json['last_page'];
    } catch (e) {
      log("Error fetching vendors: $e");
    } finally {
      isLoading.value = false;
      isFetchingMoreVendors.value = false;
    }
  }
}
