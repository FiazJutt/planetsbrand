import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';
import 'package:planetbrand/components/common_button.dart';
import 'package:planetbrand/components/common_text_filed.dart';
import 'package:planetbrand/pages/auth/controller/auth_controller.dart';
import 'package:planetbrand/pages/auth/login_screen.dart';

import 'package:planetbrand/pages/other_page/webview_screen.dart';
import 'package:planetbrand/utils/app_assets.dart';
import 'package:planetbrand/utils/app_colors.dart';
import 'package:planetbrand/utils/app_helpers.dart';
import 'package:planetbrand/utils/config.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 100),
              Text(
                "Create Your Account",
                style: GoogleFonts.montserrat(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              CommonTextField(
                prefixIcons: HeroIcon(HeroIcons.user),
                hitText: "John Doe",
                labelText: "John Doe",
                textEditingController: authController.nameController,
              ),
              const SizedBox(height: 10),
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
                      authController.showPassword.value
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
              Obx(() {
                return CommonTextField(
                  obscuringText: authController.showConfPassword.value,
                  prefixIcons: const HeroIcon(HeroIcons.lockClosed),
                  suffixIcons: GestureDetector(
                    onTap: () {
                      authController.showConfPassword.value =
                          !authController.showConfPassword.value;
                    },
                    child: HeroIcon(
                      authController.showConfPassword.value
                          ? HeroIcons.eyeSlash
                          : HeroIcons.eye,
                    ),
                  ),
                  hitText: "Confirm Password",
                  labelText: "Confirm Password",
                  textEditingController: authController.confPasswordController,
                );
              }),
              const SizedBox(height: 10),
              Obx(() {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: authController.checkTermsCondition.value,
                      onChanged: (value) {
                        authController.checkTermsCondition.value = value!;
                      },
                    ),
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          text: 'I agree to the ',
                          style: GoogleFonts.montserrat(fontSize: 14),
                          children: [
                            TextSpan(
                              text: 'Terms & Conditions',
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                                decoration: TextDecoration.underline,
                                color: AppColors.linkColor,
                              ),
                              recognizer:
                                  TapGestureRecognizer()
                                    ..onTap = () {
                                      Get.to(
                                        () => WebViewScreen(
                                          url: termsAndConditionUrl,
                                        ),
                                      );
                                    },
                            ),
                            TextSpan(
                              text: ' and ',
                              style: GoogleFonts.montserrat(fontSize: 14),
                            ),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                                decoration: TextDecoration.underline,
                                color: AppColors.linkColor,
                              ),
                              recognizer:
                                  TapGestureRecognizer()
                                    ..onTap = () {
                                      Get.to(
                                        () => WebViewScreen(
                                          url: privacyPolicyUrl,
                                        ),
                                      );
                                    },
                            ),
                            TextSpan(
                              text: '.',
                              style: GoogleFonts.montserrat(fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }),
              const SizedBox(height: 30),
              Obx(() {
                return authController.loader.value
                    ? getLoading()
                    : CommonButton(
                      titleName: "SIGN UP",
                      onPressed: () {
                        authController.signUp();
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
                    color: AppColors.borderColor,
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
                    color: AppColors.borderColor,
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  socialLoginButton(
                    image: AppAssets.facebookLogo,
                    onClick: () {},
                  ),
                  const SizedBox(width: 15),
                  socialLoginButton(
                    image: AppAssets.googleLogo,
                    onClick: () {},
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: GoogleFonts.montserrat(fontSize: 15),
                  ),
                  const SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => LoginScreen());
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
