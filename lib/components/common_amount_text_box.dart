import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:planetbrand/utils/app_colors.dart';

class CommonAmountTextBox extends StatefulWidget {
  final String? hitText;
  final String? labelText;
  final Widget? suffixIcons;
  final Widget? prefixIcons;
  final TextEditingController? textEditingController;
  final EdgeInsetsGeometry? contentPadding;

  final Function(String)? onChange;
  final String? Function(String?)?
  validator; // Validator should return a String?
  final bool? obscuringText;
  final Color borderColor;
  final bool? onlyRead;
  final int? maxLength;
  final int? maxLines;
  final VoidCallback? onTap;
  final VoidCallback? onEditingComplete;
  final Color fillColor;
  final VoidCallback? onFocusLost; // Callback for when focus is lost

  const CommonAmountTextBox({
    super.key,
    required this.hitText,
    this.labelText = "",
    this.fillColor = AppColors.whiteColor,
    this.suffixIcons,
    this.prefixIcons,
    required this.textEditingController,
    this.contentPadding,
    this.onChange,
    this.validator,
    this.maxLines,
    this.obscuringText,
    this.maxLength,
    this.onlyRead,
    this.onTap,
    this.onEditingComplete,
    this.onFocusLost, // Add the new parameter

    this.borderColor = AppColors.borderColor,
  });

  @override
  // ignore: library_private_types_in_public_api
  _CommonAmountTextBoxState createState() => _CommonAmountTextBoxState();
}

class _CommonAmountTextBoxState extends State<CommonAmountTextBox> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus && widget.onFocusLost != null) {
        widget.onFocusLost!();
      }
    });
  }

  @override
  void dispose() {
    _focusNode
        .dispose(); // Dispose of the focus node when the widget is removed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: TextFormField(
        focusNode: _focusNode, // Assign the focus node
        maxLines: widget.maxLines ?? 1,
        onChanged: widget.onChange,
        controller: widget.textEditingController,
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        obscureText: widget.obscuringText ?? false,
        readOnly: widget.onlyRead ?? false,
        maxLength: widget.maxLength,
        style: GoogleFonts.montserrat(fontSize: 14),
        decoration: InputDecoration(
          contentPadding: widget.contentPadding,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: AppColors.borderColor, width: 1),
          ),
          fillColor:
              Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey.shade800
                  : Colors.white,
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: widget.borderColor),
          ),
          hintText: widget.hitText.toString(),
          labelText: widget.labelText,
          labelStyle: GoogleFonts.montserrat(
            fontSize: 14,
            color: AppColors.blackColor,
          ),
          hintStyle: GoogleFonts.montserrat(
            fontSize: 14,
            color:
                Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : Colors.grey.shade900,
          ),
          suffixIcon: widget.suffixIcons,
          prefixIcon: widget.prefixIcons,
        ),
        onEditingComplete: widget.onEditingComplete,
        onTap: widget.onTap,
        textAlignVertical: TextAlignVertical.center,
        cursorColor: AppColors.textColor,
        validator: widget.validator, // Use the passed validator function here
      ),
    );
  }
}
