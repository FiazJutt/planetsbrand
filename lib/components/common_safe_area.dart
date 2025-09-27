import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CommonSafeArea extends StatelessWidget {
  const CommonSafeArea({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.dark,
      child: child,
    );
  }
}
