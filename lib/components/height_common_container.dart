import 'package:flutter/material.dart';

class HeightCommonContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final BoxDecoration? decoration;
  final double height;

  const HeightCommonContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color = Colors.white,
    this.decoration,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: padding,
      margin: const EdgeInsets.symmetric(vertical: 10),
      height: height,
      decoration: decoration ??
          BoxDecoration(
            color: Theme.of(context).colorScheme.onPrimary,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
            borderRadius: BorderRadius.circular(8),
          ),
      child: child,
    );
  }
}
