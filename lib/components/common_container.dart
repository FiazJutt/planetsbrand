import 'package:flutter/material.dart';

class CommonContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final BoxDecoration? decoration;

  const CommonContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color = Colors.white,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: padding,
      margin: margin,
      decoration:
          decoration ??
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
            borderRadius: BorderRadius.circular(4),
          ),
      child: child,
    );
  }
}
