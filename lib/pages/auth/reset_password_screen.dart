import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';
import 'package:planetbrand/components/common_button.dart';
import 'package:planetbrand/components/common_text_filed.dart';
import 'package:planetbrand/components/simple_app_bar.dart';
import 'package:planetbrand/pages/auth/controller/auth_controller.dart';
import 'package:planetbrand/pages/auth/login_screen.dart';
import 'package:planetbrand/utils/app_colors.dart';
import 'package:planetbrand/utils/app_helpers.dart';

class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({super.key});

  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: [
              Text(
                "Reset Password",
                style: GoogleFonts.montserrat(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 10),
              Text(
                "Please enter your new password",
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  color: AppColors.hintColor,
                ),
              ),
              const SizedBox(height: 30),
              Obx(
                () => CommonTextField(
                  prefixIcons: HeroIcon(HeroIcons.lockClosed),
                  suffixIcons: GestureDetector(
                    onTap: () {
                      authController.showPassword.value =
                          !authController.showPassword.value;
                    },
                    child: Icon(
                      authController.showPassword.value
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: AppColors.hintColor,
                    ),
                  ),
                  hitText: "Password",
                  labelText: "Password",
                  textEditingController: authController.passwordController,
                  obscuringText: authController.showPassword.value,
                ),
              ),
              const SizedBox(height: 20),
              Obx(
                () => CommonTextField(
                  prefixIcons: HeroIcon(HeroIcons.lockClosed),
                  suffixIcons: GestureDetector(
                    onTap: () {
                      authController.showConfPassword.value =
                          !authController.showConfPassword.value;
                    },
                    child: Icon(
                      authController.showConfPassword.value
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: AppColors.hintColor,
                    ),
                  ),
                  hitText: "Confirm Password",
                  labelText: "Confirm Password",
                  textEditingController: authController.confPasswordController,
                  obscuringText: authController.showConfPassword.value,
                ),
              ),
              const SizedBox(height: 30),
              Obx(() {
                return authController.loader.value
                    ? getLoading()
                    : CommonButton(
                      titleName: "RESET PASSWORD",
                      onPressed: () {
                        ///TODO Temp
                        Get.offAll(() => LoginScreen());
                        // authController.resetPassword();
                      },
                    );
              }),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Remember your password?",
                    style: GoogleFonts.montserrat(fontSize: 15),
                  ),
                  const SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {
                      Get.offAll(() => LoginScreen());
                    },
                    child: Text(
                      "LOGIN",
                      style: GoogleFonts.montserrat(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
