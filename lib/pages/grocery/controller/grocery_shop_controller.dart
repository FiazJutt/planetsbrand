import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:planetbrand/pages/grocery/models/grocery_stalls_model.dart';
import 'package:planetbrand/pages/grocery/models/grocery_malls_model.dart';
import 'package:planetbrand/utils/api_helper.dart';
import 'package:planetbrand/utils/config.dart';
import 'package:planetbrand/utils/app_helpers.dart';

class GroceryController extends GetxController {
  // Reactive variables
  RxBool loader = false.obs;
  RxInt selectedTabIndex = 0.obs;
  RxInt selectedDistance = 0.obs;
  RxBool isFetchingMore = false.obs;

  // Pagination variables
  RxInt currentPage = 1.obs;
  RxInt lastPage = 1.obs;

  RxList<Map<String, dynamic>> distanceOptions =
      <Map<String, dynamic>>[
        {'label': 'All', 'value': 0, 'isSelected': true},
        {'label': '20 km', 'value': 20, 'isSelected': false},
        {'label': '50 km', 'value': 50, 'isSelected': false},
      ].obs;

  // Stalls data
  Rx<GroceryStallsModel?> stallsModel = Rx(null);
  RxBool stallsLoader = false.obs;

  // Malls data
  Rx<GroceryMallsModel?> mallsModel = Rx(null);
  RxBool mallsLoader = false.obs;

  // Track if malls have been loaded
  RxBool mallsLoaded = false.obs;

  // Search state
  var isSearchVisible = false.obs;
  final TextEditingController searchController = TextEditingController();
  RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchStalls();
    // fetchMalls(); // Don't fetch malls initially, fetch when tab is switched
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  /// Fetch grocery stalls data with pagination
  Future<void> fetchStalls({bool isLoadMore = false}) async {
    if (isLoadMore) {
      isFetchingMore.value = true;
    } else {
      stallsLoader(true);
    }
    try {
      // final response = await ApiHelper.getRequestWithToken(
      //   '$groceryShopsEndPoints?page=${currentPage.value}',
      // );
      // Add distance parameter to the API call if a distance is selected
      String apiUrl = '$groceryShopsEndPoints?page=${currentPage.value}';
      if (selectedDistance.value > 0) {
        apiUrl += '&distance=${selectedDistance.value}';
      }
      final response = await ApiHelper.getRequestWithToken(apiUrl);

      final responseData = jsonDecode(response.body);

      if (responseData['status_code'] == 200) {
        final stallModel = GroceryStallsModel.fromJson(responseData);
        if (isLoadMore) {
          // Add new data to existing list
          stallsModel.value?.data?.addAll(stallModel.data ?? []);
        } else {
          // Replace existing data
          stallsModel.value = stallModel;
        }
        // Update pagination info
        lastPage.value = stallModel.lastPage ?? 1;
      }
    } catch (e) {
      print('Error fetching stalls: $e');
      errorSnackBar(message: "Error fetching stalls: $e");
    } finally {
      stallsLoader(false);
      isFetchingMore.value = false;
    }
  }

  /// Fetch grocery malls data with pagination
  Future<void> fetchMalls({bool isLoadMore = false}) async {
    print(
      'Fetching malls... isLoadMore: $isLoadMore, mallsLoaded: ${mallsLoaded.value}',
    );

    // If already loaded and not loading more, don't fetch again unless forced
    if (mallsLoaded.value && !isLoadMore) {
      print('Malls already loaded, skipping fetch');
      return;
    }

    if (isLoadMore) {
      isFetchingMore.value = true;
    } else {
      mallsLoader(true);
    }

    try {
      // final response = await ApiHelper.getRequestWithToken(
      //   '$shopsEndPoint?page=${currentPage.value}', // Fixed: Use brandsEndPoint instead of shopsEndPoint
      // );
      // Add distance parameter to the API call if a distance is selected
      String apiUrl = '$shopsEndPoint?page=${currentPage.value}';
      if (selectedDistance.value > 0) {
        apiUrl += '&distance=${selectedDistance.value}';
      }

      final response = await ApiHelper.getRequestWithToken(apiUrl);

      final responseData = jsonDecode(response.body);
      print('Malls API Response Status Code: ${responseData['status_code']}');
      print(
        'Malls API Response Data Length: ${responseData['data']?.length ?? 0}',
      );

      if (responseData['status_code'] == 200) {
        final mallModel = GroceryMallsModel.fromJson(responseData);
        if (isLoadMore) {
          // Add new data to existing list
          mallsModel.value?.data?.addAll(mallModel.data ?? []);
          print(
            'Added more malls data, total now: ${mallsModel.value?.data?.length ?? 0}',
          );
        } else {
          // Replace existing data
          mallsModel.value = mallModel;
          print('Set new malls data, total: ${mallModel.data?.length ?? 0}');
        }
        // Update pagination info
        lastPage.value = mallModel.lastPage ?? 1;
        mallsLoaded.value = true; // Mark as loaded
        print('Malls loaded successfully. Last page: ${lastPage.value}');
      } else {
        print('Malls API returned status code: ${responseData['status_code']}');
      }
    } catch (e) {
      print('Error fetching malls: $e');
      errorSnackBar(message: "Error fetching malls: $e");
    } finally {
      mallsLoader(false);
      isFetchingMore.value = false;
    }
  }

  /// Change selected tab
  void changeTab(int index) {
    print('Changing tab to: $index');
    selectedTabIndex.value = index;
    // Load malls data when switching to malls tab for the first time
    if (index == 1 && !mallsLoaded.value) {
      print('Loading malls for the first time');
      currentPage.value = 1; // Reset to first page
      fetchMalls();
    }
  }

  /// Refresh stalls data
  Future<void> refreshStalls() async {
    currentPage.value = 1; // Reset to first page
    await fetchStalls();
  }

  /// Refresh malls data
  Future<void> refreshMalls() async {
    print('Refreshing malls data');
    currentPage.value = 1; // Reset to first page
    mallsLoaded.value = false; // Reset loaded state to force reload
    await fetchMalls();
  }

  /// Get current stalls list
  List<StallData> get stallsList {
    return stallsModel.value?.data ?? [];
  }

  /// Get current malls list
  List<MallData> get mallsList {
    return mallsModel.value?.data ?? [];
  }

  /// Filtered lists based on search query
  List<StallData> get filteredStallsList {
    final String query = searchQuery.value.trim().toLowerCase();
    if (query.isEmpty) return stallsList;
    return stallsList.where((stall) {
      final name = (stall.shopName ?? stall.name ?? '').toLowerCase();
      return name.contains(query);
    }).toList();
  }

  List<MallData> get filteredMallsList {
    final String query = searchQuery.value.trim().toLowerCase();
    if (query.isEmpty) return mallsList;
    return mallsList.where((mall) {
      final name = (mall.shopName ?? mall.name ?? '').toLowerCase();
      return name.contains(query);
    }).toList();
  }

  /// Check if stalls are empty
  bool get isStallsEmpty {
    return (searchQuery.value.isEmpty ? stallsList : filteredStallsList)
        .isEmpty;
  }

  /// Check if malls are empty
  bool get isMallsEmpty {
    print(
      'Checking if malls are empty. Malls list length: ${mallsList.length}',
    );
    return (searchQuery.value.isEmpty ? mallsList : filteredMallsList).isEmpty;
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

    // Refresh data based on current tab
    if (selectedTabIndex.value == 0) {
      refreshStalls();
    } else {
      refreshMalls();
    }
  }

  /// Reset distance filter
  void resetDistanceFilter() {
    updateDistanceFilter(0);
  }

  /// Load more data for pagination
  void loadMore() {
    if (currentPage.value < lastPage.value && !isFetchingMore.value) {
      currentPage.value++;
      if (selectedTabIndex.value == 0) {
        fetchStalls(isLoadMore: true);
      } else {
        fetchMalls(isLoadMore: true);
      }
    }
  }

  /// Update search query
  void setSearchQuery(String query) {
    searchQuery.value = query;
  }

  // Add this method
  void toggleSearch() {
    isSearchVisible.value = !isSearchVisible.value;
  }
}
