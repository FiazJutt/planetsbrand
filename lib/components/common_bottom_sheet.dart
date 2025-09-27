import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';

class CommonButtonSheet extends StatelessWidget {
  final HeroIcons icon;
  final String? title;
  final String subtitle;
  final Color iconColor;
  final List<Widget> actionButtons;
  final HeroIconStyle style;

  const CommonButtonSheet({
    super.key,
    required this.icon,
    this.title,
    required this.subtitle,
    required this.iconColor,
    required this.actionButtons,
    this.style = HeroIconStyle.outline,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          HeroIcon(icon, size: 40, color: iconColor, style: style),
          const SizedBox(height: 20),
          if (title != null)
            Text(
              title!,
              style: GoogleFonts.montserrat(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          const SizedBox(height: 15),
          Text(
            subtitle,
            style: GoogleFonts.montserrat(fontSize: 15),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: actionButtons,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
