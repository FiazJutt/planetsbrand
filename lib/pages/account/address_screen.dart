import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';
import 'package:planetbrand/components/common_not_found_tile.dart';
import 'package:planetbrand/components/common_shimmer_effect.dart';
import 'package:planetbrand/pages/account/add_new_address_screen.dart';
import 'package:planetbrand/pages/account/controller/account_controller.dart';
import 'package:planetbrand/pages/account/edit_address_screen.dart';
import 'package:planetbrand/utils/app_colors.dart';

class AddressScreen extends StatelessWidget {
  AddressScreen({super.key});

  final AccountController accountController = Get.put(AccountController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        title: Text(
          "My Addresses",
          style: GoogleFonts.montserrat(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: () {
                Get.to(() => AddNewAddressScreen());
              },
              child: const HeroIcon(HeroIcons.plus),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (accountController.addressLoader.value) {
          return CommonShimmerEffect();
        }

        final addresses = accountController.addressResponse.value?.addresses;

        if (addresses == null || addresses.isEmpty) {
          return CommonNotFoundTile();
        }

        return RefreshIndicator(
          onRefresh: () async {
            await accountController.getAddress();
          },
          child: ListView.builder(
            itemCount: addresses.length,
            padding: const EdgeInsets.symmetric(vertical: 10),
            itemBuilder: (context, index) {
              final address = addresses[index];

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (address.isDefault)
                      Align(
                        alignment: Alignment.topRight,
                        child: Chip(
                          label: Text(
                            "Default",
                            style: GoogleFonts.montserrat(
                              fontSize: 13,
                              color: AppColors.whiteColor,
                            ),
                          ),
                          backgroundColor: AppColors.primaryColor,
                        ),
                      ),
                    addressRow(
                      Icons.home,
                      title: "Type",
                      value: address.type ?? "",
                    ),
                    addressRow(
                      Icons.flag,
                      title: "Country",
                      value: address.country ?? "",
                    ),
                    addressRow(
                      Icons.map,
                      title: "Province",
                      value: address.province ?? "",
                    ),
                    addressRow(
                      Icons.location_city,
                      title: "City",
                      value: address.city ?? "",
                    ),
                    addressRow(
                      Icons.place,
                      title: "Address",
                      value: address.address ?? "",
                    ),
                    addressRow(
                      Icons.markunread_mailbox,
                      title: "Zip Code",
                      value: address.zip ?? "-",
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const HeroIcon(
                            HeroIcons.trash,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            accountController.deleteAddress(
                              id: address.id ?? 0,
                            );
                          },
                        ),
                        IconButton(
                          icon: const HeroIcon(
                            HeroIcons.pencil,
                            color: Colors.blue,
                          ),
                          onPressed: () {
                            Get.to(
                              () => EditAddressScreen(
                                id: address.id ?? 0,
                                addressType: address.type ?? "",
                                countryName: address.country ?? "",
                                provinceName: address.province ?? "",
                                cityName: address.city ?? "",
                                address: address.address ?? "",
                                zip: address.zip ?? "",
                                isDefault: address.isDefault,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }

  Widget addressRow(
    IconData icon, {
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primaryColor),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              "$title:",
              style: GoogleFonts.montserrat(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: GoogleFonts.montserrat(
                fontSize: 15,
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
