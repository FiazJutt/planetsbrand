import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';
import 'package:planetbrand/components/common_button.dart';
import 'package:planetbrand/components/common_text_filed.dart';
import 'package:planetbrand/components/simple_app_bar.dart';
import 'package:planetbrand/pages/auth/controller/auth_controller.dart';
import 'package:planetbrand/pages/auth/login_screen.dart';
import 'package:planetbrand/pages/auth/otp_screen.dart';
import 'package:planetbrand/utils/app_colors.dart';
import 'package:planetbrand/utils/app_helpers.dart';

class ForgotPasswrdScreen extends StatelessWidget {
  ForgotPasswrdScreen({super.key});

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
                "Change Password",
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
              const SizedBox(height: 30),
              Obx(() {
                return authController.loader.value
                    ? getLoading()
                    : CommonButton(
                      titleName: "CHANGE",
                      onPressed: () {
                        /// Temp
                        authController.startOtpCountdown();
                        Get.off(() => OtpScreen());
                        // authController.forgotPassword();
                      },
                    );
              }),
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
                      Get.off(() => LoginScreen());
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
