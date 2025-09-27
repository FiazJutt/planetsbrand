import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:planetbrand/components/common_button.dart';
import 'package:planetbrand/components/common_outline_button.dart';
import 'package:planetbrand/pages/auth/login_screen.dart';
import 'package:planetbrand/pages/auth/sign_up_screen.dart';
import 'package:planetbrand/utils/app_assets.dart';
import 'package:planetbrand/utils/app_colors.dart';
import 'package:planetbrand/utils/app_constants.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Welcome to ${AppConstants.appName}",
                style: GoogleFonts.montserrat(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              CircleAvatar(
                radius: 120,

                child: CircleAvatar(
                  backgroundColor: AppColors.primaryColor,
                  radius: 100,
                  child: Image.asset(AppAssets.logo),
                ),
              ),
              const SizedBox(height: 40),
              CommonButton(
                titleName: "LOGIN",
                onPressed: () {
                  Get.to(() => LoginScreen());
                },
              ),
              const SizedBox(height: 10),
              CommonOutlineButton(
                titleName: "SIGN UP",
                onPressed: () {
                  Get.to(() => SignUpScreen());
                },
                textColor: AppColors.primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
