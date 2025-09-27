import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:planetbrand/components/common_button.dart';
import 'package:planetbrand/pages/landing/landing_screen.dart';
import 'package:planetbrand/utils/app_colors.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.wifi_off, size: 150, color: AppColors.red),
              const SizedBox(height: 20),
              Text(
                "No Internet",
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              CommonButton(
                titleName: "Refresh",
                onPressed: () {
                  Get.offAll(() => LandingScreen());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
