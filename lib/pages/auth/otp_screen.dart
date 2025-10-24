import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';
import 'package:planetbrand/components/common_button.dart';
import 'package:planetbrand/components/common_pin_text_box.dart';
import 'package:planetbrand/components/simple_app_bar.dart';
import 'package:planetbrand/pages/auth/controller/auth_controller.dart';
import 'package:planetbrand/pages/auth/login_screen.dart';
import 'package:planetbrand/utils/app_colors.dart';
import 'package:planetbrand/utils/app_helpers.dart';

class OtpScreen extends StatelessWidget {
  OtpScreen({super.key});

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
                "Verification Code",
                style: GoogleFonts.montserrat(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 10),
              Text(
                "Please enter the 6-digit code sent to your email",
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  color: AppColors.hintColor,
                ),
              ),
              const SizedBox(height: 30),
              CommonPinTextBox(
                prefixIcons: HeroIcon(HeroIcons.lockClosed),
                hitText: "Enter OTP",
                labelText: "OTP",
                textEditingController: authController.otpController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 30),
              CommonButton(
                titleName: "VERIFY",
                onPressed: () {
                  authController.verifyOtpAndSignUp();
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn't receive the code?",
                    style: GoogleFonts.montserrat(fontSize: 15),
                  ),
                  const SizedBox(width: 5),
                  Obx(() {
                    return authController.canResendOtp.value
                        ? GestureDetector(
                          onTap: () {
                            authController.resendOtpSignUp();
                          },
                          child: Text(
                            "RESEND",
                            style: GoogleFonts.montserrat(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        )
                        : Text(
                          "RESEND (${authController.countdown.value}s)",
                          style: GoogleFonts.montserrat(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: AppColors.hintColor,
                          ),
                        );
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}