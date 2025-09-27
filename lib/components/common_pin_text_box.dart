import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:planetbrand/utils/app_colors.dart';

class CommonPinTextBox extends StatefulWidget {
  final String? hitText;
  final String? labelText;
  final Widget? suffixIcons;
  final Widget? prefixIcons;
  final TextEditingController? textEditingController;
  final TextInputType? keyboardType;
  final EdgeInsetsGeometry? contentPadding;
  final Function(String)? onChange;
  final bool? obscuringText;
  final Color borderColor;
  final bool? onlyRead;
  final int? maxLines;
  final VoidCallback? onTap;
  final VoidCallback? onEditingComplete;
  final Color fillColor;
  final VoidCallback? onFocusLost; // Callback for when focus is lost

  const CommonPinTextBox({
    super.key,
    required this.hitText,
    this.labelText = "",
    this.fillColor = AppColors.themeWhiteColor,
    this.suffixIcons,
    this.prefixIcons,
    required this.textEditingController,
    this.contentPadding,
    this.onChange,
    this.maxLines,
    this.keyboardType,
    this.obscuringText,
    this.onlyRead,
    this.onTap,
    this.onEditingComplete,
    this.onFocusLost, // Add the new parameter
    this.borderColor = AppColors.borderColor,
  });

  @override
  _CommonPinTextBoxState createState() => _CommonPinTextBoxState();
}

class _CommonPinTextBoxState extends State<CommonPinTextBox> {
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
      height: 45,
      child: TextField(
        focusNode: _focusNode, // Assign the focus node
        maxLines: widget.maxLines ?? 1,
        onChanged: (value) {
          if (value.length > 6) {
            // If the input exceeds 6 characters, truncate it
            widget.textEditingController!.text = value.substring(0, 6);
            widget
                .textEditingController!
                .selection = TextSelection.fromPosition(
              TextPosition(offset: widget.textEditingController!.text.length),
            );
          }
          if (widget.onChange != null) {
            widget.onChange!(value);
          }
        },
        controller: widget.textEditingController,
        keyboardType: widget.keyboardType ?? TextInputType.number,
        obscureText: widget.obscuringText ?? false,
        readOnly: widget.onlyRead ?? false,
        style: GoogleFonts.montserrat(fontSize: 14),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly, // Allows only digits
        ],
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
      ),
    );
  }
}
