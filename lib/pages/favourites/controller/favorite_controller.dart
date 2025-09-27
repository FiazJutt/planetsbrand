import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:planetbrand/pages/favourites/models/favorite_product_model.dart';
import 'package:planetbrand/utils/api_helper.dart';
import 'package:planetbrand/utils/config.dart';

class FavoriteController extends GetxController {
  RxBool loader = false.obs;

  Rx<FavoriteProductsModel?> favoriteProductsModel = Rx(null);
  @override
  void onInit() {
    super.onInit();
    fetchFavoriteProducts();
  }

  Future<void> fetchFavoriteProducts() async {
    loader(true);
    try {
      final response = await ApiHelper.getRequestWithToken(
        getFavoriteProductsEndPoint,
      );
      final responseData = jsonDecode(response.body);
      if (responseData['status_code'] == 200) {
        favoriteProductsModel.value = FavoriteProductsModel.fromJson(
          responseData,
        );
      }
    } catch (e) {
      rethrow;
    } finally {
      loader(false);
    }
  }

  addToFavourite({required int productID}) async {
    try {
      final response = await ApiHelper.postRequestWithToken(
        addFavouriteProductEndPoint,
        {'product_id': productID},
      );
      final responseData = jsonDecode(response.body);
      if (responseData['status_code'] == 200) {
        fetchFavoriteProducts();
      } else {
        log("addFavouriteProductEndPoint PROFILE :: $responseData");
      }
    } catch (e) {
      rethrow;
    }
  }

  removeFromFavourite({required int productID}) async {
    try {
      final response = await ApiHelper.postRequestWithToken(
        removeFavouriteProductEndPoint,
        {'product_id': productID},
      );
      final responseData = jsonDecode(response.body);
      if (responseData['status_code'] == 200) {
        fetchFavoriteProducts();
      } else {
        log("removeFavouriteProductEndPoint PROFILE :: $responseData");
      }
    } catch (e) {
      rethrow;
    }
  }
}
