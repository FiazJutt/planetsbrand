import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CommonShimmerEffect extends StatelessWidget {
  const CommonShimmerEffect({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 4, top: 5),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: ListView(
        children: List.generate(30, (index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Shimmer.fromColors(
              baseColor:
                  Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey.shade700
                      : Colors.grey[300]!,
              highlightColor:
                  Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey.shade600
                      : Colors.grey[100]!,
              child: Container(
                height: 20,
                width: double.infinity,
                color:
                    Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey.shade800
                        : Colors.white,
              ),
            ),
          );
        }),
      ),
    );
  }
}
