import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';
import 'package:planetbrand/components/common_text_filed.dart';
import 'package:planetbrand/pages/brands/brand_product_screen.dart';
import 'package:planetbrand/pages/brands/brand_screen.dart';
import 'package:planetbrand/pages/brands/controller/brand_controller.dart';
import 'package:planetbrand/pages/category/category_product_screen.dart';
import 'package:planetbrand/pages/festivals/festival_screen.dart';
import 'package:planetbrand/pages/grocery/grocery_UI.dart';
import 'package:planetbrand/pages/grocery/grocery_main_screen.dart';
import 'package:planetbrand/pages/home/category_screen.dart';
import 'package:planetbrand/pages/home/controller/home_controller.dart';
import 'package:planetbrand/pages/home/deal_of_day_screen.dart';
import 'package:planetbrand/pages/home/featured_product_screen.dart';
import 'package:planetbrand/pages/home/grocery_shop_screen.dart';
import 'package:planetbrand/pages/home/hot_sale_screen.dart';
import 'package:planetbrand/pages/other_page/webview_screen.dart';
import 'package:planetbrand/pages/product_details/product_detail_screen.dart';
import 'package:planetbrand/pages/search/controller/search_controller.dart';
import 'package:planetbrand/pages/search/search_product_screen.dart';
import 'package:planetbrand/pages/search/search_shop_screen.dart';
import 'package:planetbrand/pages/search/unified_search_screen.dart';
import 'package:planetbrand/pages/shop/shop_detail_screen.dart';
import 'package:planetbrand/pages/shop/shop_page.dart';
import 'package:planetbrand/utils/app_assets.dart';
import 'package:planetbrand/utils/app_colors.dart';
import 'package:planetbrand/utils/app_helpers.dart';
import 'package:planetbrand/utils/config.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final HomeController homeController = Get.put(HomeController());
  final SearchProductController searchProductController = Get.put(
    SearchProductController(),
  );
  final BrandController brandController = Get.put(BrandController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.appbarBackgroundColor,
        elevation: 0,

        actions: [
          IconButton(
            icon: HeroIcon(HeroIcons.magnifyingGlass),
            onPressed: () {
              Get.to(() => UnifiedSearchScreen());
              // Get.to(() => SearchProductScreen());
            },
          ),

          IconButton(
            icon: HeroIcon(HeroIcons.mapPin),
            onPressed: () {
              Get.to(() => SearchShopScreen());
            },
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: AppColors.primaryColor,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30),
              Image.asset(AppAssets.logo, width: 200),
              const Divider(),
              drawerTile(
                title: "Home",
                icon: HeroIcons.home,
                onPress: () {
                  Get.back();
                },
              ),
              drawerTile(
                title: "Brands",
                icon: HeroIcons.bolt,
                onPress: () {
                  Get.back();
                  Get.to(() => BrandScreen());
                },
              ),
              drawerTile(
                title: "Shops",
                icon: HeroIcons.buildingStorefront,
                onPress: () {
                  Get.back();
                  Get.to(() => ShopPage());
                },
              ),
              drawerTile(
                title: "Festivals",
                icon: HeroIcons.shoppingCart,
                onPress: () {
                  Get.back();
                  Get.to(() => FestivalScreen());
                },
              ),
              drawerTile(
                title: "Featured",
                icon: HeroIcons.presentationChartBar,
                onPress: () {
                  Get.back();
                  Get.to(() => FeaturedProductScreen());
                },
              ),
              drawerTile(
                title: "Hot Sale",
                icon: HeroIcons.shoppingBag,
                onPress: () {
                  Get.back();
                  Get.to(() => HotSaleScreen());
                },
              ),
              drawerTile(
                title: "Groceries",
                icon: HeroIcons.buildingLibrary,
                onPress: () {
                  Get.back();
                  Get.to(() => GroceryShopScreen());
                },
              ),
              drawerTile(
                title: "About Us",
                icon: HeroIcons.informationCircle,
                onPress: () {
                  Get.back();
                  Get.to(() => WebViewScreen(url: aboutUsUrl));
                },
              ),
              drawerTile(
                title: "Privacy Policy",
                icon: HeroIcons.clipboardDocument,
                onPress: () {
                  Get.back();
                  Get.to(() => WebViewScreen(url: privacyPolicyUrl));
                },
              ),
            ],
          ),
        ),
      ),
      body: Obx(() {
        return Skeletonizer(
          enabled: homeController.loader.value,
          child: RefreshIndicator(
            onRefresh: () async {
              await homeController.fetchCategory();
              await homeController.fetchBrands();
              await homeController.fetchSlider();
              await homeController.fetchFeaturedProducts();
              await homeController.fetchHotProducts();
              await homeController.fetchDealProducts();
              await homeController.fetchGroceriesShop();
            },
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              children: [
                // _searchBar(),
                // const SizedBox(height: 10),
                _buildCarousel(),
                const SizedBox(height: 10),
                _buildDotsIndicator(),
                const SizedBox(height: 15),
                _buildQuickLinks(),
                const SizedBox(height: 15),
                _buildCategoriesSection(),
                const SizedBox(height: 15),
                _buildFeatureProducts(),
                const SizedBox(height: 15),
                _buildBrandsSection(),
                const SizedBox(height: 15),
                _buildHotProducts(),
                const SizedBox(height: 15),
                _buildDealProducts(),
                const SizedBox(height: 15),
                _buildCommonSection(),
              ],
            ),
          ),
        );
      }),
    );
  }

  // --- WIDGETS BELOW --- //

  Widget drawerTile({
    required String title,
    required HeroIcons icon,
    required Function() onPress,
  }) {
    return ListTile(
      leading: HeroIcon(
        icon,
        // style: HeroIconStyle.solid,
        color: AppColors.whiteColor,
      ),
      title: Text(
        title,
        style: GoogleFonts.montserrat(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: AppColors.whiteColor,
        ),
      ),
      onTap: onPress,
    );
  }

  Widget searchBar() {
    return CommonTextField(
      suffixIcons: IconButton(
        onPressed: () {
          searchProductController.fetchSearchedProducts(loading: true);
          Get.to(() => SearchProductScreen());
        },
        icon: const HeroIcon(HeroIcons.magnifyingGlass),
      ),
      hitText: "Search",
      labelText: "Search",
      textEditingController: searchProductController.searchProductController,
    );
  }

  Widget _buildCarousel() {
    return CarouselSlider(
      options: CarouselOptions(
        height: 150.0,
        enlargeCenterPage: true,
        enableInfiniteScroll: true,
        viewportFraction: 1,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 5),
        onPageChanged: (index, reason) {
          homeController.currentIndex.value = index;
        },
      ),
      items:
          (homeController.sliderModel.value?.data ?? []).map((e) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: loadNetworkImage(e),
            );
          }).toList(),
    );
  }

  Widget _buildDotsIndicator() {
    final data = homeController.sliderModel.value?.data ?? [];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(data.length, (index) {
        bool isSelected = index == homeController.currentIndex.value;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          width: isSelected ? 20.0 : 8.0,
          height: 8.0,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryColor : Colors.grey,
            borderRadius: BorderRadius.circular(8.0),
          ),
        );
      }),
    );
  }

  Widget _buildQuickLinks() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _linkTile("Brands", () => Get.to(() => BrandScreen())),
        _linkTile("Shops", () => Get.to(() => ShopPage())),
        _linkTile("Groceries", () => Get.to(() => GroceryMainScreen())),
        // _linkTile("Groceries", () => Get.to(() => GroceryShopScreen())),
        // _linkTile("Festivals", () => Get.to(() => FestivalScreen())),
      ],
    );
  }

  Widget _buildCategoriesSection() {
    if (homeController.categoryModel.value?.categories == null ||
        homeController.categoryModel.value!.categories!.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _header(
          title: "Categories",
          onClick: () => Get.to(() => CategoryScreen()),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount:
                homeController.categoryModel.value?.categories?.length ?? 0,
            itemBuilder: (context, index) {
              final category =
                  homeController.categoryModel.value?.categories?[index];
              return GestureDetector(
                onTap: () {
                  Get.to(
                    () => CategoryProductScreen(
                      categoryID: category?.id ?? 0,
                      name: category?.catName ?? "",
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 5),
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.whiteColor,
                  ),
                  child: _circleItem(
                    title: category?.catName ?? "",
                    imageUrl: "$imageBaseUrl${category?.photo}",
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureProducts() {
    if (homeController.featureProductModel.value?.data == null ||
        homeController.featureProductModel.value!.data!.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _header(
          title: "Featured",
          onClick: () {
            Get.to(() => FeaturedProductScreen());
          },
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount:
                homeController.featureProductModel.value?.data?.length ?? 0,
            itemBuilder: (context, index) {
              final product =
                  homeController.featureProductModel.value?.data?[index];
              return GestureDetector(
                onTap: () {
                  Get.to(
                    () => ProductDetailScreen(
                      productID: product?.id ?? 0,
                      imageUrl: product?.photo ?? "",
                      name: product?.name ?? "",
                      price: product?.pprice?.toDouble() ?? 0,
                      newPrice: product?.cprice?.toDouble() ?? 0,
                      description: product?.description ?? "",
                      isFavorite: product?.isFavorite ?? false,
                      deal: product?.dealOfTheDay ?? "0",
                    ),
                  );
                },
                child: _productCard(
                  name: product?.name ?? '',
                  imageUrl: product?.photo ?? '',
                  price: product?.cprice?.toDouble() ?? 0,
                  oldPrice: product?.pprice?.toDouble() ?? 0,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHotProducts() {
    if (homeController.featureProductModel.value?.data == null ||
        homeController.featureProductModel.value!.data!.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _header(
          title: "Hot Sale",
          onClick: () {
            Get.to(() => HotSaleScreen());
          },
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: homeController.hotProductModel.value?.data?.length ?? 0,
            itemBuilder: (context, index) {
              final product =
                  homeController.hotProductModel.value?.data?[index];
              return GestureDetector(
                onTap: () {
                  Get.to(
                    () => ProductDetailScreen(
                      productID: product?.id ?? 0,
                      imageUrl: product?.photo ?? "",
                      name: product?.name ?? "",
                      price: product?.pprice?.toDouble() ?? 0,
                      newPrice: product?.cprice?.toDouble() ?? 0,
                      description: product?.description ?? "",
                      isFavorite: product?.isFavorite ?? false,
                      deal: product?.dealOfTheDay ?? "0",
                    ),
                  );
                },
                child: _productCard(
                  name: product?.name ?? '',
                  imageUrl: product?.photo ?? '',
                  price: product?.cprice?.toDouble() ?? 0,
                  oldPrice: product?.pprice?.toDouble() ?? 0,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDealProducts() {
    if (homeController.dealProductModel.value?.data == null ||
        homeController.dealProductModel.value!.data!.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _header(
          title: "Deal of the Day",
          onClick: () {
            Get.to(() => DealOfDayScreen());
          },
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: homeController.dealProductModel.value?.data?.length ?? 0,
            itemBuilder: (context, index) {
              final product =
                  homeController.dealProductModel.value?.data?[index];
              return GestureDetector(
                onTap: () {
                  Get.to(
                    () => ProductDetailScreen(
                      productID: product?.id ?? 0,
                      imageUrl: product?.photo ?? "",
                      name: product?.name ?? "",
                      price: product?.pprice?.toDouble() ?? 0,
                      newPrice: product?.cprice?.toDouble() ?? 0,
                      description: product?.description ?? "",
                      isFavorite: product?.isFavorite ?? false,
                      deal: product?.dealOfTheDay ?? "0",
                    ),
                  );
                },
                child: _productCard(
                  name: product?.name ?? '',
                  imageUrl: product?.photo ?? '',
                  price: product?.cprice?.toDouble() ?? 0,
                  oldPrice: product?.pprice?.toDouble() ?? 0,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBrandsSection() {
    if (homeController.brandModel.value?.brands == null ||
        homeController.brandModel.value!.brands!.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _header(title: "Brands", onClick: () => Get.to(() => BrandScreen())),
        const SizedBox(height: 15),
        SizedBox(
          height: 135,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: homeController.brandModel.value?.brands?.length ?? 0,
            itemBuilder: (context, index) {
              final brand = homeController.brandModel.value?.brands?[index];
              return GestureDetector(
                onTap: () {
                  Get.to(() => BrandProductsScreen(brandId: brand?.id ?? 0));
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 5),
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.whiteColor,
                  ),
                  child: _circleItem(
                    title: brand?.name ?? "",
                    imageUrl: brand?.photo ?? "",
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCommonSection() {
    if (homeController.groceriesModel.value?.data == null ||
        homeController.groceriesModel.value!.data!.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _header(
          title: "Groceries",
          onClick: () => Get.to(() => GroceryShopScreen()),
        ),
        const SizedBox(height: 15),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: homeController.groceriesModel.value?.data?.length ?? 0,
            itemBuilder: (context, index) {
              final grocery = homeController.groceriesModel.value?.data?[index];
              return GestureDetector(
                onTap: () {
                  Get.to(() => ShopDetailScreen(shopID: grocery?.id ?? 0));
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 5),
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.whiteColor,
                  ),
                  child: _saleProductTile(
                    imageUrl: "$imageBaseUrl${grocery?.logo}",
                    title: grocery?.shopName ?? "",
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // --- REUSABLE SMALLER COMPONENTS --- //

  Widget _linkTile(String title, Function() onClick) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        decoration: BoxDecoration(
          color: AppColors.blackColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          title,
          style: GoogleFonts.montserrat(
            fontSize: 17,
            color: AppColors.themeWhiteColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _header({required String title, required Function() onClick}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.montserrat(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryColor,
          ),
        ),
        GestureDetector(
          onTap: onClick,
          child: Text(
            "See All",
            style: GoogleFonts.montserrat(
              fontSize: 16,
              color: AppColors.hintColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _circleItem({required String title, required String imageUrl}) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.whiteColor,
            radius: 30,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: loadNetworkImage(height: 80, fit: BoxFit.cover, imageUrl),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: 100,
            height: 50,
            child: Text(
              title,
              style: GoogleFonts.montserrat(fontSize: 14),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _productCard({
    required String name,
    required String imageUrl,
    required double price,
    required double oldPrice,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.whiteColor,
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: loadNetworkImage(
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                "$imageBaseUrl$imageUrl",
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                name,
                style: GoogleFonts.montserrat(fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    currencyFormatAmount(price),
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    currencyFormatAmount(oldPrice),
                    style: GoogleFonts.montserrat(
                      fontSize: 13,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _saleProductTile({required String imageUrl, required String title}) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: loadNetworkImage(
              height: 120,
              width: 120,
              fit: BoxFit.cover,
              imageUrl,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: 100,
            height: 50,
            child: Text(
              title,
              style: GoogleFonts.montserrat(fontSize: 14),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}
