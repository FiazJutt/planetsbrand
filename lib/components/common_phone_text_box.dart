import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:planetbrand/utils/app_colors.dart';

class CommonPhoneTextBox extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool readOnly;
  final String countryCode;
  final Function(PhoneNumber)? onChanged;
  final EdgeInsetsGeometry? contentPadding;
  final Color fillColor;
  final Color borderColor;

  const CommonPhoneTextBox({
    super.key,
    required this.hintText,
    required this.controller,
    this.readOnly = false,
    this.countryCode = "92",
    required this.onChanged,
    this.contentPadding,
    this.fillColor = AppColors.themeWhiteColor,
    this.borderColor = AppColors.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      cursorColor: AppColors.textColor,
      controller: controller,
      initialCountryCode: 'PK',
      dropdownTextStyle: GoogleFonts.montserrat(
        fontSize: 14,
        color:
            Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.grey.shade700,
      ),
      pickerDialogStyle: PickerDialogStyle(
        countryCodeStyle: GoogleFonts.montserrat(fontSize: 14),
        countryNameStyle: GoogleFonts.montserrat(fontSize: 14),
      ),
      onChanged: onChanged,
      readOnly: readOnly,
      style: GoogleFonts.montserrat(
        fontSize: 14,
        color:
            Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.grey.shade700,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.montserrat(
          fontSize: 14,
          color:
              Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.grey.shade700,
        ),
        contentPadding: contentPadding,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: AppColors.borderColor, width: 1),
        ),
        fillColor:
            Theme.of(context).brightness == Brightness.dark
                ? Colors.grey.shade800
                : fillColor,
        filled: true,

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: borderColor),
        ),
      ),
    );
  }
}
