import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';
import 'package:planetbrand/pages/account/account_page.dart';
import 'package:planetbrand/pages/cart/cart_screen.dart';
import 'package:planetbrand/pages/favourites/favorite_product_screen.dart';
import 'package:planetbrand/pages/home/home_page.dart';
import 'package:planetbrand/utils/app_colors.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomePage(),
    CartScreen(),
    FavoriteProductScreen(),
    AccountPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.scafoldBackgroundColor,
        elevation: 0,
        currentIndex: _currentIndex,
        selectedItemColor: AppColors.green,
        selectedLabelStyle: GoogleFonts.montserrat(fontSize: 14),
        unselectedLabelStyle: GoogleFonts.montserrat(fontSize: 14),
        unselectedItemColor: AppColors.hintColor,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: HeroIcon(
              HeroIcons.home,
              style:
                  _currentIndex == 0
                      ? HeroIconStyle.solid
                      : HeroIconStyle.outline,
              color: _currentIndex == 0 ? AppColors.green : AppColors.hintColor,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: HeroIcon(
              HeroIcons.shoppingCart,
              style:
                  _currentIndex == 1
                      ? HeroIconStyle.solid
                      : HeroIconStyle.outline,
              color: _currentIndex == 1 ? AppColors.green : AppColors.hintColor,
            ),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: HeroIcon(
              HeroIcons.heart,
              style:
                  _currentIndex == 2
                      ? HeroIconStyle.solid
                      : HeroIconStyle.outline,
              color: _currentIndex == 2 ? AppColors.green : AppColors.hintColor,
            ),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(
            icon: HeroIcon(
              HeroIcons.user,
              style:
                  _currentIndex == 3
                      ? HeroIconStyle.solid
                      : HeroIconStyle.outline,
              color: _currentIndex == 3 ? AppColors.green : AppColors.hintColor,
            ),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
