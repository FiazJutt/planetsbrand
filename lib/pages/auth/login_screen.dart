import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';
import 'package:planetbrand/components/common_button.dart';
import 'package:planetbrand/components/common_text_filed.dart';
import 'package:planetbrand/components/simple_app_bar.dart';
import 'package:planetbrand/pages/auth/controller/auth_controller.dart';
import 'package:planetbrand/pages/auth/forgot_passwrd_screen.dart';
import 'package:planetbrand/pages/auth/sign_up_screen.dart';
import 'package:planetbrand/utils/app_assets.dart';
import 'package:planetbrand/utils/app_colors.dart';
import 'package:planetbrand/utils/app_helpers.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final AuthController authController = Get.put(AuthController());

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
                "Hey, Welcome Back",
                style: GoogleFonts.montserrat(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 30),
              CommonTextField(
                prefixIcons: HeroIcon(HeroIcons.envelope),
                hitText: "exampl@gmail.com",
                labelText: "exampl@gmail.com",
                textEditingController: authController.emailController,
              ),
              const SizedBox(height: 10),
              Obx(() {
                return CommonTextField(
                  obscuringText: authController.showPassword.value,
                  prefixIcons: const HeroIcon(HeroIcons.lockClosed),
                  suffixIcons: GestureDetector(
                    onTap: () {
                      authController.showPassword.value =
                          !authController.showPassword.value;
                    },
                    child: HeroIcon(
                      authController.showPassword.value == true
                          ? HeroIcons.eyeSlash
                          : HeroIcons.eye,
                    ),
                  ),
                  hitText: "Password",
                  labelText: "Password",
                  textEditingController: authController.passwordController,
                );
              }),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  Get.to(() => ForgotPasswrdScreen());
                },
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    "Forgot Password",
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Obx(() {
                return authController.loader.value
                    ? getLoading()
                    : CommonButton(
                      titleName: "LOGIN",
                      onPressed: () {
                        authController.signin();
                      },
                    );
              }),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 2,
                    decoration: BoxDecoration(color: AppColors.borderColor),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "OR",
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 100,
                    height: 2,
                    decoration: BoxDecoration(color: AppColors.borderColor),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  socialLoginButton(
                    image: AppAssets.facebookLogo,
                    onClick: () {
                      authController.facebookLogin();
                    },
                  ),
                  const SizedBox(width: 15),
                  socialLoginButton(
                    image: AppAssets.googleLogo,
                    onClick: () {
                      authController.googleLogin();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: GoogleFonts.montserrat(fontSize: 15),
                  ),
                  const SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => SignUpScreen());
                    },
                    child: Text(
                      "SIGN UP",
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

  Widget socialLoginButton({
    required String image,
    required Function() onClick,
  }) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: AppColors.whiteColor,
          boxShadow: [
            BoxShadow(
              color: AppColors.lightGrayColor,
              spreadRadius: 2,
              blurRadius: 2,
              offset: Offset(1, 1),
            ),
          ],
        ),
        child: Image.asset(image, width: 50, height: 50),
      ),
    );
  }
}
