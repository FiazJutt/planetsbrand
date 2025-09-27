import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:planetbrand/components/common_button.dart';
import 'package:planetbrand/components/common_searchable_drop_down.dart';
import 'package:planetbrand/components/common_text_filed.dart';
import 'package:planetbrand/pages/account/controller/account_controller.dart';
import 'package:planetbrand/utils/app_colors.dart';
import 'package:planetbrand/utils/app_helpers.dart';

class AddNewAddressScreen extends StatefulWidget {
  const AddNewAddressScreen({super.key});

  @override
  State<AddNewAddressScreen> createState() => _AddNewAddressScreenState();
}

class _AddNewAddressScreenState extends State<AddNewAddressScreen> {
  final AccountController accountController = Get.put(AccountController());
  @override
  void initState() {
    accountController.clearFields();
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
          "Add Address",
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
                return accountController.saveLoader.value
                    ? getLoading()
                    : CommonButton(
                      titleName: "Save",
                      onPressed: () {
                        accountController.saveAddress();
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
