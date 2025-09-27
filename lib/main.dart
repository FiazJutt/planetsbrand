import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planetbrand/firebase_options.dart';
import 'package:planetbrand/pages/landing/landing_screen.dart';
import 'package:planetbrand/pages/splash/onboard_screen.dart';
import 'package:planetbrand/utils/app_colors.dart';
import 'package:planetbrand/utils/app_constants.dart';
import 'package:planetbrand/utils/app_helpers.dart';
import 'package:planetbrand/utils/local_stoarge.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await LocalStorage.initStorage();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> checkLoggedIn() async {
    final token = LocalStorage.getToken();
    return token != null;
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppConstants.appName,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.scafoldBackgroundColor,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
      ),
      home: FutureBuilder<bool>(
        future: checkLoggedIn(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Scaffold(
              body: Center(child: getSimpleLoading(color: AppColors.green)),
            );
          }
          return snapshot.data! ? LandingScreen() : OnBoardingPage();
        },
      ),
    );
  }
}
