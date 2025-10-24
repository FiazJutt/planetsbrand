import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';
import 'package:planetbrand/components/common_not_found_tile.dart';
import 'package:planetbrand/components/common_searchable_drop_down.dart';
import 'package:planetbrand/components/common_shimmer_effect.dart';
import 'package:planetbrand/components/common_text_filed.dart';
import 'package:planetbrand/pages/search/controller/search_controller.dart';
import 'package:planetbrand/pages/shop/shop_detail_screen.dart';
import 'package:planetbrand/utils/app_colors.dart';
import 'package:planetbrand/utils/app_helpers.dart';
import 'package:planetbrand/utils/config.dart';

class SearchShopScreen extends StatelessWidget {
  SearchShopScreen({super.key});

  final SearchProductController shopController = Get.put(
    SearchProductController(),
  );
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 100 &&
          !shopController.isFetchingMoreVendors.value &&
          shopController.vendorCurrentPage.value <
              shopController.vendorLastPage.value) {
        shopController.loadMoreVendors();
      }
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Text(
          "Shop",
          style: GoogleFonts.montserrat(
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: HeroIcon(HeroIcons.arrowLeft, size: 20),
        ),
      ),
      body: Obx(() {
        return shopController.isLoading.value
            ? CommonShimmerEffect()
            : RefreshIndicator(
              onRefresh: () async {
                shopController.vendorCurrentPage.value = 1;
                await shopController.fetchVendors(loading: true);
              },
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    child: CommonTextField(
                      textEditingController:
                          shopController.searchShopController,
                      hitText: "Search shop name or address...",
                      labelText: "Search shops...",
                      suffixIcons: IconButton(
                        onPressed: () async {
                          shopController.vendorCurrentPage.value = 1;
                          await shopController.fetchVendors(loading: false);
                        },
                        icon: HeroIcon(HeroIcons.magnifyingGlass),
                      ),
                      onChange: (value) async {
                        shopController.vendorCurrentPage.value = 1;
                        await shopController.fetchVendors(loading: false);
                      },
                    ),
                  ),
                  // COUNTRY DROPDOWN
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Obx(
                      () => Visibility(
                        visible: shopController.showCountryDropdown.value,
                        child: CommonSearchableDropDown(
                          itemList:
                              shopController.countriesModel.value?.countries
                                  ?.map((e) => e.country ?? "")
                                  .toList() ??
                              [],
                          onChangeValue: (value) {
                            final selected = shopController
                                .countriesModel
                                .value
                                ?.countries
                                ?.firstWhere(
                                  (element) => element.country == value,
                                );
                            if (selected != null) {
                              shopController.onCountrySelected(selected);
                            }
                          },
                          hintText: "Select Country",
                          hintTextOfField: "Search Country",
                          selectedItem:
                              shopController.selectedCountry.value?.country ??
                              '',
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Obx(
                      () => Visibility(
                        visible: shopController.showProvinceDropdown.value,
                        child: CommonSearchableDropDown(
                          itemList:
                              shopController.provinces
                                  .map((e) => e.province ?? "")
                                  .toList(),
                          onChangeValue: (value) {
                            final selected = shopController.provinces
                                .firstWhere(
                                  (element) => element.province == value,
                                );
                            shopController.onProvinceSelected(selected);
                          },
                          hintText: "Select Province",
                          hintTextOfField: "Search Province",
                          selectedItem:
                              shopController.selectedProvince.value?.province ??
                              '',
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Obx(
                      () => Visibility(
                        visible: shopController.showCityDropdown.value,
                        child: CommonSearchableDropDown(
                          itemList:
                              shopController.cities
                                  .map((e) => e.city ?? "")
                                  .toList(),
                          onChangeValue: (value) {
                            shopController.onCitySelected(value.toString());
                          },
                          hintText: "Select City",
                          hintTextOfField: "Search City",
                          selectedItem: shopController.selectedCity.value,
                        ),
                      ),
                    ),
                  ),

                  shopController.vendors.isEmpty
                      ? const Expanded(child: CommonNotFoundTile())
                      : Expanded(
                        child: GridView.builder(
                          controller: scrollController,
                          padding: const EdgeInsets.all(10),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                                mainAxisExtent: 150,
                              ),
                          itemCount: shopController.vendors.length,
                          itemBuilder: (context, index) {
                            final shop = shopController.vendors[index];

                            return GestureDetector(
                              onTap: () {
                                Get.to(
                                  () => ShopDetailScreen(shopID: shop.id ?? 0),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: AppColors.whiteColor,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.lightGrayColor,
                                      spreadRadius: 1,
                                      blurRadius: 1,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: loadNetworkImage(
                                        height: 80,
                                        width: 80,
                                        fit: BoxFit.cover,
                                        "$imageBaseUrl${shop.logo}",
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    SizedBox(
                                      width: 100,
                                      child: Text(
                                        shop.shopName ?? shop.name ?? "",
                                        maxLines: 2,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.montserrat(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                  Obx(() {
                    return shopController.isFetchingMoreVendors.value
                        ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: getSimpleLoading(
                            color: AppColors.primaryColor,
                          ),
                        )
                        : shopController.vendorCurrentPage.value >=
                            shopController.vendorLastPage.value
                        ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Text("No more shops"),
                        )
                        : const SizedBox.shrink();
                  }),
                ],
              ),
            );
      }),
    );
  }
}
