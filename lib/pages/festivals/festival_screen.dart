import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';
import 'package:planetbrand/components/common_shimmer_effect.dart';
import 'package:planetbrand/pages/festivals/controller/festival_controller.dart';
import 'package:planetbrand/pages/product_details/product_detail_screen.dart';
import 'package:planetbrand/utils/app_colors.dart';
import 'package:planetbrand/utils/app_helpers.dart';

class FestivalScreen extends StatelessWidget {
  FestivalScreen({super.key});

  final FestivalController festivalController = Get.put(FestivalController());
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 100 &&
          !festivalController.isFetchingMore.value &&
          festivalController.currentPage.value <
              festivalController.lastPage.value) {
        festivalController.loadMore();
      }
    });

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,

        backgroundColor: AppColors.whiteColor,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Text(
          "Festivals",
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
        return festivalController.loader.value
            ? CommonShimmerEffect()
            : festivalController.festival.isEmpty
            ? const Center(child: Text("No Festival Found"))
            : RefreshIndicator(
              onRefresh: () async {
                festivalController.currentPage.value = 1;
                await festivalController.fetchFestivals();
              },
              child: Column(
                children: [
                  Expanded(
                    child: GridView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.all(10),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            mainAxisExtent: 310,
                          ),
                      itemCount: festivalController.festival.length,
                      itemBuilder: (context, index) {
                        final festival = festivalController.festival[index];
                        return GestureDetector(
                          onTap: () {
                            Get.to(
                              () => ProductDetailScreen(
                                productID: festival.id ?? 0,
                                imageUrl: festival.photo ?? "",
                                name: festival.name ?? "",
                                price: festival.pprice?.toDouble() ?? 0,
                                newPrice: festival.cprice?.toDouble() ?? 0,
                                description: festival.description ?? "",
                                isFavorite: festival.isFavorite ?? false,
                                deal: "0",
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
                                  offset: Offset(0, 1),
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
                                    festival.photo ?? '',
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
                                      festival.name ?? '',
                                      maxLines: 2,
                                      style: GoogleFonts.montserrat(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  height: 20,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(5, (index) {
                                      if (index < (festival.rating ?? 0)) {
                                        return const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 16,
                                        );
                                      } else {
                                        return const HeroIcon(
                                          HeroIcons.star,
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
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 5,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          currencyFormatAmount(
                                            festival.cprice?.toDouble() ?? 0,
                                          ),
                                          style: GoogleFonts.montserrat(
                                            fontSize: 13,
                                            color: AppColors.primaryColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          currencyFormatAmount(
                                            festival.pprice?.toDouble() ?? 0,
                                          ),
                                          style: GoogleFonts.montserrat(
                                            fontSize: 11,
                                            decoration:
                                                TextDecoration.lineThrough,
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
                      },
                    ),
                  ),
                  Obx(
                    () =>
                        festivalController.isFetchingMore.value
                            ? Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: getSimpleLoading(
                                color: AppColors.primaryColor,
                              ),
                            )
                            : festivalController.currentPage.value >=
                                festivalController.lastPage.value
                            ? const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Text("No more Festivals"),
                            )
                            : const SizedBox.shrink(),
                  ),
                ],
              ),
            );
      }),
    );
  }
}
