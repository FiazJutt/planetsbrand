import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:planetbrand/components/common_text_filed.dart';
import 'package:planetbrand/utils/app_colors.dart';

class CommonSingleDatePicker extends StatelessWidget {
  final TextEditingController controller;
  final String? label;
  final String? hint;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final Function(DateTime)? onDateSelected;
  final bool? onlyRead;
  final String? Function(String?)? validator;

  const CommonSingleDatePicker({
    super.key,
    required this.controller,
    this.label,
    this.hint,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.onDateSelected,
    this.onlyRead,
    this.validator,
  });

  Future<void> _selectDate(BuildContext context) async {
    DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? now,
      firstDate: firstDate ?? DateTime(2000),
      lastDate: lastDate ?? DateTime(now.year + 5),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.btnColor,
              onPrimary: Colors.white,
              onSurface: AppColors.blackColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
      if (onDateSelected != null) {
        onDateSelected!(picked);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CommonTextField(
      hitText: hint ?? "Select date",
      labelText: label ?? "",
      textEditingController: controller,
      onlyRead: true,
      onTap: () => _selectDate(context),
      validator: validator,
      suffixIcons: const Icon(Icons.calendar_today, size: 20),
    );
  }
}
