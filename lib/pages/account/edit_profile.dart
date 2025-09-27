import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';
import 'package:planetbrand/components/common_button.dart';
import 'package:planetbrand/components/common_description_text_filed.dart';
import 'package:planetbrand/components/common_text_filed.dart';
import 'package:planetbrand/pages/account/controller/account_controller.dart';
import 'package:planetbrand/utils/app_colors.dart';
import 'package:planetbrand/utils/app_helpers.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  AccountController accountController = Get.put(AccountController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,

        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        title: Text(
          "Profile",
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
            children: [
              CommonTextField(
                hitText: "Name",
                labelText: "Name",
                prefixIcons: HeroIcon(HeroIcons.user),
                textEditingController: accountController.nameController,
              ),
              const SizedBox(height: 10),
              CommonTextField(
                hitText: "Email",
                prefixIcons: HeroIcon(HeroIcons.envelope),
                labelText: "Email",
                textEditingController: accountController.emailController,
              ),

              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  genderButton("Male"),
                  genderButton("Female"),
                  genderButton("Others"),
                ],
              ),

              const SizedBox(height: 30),
              CommonTextField(
                hitText: "Phone",
                prefixIcons: HeroIcon(HeroIcons.phone),
                keyboardType: TextInputType.phone,
                labelText: "Phone",
                textEditingController: accountController.phoneController,
              ),
              const SizedBox(height: 10),
              CommonTextField(
                hitText: "City",
                prefixIcons: HeroIcon(HeroIcons.buildingLibrary),
                labelText: "City",
                textEditingController: accountController.cityController,
              ),
              const SizedBox(height: 10),
              CommonDescriptionTextFiled(
                maxLines: 4,
                prefixIcons: HeroIcon(HeroIcons.mapPin),
                hitText: "Address",
                labelText: "Address",
                textEditingController: accountController.addressController,
              ),
              const SizedBox(height: 30),
              Obx(() {
                return accountController.loader.value
                    ? getLoading()
                    : CommonButton(
                      titleName: "Update",
                      onPressed: () {
                        accountController.updateProfile();
                      },
                    );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget genderButton(String gender) {
    bool isSelected = accountController.gender.value == gender;

    return InkWell(
      onTap: () {
        setState(() {
          accountController.gender.value = gender;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor : AppColors.lightGrayColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          gender,
          style: GoogleFonts.montserrat(
            color: isSelected ? AppColors.whiteColor : AppColors.blackColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
