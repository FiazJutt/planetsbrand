import 'package:cached_network_image/cached_network_image.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:planetbrand/utils/app_assets.dart';
import 'package:planetbrand/utils/app_colors.dart';

successSnackBar({required String message}) {
  Get.showSnackbar(
    GetSnackBar(
      message: message,
      duration: const Duration(seconds: 3),
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.green,
      borderRadius: 10,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(10),
      animationDuration: const Duration(milliseconds: 300),
      onTap: (bar) {
        Get.back();
      },
      shouldIconPulse: false,
      icon: const HeroIcon(HeroIcons.checkCircle, color: Colors.white),
    ),
  );
}

errorSnackBar({required String message}) {
  Get.showSnackbar(
    GetSnackBar(
      message: message,
      duration: const Duration(seconds: 3),
      snackPosition: SnackPosition.TOP,
      backgroundColor: AppColors.red,
      borderRadius: 10,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(10),
      animationDuration: const Duration(milliseconds: 300),
      onTap: (bar) {
        Get.back();
      },
      shouldIconPulse: false,
      icon: const HeroIcon(HeroIcons.xCircle, color: Colors.white),
    ),
  );
}

infoSnackBar({required String message}) {
  Get.showSnackbar(
    GetSnackBar(
      message: message,
      duration: const Duration(seconds: 3),
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.black,
      borderRadius: 10,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(10),
      animationDuration: const Duration(milliseconds: 300),
      onTap: (bar) {
        Get.back();
      },
      shouldIconPulse: false,
      icon: const Icon(Icons.info_outline_rounded, color: Colors.white),
    ),
  );
}

getLoading({Color color = AppColors.themeWhiteColor, double size = 20}) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: AppColors.btnColor,
    ),
    height: 40,
    width: double.infinity,

    child: Center(
      child: LoadingAnimationWidget.discreteCircle(
        color: color,
        size: size,
        secondRingColor: Colors.transparent,
        thirdRingColor: Colors.transparent,
      ),
    ),
  );
}

getSimpleLoading({Color color = AppColors.textColor, double size = 20}) {
  return SizedBox(
    width: 90,
    child: Center(
      child: LoadingAnimationWidget.discreteCircle(
        color: color,
        size: size,
        secondRingColor: Colors.transparent,
        thirdRingColor: Colors.transparent,
      ),
    ),
  );
}

loadNetworkImage(
  String imageUrl, {
  double? width,
  double? height,
  BoxFit? fit,
}) {
  return CachedNetworkImage(
    imageUrl: imageUrl,
    width: width,
    height: height,
    fit: fit ?? BoxFit.cover,
    placeholder: (context, url) => Center(child: getSimpleLoading()),
    errorWidget:
        (context, url, error) => Image.asset(AppAssets.logo, height: 30),
  );
}

copyToClipboard(String text) {
  FlutterClipboard.copy(text).then((value) {
    successSnackBar(message: "Copied Successfully");
  });
}

void commonBottomSheet(
  context, {
  required HeroIcons icon,
  required Color iconColor,
  required String status,
  required String description,
  required Widget button,
}) {
  showModalBottomSheet(
    backgroundColor:
        Theme.of(context).brightness == Brightness.dark
            ? Colors.grey.shade700
            : Colors.white,
    context: context,
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            HeroIcon(
              icon,
              size: 50,
              color: iconColor,
              style: HeroIconStyle.solid,
            ),
            const SizedBox(height: 10),
            Text(
              status,
              style: GoogleFonts.montserrat(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              description,
              style: GoogleFonts.montserrat(
                fontSize: 12,
                color:
                    Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey.shade400
                        : Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            button,
            const SizedBox(height: 30),
          ],
        ),
      );
    },
  );
}

String dateFormatDayMonthYear(String dateString) {
  if (dateString.isEmpty) {
    return '';
  }
  try {
    DateTime date = DateTime.parse(dateString);
    String formattedDate = DateFormat('dd MMM yyyy').format(date);
    return formattedDate;
  } catch (e) {
    return '';
  }
}

String dateFormatMonthDayYear(String dateString) {
  if (dateString.isEmpty) {
    return '';
  }
  try {
    DateTime date = DateTime.parse(dateString);
    String formattedDate = DateFormat('MM/dd/yyyy').format(date);
    return formattedDate;
  } catch (e) {
    return '';
  }
}

String dateFormatDayMonthYearNew(String dateString) {
  if (dateString.isEmpty) {
    return '';
  }
  try {
    DateTime date = DateTime.parse(dateString);
    String formattedDate = DateFormat('dd/MM/yyyy').format(date);
    return formattedDate;
  } catch (e) {
    return '';
  }
}

String dateFormatMonthDayYearDash(String dateString) {
  if (dateString.isEmpty) {
    return '';
  }
  try {
    DateTime date = DateTime.parse(dateString);
    String formattedDate = DateFormat('dd-MM-yyyy').format(date);
    return formattedDate;
  } catch (e) {
    return '';
  }
}

String dateFormatYearMonthDayDash(String dateString) {
  if (dateString.isEmpty) {
    return '';
  }
  try {
    DateTime date = DateTime.parse(dateString);
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    return formattedDate;
  } catch (e) {
    return '';
  }
}

String dateFormatDayMonthYearTime(String dateString) {
  if (dateString.isEmpty) {
    return '';
  }
  try {
    DateTime date = DateTime.parse(dateString);
    String formattedDate = DateFormat('dd MMM,yyyy hh:mm:ss').format(date);
    return formattedDate;
  } catch (e) {
    return '';
  }
}

String dateFormatDayCompleteMonthYearTime(String dateString) {
  if (dateString.isEmpty) {
    return '';
  }
  try {
    DateTime date = DateTime.parse(dateString);

    String formattedDate = DateFormat(
      'EEE, dd MMM, yyyy hh:mm:ss',
    ).format(date);
    return formattedDate;
  } catch (e) {
    return '';
  }
}

String dateFormatDayMonthYearTimeShort(String dateString) {
  if (dateString.isEmpty) {
    return '';
  }
  try {
    DateTime date = DateTime.parse(dateString);
    String formattedDate = DateFormat('dd/MM/yyyy hh:mm').format(date);
    return formattedDate;
  } catch (e) {
    return '';
  }
}

String dateFormatDayMonthYearShort(String dateString) {
  if (dateString.isEmpty) {
    return '';
  }
  try {
    DateTime date = DateTime.parse(dateString);
    String formattedDate = DateFormat('dd/MM/yyyy').format(date);
    return formattedDate;
  } catch (e) {
    return '';
  }
}

String formatDateTimeWithMeridium(String inputDateTime) {
  if (inputDateTime.isEmpty) {
    return '';
  }
  try {
    DateTime dateTime = DateTime.parse(inputDateTime);
    String formattedDate = DateFormat('dd MMM yyyy').format(dateTime);
    String formattedTime = DateFormat('hh:mm a').format(dateTime);
    return '$formattedDate $formattedTime';
  } catch (e) {
    return '';
  }
}

String formatDateTimeWithMeridiumWithReference(String inputDateTime) {
  if (inputDateTime.isEmpty) {
    return '';
  }
  try {
    DateTime dateTime = DateTime.parse(inputDateTime);
    String formatted = DateFormat("MMMM d, y 'at' h:mm a").format(dateTime);
    return formatted;
  } catch (e) {
    return '';
  }
}

String currencyFormatAmount(double value) {
  final formatter = NumberFormat.currency(symbol: 'RS.', decimalDigits: 2);

  return formatter.format(value);
}

String maskAccountAddress(String address) {
  if (address.length <= 5) {
    return address;
  }
  return '****${address.substring(address.length - 15)}';
}

Widget getCodeBtn({required Function() onClick, required String title}) {
  return GestureDetector(
    onTap: onClick,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      width: 80,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.btnColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        title,
        style: GoogleFonts.montserrat(
          fontSize: 12,
          color: AppColors.themeWhiteColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}

Widget timerButton({required int counter}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 6),
    margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
    width: 50,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: AppColors.btnColor,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      "${counter}s",
      style: GoogleFonts.montserrat(
        fontSize: 12,
        color: AppColors.themeWhiteColor,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}
