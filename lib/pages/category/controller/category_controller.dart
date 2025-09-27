import 'dart:convert';

import 'package:get/get.dart';
import 'package:planetbrand/pages/category/model/category_product_model.dart';
import 'package:planetbrand/utils/api_helper.dart';
import 'package:planetbrand/utils/config.dart';

class CategoryController extends GetxController {
  RxBool loader = false.obs;

  Rx<CategoryProductModel?> categoryProductModel = Rx(null);

  Future<void> fetchCategoryProducts({required int categoryID}) async {
    loader(true);
    try {
      final response = await ApiHelper.getRequestWithToken(
        "$getcatprosEndPoint/$categoryID",
      );
      final responseData = jsonDecode(response.body);
      if (responseData['status_code'] == 200) {
        categoryProductModel.value = CategoryProductModel.fromJson(
          responseData,
        );
      }
    } catch (e) {
      rethrow;
    } finally {
      loader(false);
    }
  }
}
