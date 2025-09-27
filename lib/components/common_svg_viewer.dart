import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:planetbrand/utils/app_colors.dart';
import 'package:planetbrand/utils/app_helpers.dart';

class CommonSvgViewer extends StatelessWidget {
  final String svgPath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Color? color;
  final Color filterColor;

  const CommonSvgViewer({
    super.key,
    required this.svgPath,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.color,
    this.filterColor = AppColors.logoColor,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      svgPath,
      width: width,
      height: height,
      fit: fit,
      colorFilter: ColorFilter.mode(filterColor, BlendMode.srcIn),
      placeholderBuilder: (context) => Center(child: getSimpleLoading()),
    );
  }
}
