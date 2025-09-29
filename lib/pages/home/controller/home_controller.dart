import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:planetbrand/pages/brands/models/brand_model.dart';
import 'package:planetbrand/pages/home/models/category_model.dart';
import 'package:planetbrand/pages/home/models/deal_product_model.dart';
import 'package:planetbrand/pages/home/models/featured_product_model.dart';
import 'package:planetbrand/pages/home/models/groceries_model.dart';
import 'package:planetbrand/pages/home/models/hot_product_model.dart';
import 'package:planetbrand/pages/home/models/slider_model.dart';
import 'package:planetbrand/utils/api_helper.dart';
import 'package:planetbrand/utils/config.dart';

class HomeController extends GetxController {
  TextEditingController searchController = TextEditingController();
  RxInt currentIndex = 0.obs;
  Rx<CategoryModel?> categoryModel = Rx(null);
  Rx<SliderModel?> sliderModel = Rx(null);
  Rx<FeaturedProductModel?> featureProductModel = Rx(null);
  Rx<HotProductModel?> hotProductModel = Rx(null);
  Rx<DealProductModel?> dealProductModel = Rx(null);
  Rx<GroceriesModel?> groceriesModel = Rx(null);
  Rx<BrandModel?> brandModel = Rx(null);
  RxBool loader = false.obs;
  @override
  void onInit() {
    super.onInit();
    fetchBrands();
    fetchCategory();
    fetchSlider();
    fetchFeaturedProducts();
    fetchHotProducts();
    fetchDealProducts();
    fetchGroceriesShop();
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

  Future<void> fetchCategory() async {
    loader(true);
    try {
      final response = await ApiHelper.getRequestWithToken(categoriesEndPoint);
      final responseData = jsonDecode(response.body);
      if (responseData['status_code'] == 200) {
        categoryModel.value = CategoryModel.fromJson(responseData);
      }
    } catch (e) {
      rethrow;
    } finally {
      loader(false);
    }
  }

  Future<void> fetchSlider() async {
    loader(true);
    try {
      final response = await ApiHelper.getRequestWithToken(homeSlidersEndPoint);
      final responseData = jsonDecode(response.body);
      if (responseData['status_code'] == 200) {
        sliderModel.value = SliderModel.fromJson(responseData);
      }
    } catch (e) {
      rethrow;
    } finally {
      loader(false);
    }
  }

  Future<void> fetchFeaturedProducts() async {
    loader(true);
    try {
      final response = await ApiHelper.getRequestWithToken(
        getFeaturedProductsEndPoint,
      );
      final responseData = jsonDecode(response.body);
      if (responseData['status_code'] == 200) {
        featureProductModel.value = FeaturedProductModel.fromJson(responseData);
      }
    } catch (e) {
      rethrow;
    } finally {
      loader(false);
    }
  }

  Future<void> fetchHotProducts() async {
    loader(true);
    try {
      final response = await ApiHelper.getRequestWithToken(
        getHotProductsEndPoint,
      );
      final responseData = jsonDecode(response.body);
      if (responseData['status_code'] == 200) {
        hotProductModel.value = HotProductModel.fromJson(responseData);
      }
    } catch (e) {
      rethrow;
    } finally {
      loader(false);
    }
  }

  Future<void> fetchDealProducts() async {
    loader(true);
    try {
      final response = await ApiHelper.getRequestWithToken(
        getDealProductsEndPoint,
      );
      final responseData = jsonDecode(response.body);
      if (responseData['status_code'] == 200) {
        dealProductModel.value = DealProductModel.fromJson(responseData);
      }
    } catch (e) {
      rethrow;
    } finally {
      loader(false);
    }
  }

  Future<void> fetchGroceriesShop() async {
    loader(true);
    try {
      final response = await ApiHelper.getRequestWithToken(
        groceryShopsEndPoints,
      );
      final responseData = jsonDecode(response.body);
      if (responseData['status_code'] == 200) {
        groceriesModel.value = GroceriesModel.fromJson(responseData);
      }
    } catch (e) {
      rethrow;
    } finally {
      loader(false);
    }
  }
}
