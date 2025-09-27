import 'dart:convert';
import 'package:get/get.dart';
import 'package:planetbrand/pages/festivals/models/festival_model.dart';
import 'package:planetbrand/utils/api_helper.dart';
import 'package:planetbrand/utils/config.dart';

class FestivalController extends GetxController {
  RxBool loader = false.obs;
  RxBool isFetchingMore = false.obs;
  RxList<FestivalList> festival = <FestivalList>[].obs;
  RxInt currentPage = 1.obs;
  RxInt lastPage = 1.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFestivals();
  }

  Future<void> fetchFestivals({bool isLoadMore = false}) async {
    if (isLoadMore) {
      isFetchingMore.value = true;
    } else {
      loader(true);
    }

    try {
      final response = await ApiHelper.getRequestWithToken(
        '$festivelsEndPoint?page=${currentPage.value}',
      );
      final responseData = jsonDecode(response.body);

      if (responseData['status_code'] == 200) {
        final festivalModel = FestivalModel.fromJson(responseData);
        if (isLoadMore) {
          festival.addAll(festivalModel.festivalList ?? []);
        } else {
          festival.value = festivalModel.festivalList ?? [];
        }
        lastPage.value = festivalModel.lastPage ?? 1;
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
      fetchFestivals(isLoadMore: true);
    }
  }
}
