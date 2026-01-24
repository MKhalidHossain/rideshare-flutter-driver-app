import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingShimmer extends StatelessWidget {
  final double size;
  final Color color;
  final bool isCircle;
  final BorderRadius? borderRadius;

  const LoadingShimmer({
    super.key,
    this.size = 32,
    this.color = Colors.grey,
    this.isCircle = true,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final Color base = color.withOpacity(0.25);
    final Color highlight = color.withOpacity(0.6);

    return Shimmer.fromColors(
      baseColor: base,
      highlightColor: highlight,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: base,
          shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: isCircle
              ? null
              : (borderRadius ?? BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
