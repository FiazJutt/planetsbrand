import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';
import 'package:planetbrand/utils/app_colors.dart';

class CommonSearchableDropDown extends StatelessWidget {
  const CommonSearchableDropDown({
    super.key,
    required this.itemList,
    required this.onChangeValue,
    required this.hintText,
    required this.hintTextOfField,
    required this.selectedItem,
    this.fontsize = 14,
    this.onTap,
    this.dropdownTileColor = Colors.white, // Default color for dropdown tiles
  });

  final List<String> itemList;
  final Function(String?)? onChangeValue;
  final String hintText;
  final String hintTextOfField;
  final String? selectedItem;
  final double fontsize;
  final Color dropdownTileColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: DropdownSearch<String>(
        popupProps: PopupProps.menu(
          showSelectedItems: false,
          showSearchBox: true,
          menuProps: MenuProps(backgroundColor: AppColors.themeWhiteColor),
          searchFieldProps: TextFieldProps(
            style: GoogleFonts.montserrat(
              fontSize: fontsize,
              color:
                  Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.grey.shade700,
            ),
            decoration: InputDecoration(
              fillColor: AppColors.themeWhiteColor,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              hintText: hintTextOfField,
              hintStyle: GoogleFonts.montserrat(
                fontSize: fontsize,
                color: AppColors.blackColor,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: AppColors.borderColor,
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.borderColor),
              ),
              contentPadding: const EdgeInsets.only(left: 20),
            ),
          ),
          itemBuilder: (context, item, isSelected) {
            return Container(
              color: dropdownTileColor,
              child: ListTile(
                title: Text(
                  item,
                  style: GoogleFonts.montserrat(
                    fontSize: 14,
                    color: AppColors.blackColor,
                  ),
                ),
              ),
            );
          },
        ),
        items: itemList,
        dropdownDecoratorProps: DropDownDecoratorProps(
          baseStyle: GoogleFonts.montserrat(
            fontSize: fontsize,
            color:
                Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.grey.shade700,
          ),
          dropdownSearchDecoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            hintText: hintText,
            hintStyle: GoogleFonts.montserrat(
              fontSize: fontsize,
              color:
                  Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.grey.shade700,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.borderColor),
            ),
            contentPadding: const EdgeInsets.only(left: 20),
          ),
        ),
        onChanged: onChangeValue,
        dropdownButtonProps: DropdownButtonProps(
          icon: GestureDetector(
            onTap: onTap,
            child: HeroIcon(
              HeroIcons.xMark,
              color: AppColors.hintColor,
              size: 20,
            ),
          ),
        ),
        selectedItem: selectedItem?.isNotEmpty == true ? selectedItem : null,
      ),
    );
  }
}
