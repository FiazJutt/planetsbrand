import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';
import 'package:planetbrand/components/common_not_found_tile.dart';
import 'package:planetbrand/components/common_shimmer_effect.dart';
import 'package:planetbrand/components/common_text_filed.dart';
import 'package:planetbrand/pages/product_details/search_detail_product_screen.dart';
import 'package:planetbrand/pages/search/controller/search_controller.dart';
import 'package:planetbrand/pages/shop/shop_detail_screen.dart';
import 'package:planetbrand/pages/brands/brand_product_screen.dart';
import 'package:planetbrand/utils/app_colors.dart';
import 'package:planetbrand/utils/app_helpers.dart';

class UnifiedSearchScreen extends StatelessWidget {
  UnifiedSearchScreen({super.key});

  final SearchProductController searchController = Get.put(
    SearchProductController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.whiteColor,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Text(
          "Search",
          style: GoogleFonts.montserrat(
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: HeroIcon(HeroIcons.arrowLeft, size: 20),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(12),
            child: CommonTextField(
              textEditingController: searchController.searchController,
              hitText: "Search products, shops, brands...",
              labelText: "Search",
              onChange: (value) async {
                if (value.isNotEmpty) {
                  searchController.performSearch();
                } else {
                  searchController.clearResults();
                }
              },
              suffixIcons: IconButton(
                onPressed: () => searchController.performSearch(),
                icon: HeroIcon(HeroIcons.magnifyingGlass),
              ),
            ),
          ),

          // Filter Chips
          _buildFilterChips(),

          // Results
          Expanded(child: _buildSearchResults()),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Obx(
        () =>
            ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildFilterChip("All", SearchFilter.all),
                const SizedBox(width: 8),
                _buildFilterChip("Products", SearchFilter.products),
                const SizedBox(width: 8),
                _buildFilterChip("Shops", SearchFilter.shops),
                const SizedBox(width: 8),
                _buildFilterChip("Brands", SearchFilter.brands),
                const SizedBox(width: 8),
                _buildFilterChip("Malls", SearchFilter.malls),
              ],
            ).obs(),
      ),
    );
  }

  Widget _buildFilterChip(String label, SearchFilter filter) {
    return Obx(() {
      final isSelected = searchController.selectedFilter.value == filter;
      return FilterChip(
        label: Text(
          label,
          style: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : AppColors.primaryColor,
          ),
        ),
        selected: isSelected,
        onSelected: (selected) {
          searchController.setFilter(filter);
        },
        backgroundColor: Colors.white,
        selectedColor: AppColors.primaryColor,
        side: BorderSide(color: AppColors.primaryColor),
        showCheckmark: false,
      );
    });
  }

  Widget _buildSearchResults() {
    return Obx(() {
      if (searchController.isLoading.value) {
        return CommonShimmerEffect();
      }

      if (searchController.searchController.text.isEmpty) {
        return Center(
          child: Text(
            "Start typing to search...",
            style: GoogleFonts.montserrat(fontSize: 16, color: Colors.grey),
          ),
        );
      }

      final hasResults = searchController.hasResults;
      if (!hasResults) {
        return const CommonNotFoundTile();
      }

      return RefreshIndicator(
        onRefresh: () async {
          await searchController.performSearch();
        },
        child: _buildResultsList(),
      );
    });
  }

  Widget _buildResultsList() {
    final scrollController = ScrollController();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 100 &&
          !searchController.isFetchingMore.value &&
          searchController.canLoadMore) {
        searchController.loadMore();
      }
    });

    return Obx(() {
      switch (searchController.selectedFilter.value) {
        case SearchFilter.all:
          return _buildAllResults();
        case SearchFilter.products:
          return _buildProductsGrid(scrollController);
        case SearchFilter.shops:
          return _buildShopsList(scrollController);
        case SearchFilter.brands:
          return _buildBrandsList(scrollController);
        case SearchFilter.malls:
          return _buildMallsList(scrollController);
      }
    });
  }

  Widget _buildAllResults() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Products Section
          if (searchController.products.isNotEmpty) ...[
            // _buildSectionHeader("Products", searchController.products.length),
            _buildSectionHeader("Products"),
            const SizedBox(height: 8),
            _buildProductsGrid(null, limit: 4),
            const SizedBox(height: 20),
          ],

          // Shops Section
          if (searchController.vendors.isNotEmpty) ...[
            // _buildSectionHeader("Shops", searchController.vendors.length),
            _buildSectionHeader("Shops"),
            const SizedBox(height: 8),
            _buildShopsList(null, limit: 3),
            const SizedBox(height: 20),
          ],

          // Brands Section
          if (searchController.brands.isNotEmpty) ...[
            // _buildSectionHeader("Brands", searchController.brands.length),
            _buildSectionHeader("Brands"),
            const SizedBox(height: 8),
            _buildBrandsList(null, limit: 3),
            const SizedBox(height: 20),
          ],

          // Malls Section
          if (searchController.malls.isNotEmpty) ...[
            // _buildSectionHeader("Malls", searchController.malls.length),
            _buildSectionHeader("Malls"),
            const SizedBox(height: 8),
            _buildMallsList(null, limit: 3),
          ],
        ],
      ),
    );
  }

  Widget _buildProductsGrid(ScrollController? scrollController, {int? limit}) {
    final products =
        limit != null
            ? searchController.products.take(limit).toList()
            : searchController.products;

    if (scrollController != null) {
      return Column(
        children: [
          Expanded(
            child: GridView.builder(
              controller: scrollController,
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                mainAxisExtent: 310,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                return _buildProductCard(products[index]);
              },
            ),
          ),
          _buildLoadingIndicator(),
        ],
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        mainAxisExtent: 310,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return _buildProductCard(products[index]);
      },
    );
  }

  Widget _buildShopsList(ScrollController? scrollController, {int? limit}) {
    final vendors =
        limit != null
            ? searchController.vendors.take(limit).toList()
            : searchController.vendors;

    if (scrollController != null) {
      return Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.all(12),
              itemCount: vendors.length,
              itemBuilder: (context, index) {
                return _buildVendorCard(vendors[index]);
              },
            ),
          ),
          _buildLoadingIndicator(),
        ],
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: vendors.length,
      itemBuilder: (context, index) {
        return _buildVendorCard(vendors[index]);
      },
    );
  }

  Widget _buildBrandsList(ScrollController? scrollController, {int? limit}) {
    final brands =
        limit != null
            ? searchController.brands.take(limit).toList()
            : searchController.brands;

    if (scrollController != null) {
      return Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.all(12),
              itemCount: brands.length,
              itemBuilder: (context, index) {
                return _buildBrandCard(brands[index]);
              },
            ),
          ),
          _buildLoadingIndicator(),
        ],
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: brands.length,
      itemBuilder: (context, index) {
        return _buildBrandCard(brands[index]);
      },
    );
  }

  Widget _buildMallsList(ScrollController? scrollController, {int? limit}) {
    final malls =
        limit != null
            ? searchController.malls.take(limit).toList()
            : searchController.malls;

    if (scrollController != null) {
      return Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.all(12),
              itemCount: malls.length,
              itemBuilder: (context, index) {
                return _buildMallCard(malls[index]);
              },
            ),
          ),
          _buildLoadingIndicator(),
        ],
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: malls.length,
      itemBuilder: (context, index) {
        return _buildMallCard(malls[index]);
      },
    );
  }

  // Widget _buildSectionHeader(String title, int count) {
  Widget _buildSectionHeader(String title, [int? count]) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.montserrat(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),

        /// added if condition,
        if (count != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              "$count",
              style: GoogleFonts.montserrat(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryColor,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildProductCard(dynamic product) {
    return GestureDetector(
      onTap: () {
        Get.to(
          () => SearchDetailProductScreen(
            productID: product.id ?? 0,
            imageUrl: product.photo ?? "",
            name: product.name ?? "",
            price: double.parse(product.pprice.toString()),
            newPrice: double.parse(product.cprice.toString()),
            description: product.description ?? "",
            isFavorite: product.isFavorite ?? false,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
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
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: loadNetworkImage(
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                product.photo ?? '',
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 4.0,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 35,
                child: Text(
                  product.name ?? '',
                  maxLines: 2,
                  style: GoogleFonts.montserrat(fontSize: 14),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (starIndex) {
                  if (starIndex < (product.rating ?? 0)) {
                    return const Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 16,
                    );
                  } else {
                    return const Icon(
                      Icons.star_border,
                      color: Colors.grey,
                      size: 16,
                    );
                  }
                }),
              ),
            ),
            const SizedBox(height: 5),
            SizedBox(
              width: double.infinity,
              height: 30,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      currencyFormatAmount((product.cprice ?? 0).toDouble()),
                      style: GoogleFonts.montserrat(
                        fontSize: 13,
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if ((product.pprice ?? 0) > 0)
                      Text(
                        currencyFormatAmount((product.pprice ?? 0).toDouble()),
                        style: GoogleFonts.montserrat(
                          fontSize: 11,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVendorCard(dynamic vendor) {
    return GestureDetector(
      onTap: () {
        Get.to(() => ShopDetailScreen(shopID: vendor.id ?? 0));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: AppColors.lightGrayColor,
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: loadNetworkImage(
                height: 60,
                width: 60,
                fit: BoxFit.cover,
                vendor.photo ?? '',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vendor.shopName ?? '',
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    vendor.address ?? '',
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            HeroIcon(HeroIcons.chevronRight, size: 20, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildBrandCard(dynamic brand) {
    return GestureDetector(
      onTap: () {
        Get.to(() => BrandProductsScreen(brandId: brand.id ?? 0));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: AppColors.lightGrayColor,
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: loadNetworkImage(
                height: 60,
                width: 60,
                fit: BoxFit.cover,
                brand.photo ?? '',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    brand.name ?? '',
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (brand.address != null && brand.address!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      brand.address ?? '',
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            HeroIcon(HeroIcons.chevronRight, size: 20, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildMallCard(dynamic mall) {
    return GestureDetector(
      onTap: () {
        Get.to(() => ShopDetailScreen(shopID: mall.id ?? 0));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: AppColors.lightGrayColor,
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: loadNetworkImage(
                height: 60,
                width: 60,
                fit: BoxFit.cover,
                mall.photo ?? '',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mall.name ?? '',
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (mall.address != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      mall.address ?? '',
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            HeroIcon(HeroIcons.chevronRight, size: 20, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Obx(() {
      if (searchController.isFetchingMore.value) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: getSimpleLoading(color: AppColors.primaryColor),
        );
      } else if (!searchController.canLoadMore) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Text("No more results"),
        );
      }
      return const SizedBox.shrink();
    });
  }
}
