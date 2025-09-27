import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:get/utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:planetbrand/pages/splash/welcome_screen.dart';
import 'package:planetbrand/utils/app_assets.dart';
import 'package:planetbrand/utils/app_colors.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  OnBoardingPageState createState() => OnBoardingPageState();
}

class OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Get.off(() => WelcomeScreen());
  }

  Widget _buildImage(String assetName, [double width = 300]) {
    return Image.asset(assetName, width: width);
  }

  @override
  Widget build(BuildContext context) {
    const pageDecoration = PageDecoration(
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
      allowImplicitScrolling: false,
      globalFooter: SizedBox(height: 40),

      pages: [
        PageViewModel(
          title: "Delivery on the Way ",
          body: "Get Your Order by Speed Delivery",
          image: _buildImage(AppAssets.slider1),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Delivery Arrived",
          body: "Order is arrived at your Place",
          image: _buildImage(AppAssets.slider1),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context),
      showSkipButton: true,
      skipOrBackFlex: 0,
      nextFlex: 0,
      showBackButton: true,
      back: Icon(Icons.arrow_back, color: AppColors.blackColor),
      skip: Text(
        'Skip',
        style: GoogleFonts.montserrat(
          fontWeight: FontWeight.w600,
          color: AppColors.blackColor,
        ),
      ),
      next: const Icon(Icons.arrow_forward, color: AppColors.blackColor),
      done: Text(
        'Done',
        style: GoogleFonts.montserrat(
          fontWeight: FontWeight.w600,
          color: AppColors.blackColor,
        ),
      ),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: AppColors.blackColor,
        activeSize: Size(30.0, 10.0),
        activeColor: AppColors.blackColor,
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: ShapeDecoration(
        color: AppColors.whiteColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}
