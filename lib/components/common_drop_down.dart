import 'package:flutter/material.dart';
import 'package:planetbrand/utils/app_colors.dart';

class CommonDropDown extends StatelessWidget {
  final Widget? hitText;
  final String? value;
  final Widget? suffixIcons;
  final Widget? prefixIcons;
  final TextStyle? hitTextStyle;
  final EdgeInsetsGeometry? contentPadding;
  final List<DropdownMenuItem<String>>? dropdownMenuItemList;
  final List<Widget> Function(BuildContext)? selectedItemBuilder;
  final Function(String?)? onChangeValue;
  final Function()? onTap;

  const CommonDropDown({
    super.key,
    this.hitText,
    this.suffixIcons,
    this.prefixIcons,
    this.contentPadding,
    this.hitTextStyle,
    this.selectedItemBuilder,
    this.value,
    this.onTap,
    this.dropdownMenuItemList,
    this.onChangeValue,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: DropdownButtonFormField(
        borderRadius: BorderRadius.circular(10),
        items: dropdownMenuItemList,
        selectedItemBuilder: selectedItemBuilder,
        onChanged: onChangeValue,
        isExpanded: true,
        isDense: false,
        decoration: InputDecoration(
          contentPadding: contentPadding,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.textColor, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.borderColor),
          ),
          suffixIcon: suffixIcons,
          prefixIcon: prefixIcons,
        ),
        itemHeight: 60,
        iconSize: 0,
        value: value,
        hint: hitText,
        style: hitTextStyle,
        onTap: onTap,
      ),
    );
  }
}
