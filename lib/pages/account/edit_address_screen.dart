import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:planetbrand/components/common_button.dart';
import 'package:planetbrand/components/common_searchable_drop_down.dart';
import 'package:planetbrand/components/common_text_filed.dart';
import 'package:planetbrand/pages/account/controller/account_controller.dart';
import 'package:planetbrand/utils/app_colors.dart';
import 'package:planetbrand/utils/app_helpers.dart';

class EditAddressScreen extends StatefulWidget {
  final int id;
  final String addressType;
  final String countryName;
  final String provinceName;
  final String cityName;
  final String address;
  final String zip;
  final bool isDefault;
  const EditAddressScreen({
    super.key,
    required this.id,
    required this.addressType,
    required this.countryName,
    required this.provinceName,
    required this.cityName,
    required this.address,
    required this.zip,
    required this.isDefault,
  });

  @override
  State<EditAddressScreen> createState() => _EditAddressScreenState();
}

class _EditAddressScreenState extends State<EditAddressScreen> {
  final AccountController accountController = Get.put(AccountController());
  @override
  void initState() {
    accountController.selectAddressType.value = widget.addressType;
    accountController.countryController.text = widget.countryName;
    accountController.provinceController.text = widget.provinceName;
    accountController.addressCityController.text = widget.cityName;
    accountController.addressNameController.text = widget.address;
    accountController.zipController.text = widget.zip;
    accountController.isDefault.value = widget.isDefault;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,

        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        title: Text(
          "Edit Address",
          style: GoogleFonts.montserrat(
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
          child: Column(
            spacing: 10,
            children: [
              CommonSearchableDropDown(
                itemList: ['Home', 'Office', 'Others'],
                onChangeValue: (value) {
                  accountController.selectAddressType.value = value.toString();
                },
                hintText: "Address Type",
                hintTextOfField: "Search",
                selectedItem: accountController.selectAddressType.value,
              ),
              CommonTextField(
                hitText: "Country",
                labelText: "Country",
                textEditingController: accountController.countryController,
              ),
              CommonTextField(
                hitText: "Provinces",
                labelText: "Provinces",
                textEditingController: accountController.provinceController,
              ),
              CommonTextField(
                hitText: "City",
                labelText: "City",
                textEditingController: accountController.addressCityController,
              ),
              CommonTextField(
                hitText: "Address",
                labelText: "Address",
                textEditingController: accountController.addressNameController,
              ),
              CommonTextField(
                hitText: "Zip",
                labelText: "Zip",
                textEditingController: accountController.zipController,
              ),
              Obx(() {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: accountController.isDefault.value,
                      onChanged: (value) {
                        accountController.isDefault.value = value!;
                      },
                    ),
                    Text(
                      "Default",
                      style: GoogleFonts.montserrat(fontSize: 15),
                    ),
                  ],
                );
              }),
              const SizedBox(height: 20),
              Obx(() {
                return accountController.updateLoader.value
                    ? getLoading()
                    : CommonButton(
                      titleName: "Update",
                      onPressed: () {
                        accountController.updateAddress(id: widget.id);
                      },
                    );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
