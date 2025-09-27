import 'package:flutter/material.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/state_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';
import 'package:planetbrand/components/common_button.dart';
import 'package:planetbrand/components/common_text_filed.dart';
import 'package:planetbrand/components/simple_app_bar.dart';
import 'package:planetbrand/pages/account/controller/account_controller.dart';
import 'package:planetbrand/utils/app_helpers.dart';

class ChangePasswordScreen extends StatelessWidget {
  ChangePasswordScreen({super.key});

  final AccountController accountController = Get.put(AccountController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Change Password",
                style: GoogleFonts.montserrat(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 20),
              Obx(() {
                return CommonTextField(
                  obscuringText: accountController.showPassword.value,
                  prefixIcons: const HeroIcon(HeroIcons.lockClosed),
                  suffixIcons: GestureDetector(
                    onTap: () {
                      accountController.showPassword.value =
                          !accountController.showPassword.value;
                    },
                    child: HeroIcon(
                      accountController.showPassword.value
                          ? HeroIcons.eyeSlash
                          : HeroIcons.eye,
                    ),
                  ),
                  hitText: "Password",
                  labelText: "Password",
                  textEditingController:
                      accountController.oldPasswordController,
                );
              }),
              const SizedBox(height: 10),
              Obx(() {
                return CommonTextField(
                  obscuringText: accountController.showNewPassword.value,
                  prefixIcons: const HeroIcon(HeroIcons.lockClosed),
                  suffixIcons: GestureDetector(
                    onTap: () {
                      accountController.showNewPassword.value =
                          !accountController.showNewPassword.value;
                    },
                    child: HeroIcon(
                      accountController.showNewPassword.value
                          ? HeroIcons.eyeSlash
                          : HeroIcons.eye,
                    ),
                  ),
                  hitText: "New Password",
                  labelText: "New Password",
                  textEditingController:
                      accountController.newPasswordController,
                );
              }),
              const SizedBox(height: 10),
              Obx(() {
                return CommonTextField(
                  obscuringText: accountController.showConfPassword.value,
                  prefixIcons: const HeroIcon(HeroIcons.lockClosed),
                  suffixIcons: GestureDetector(
                    onTap: () {
                      accountController.showConfPassword.value =
                          !accountController.showConfPassword.value;
                    },
                    child: HeroIcon(
                      accountController.showConfPassword.value
                          ? HeroIcons.eyeSlash
                          : HeroIcons.eye,
                    ),
                  ),
                  hitText: "Confirm Password",
                  labelText: "Confirm Password",
                  textEditingController:
                      accountController.confirmPasswordController,
                );
              }),
              const SizedBox(height: 30),
              Obx(() {
                return accountController.loader.value
                    ? getLoading()
                    : CommonButton(
                      titleName: "Save",
                      onPressed: () {
                        accountController.changePassword();
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
