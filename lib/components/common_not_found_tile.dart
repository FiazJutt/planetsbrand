import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';

class CommonNotFoundTile extends StatelessWidget {
  const CommonNotFoundTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        // mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          HeroIcon(HeroIcons.faceFrown, color: Color(0xffc5c5c5), size: 80),
          Text("No Data Found", style: GoogleFonts.montserrat(fontSize: 15)),
        ],
      ),
    );
  }
}
