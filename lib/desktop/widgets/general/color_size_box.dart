import 'package:flutter/material.dart';

class ColorSizeBox extends StatelessWidget {
  const ColorSizeBox({
    super.key,
    this.color,
    this.height,
    this.width,
    this.child,
  });

  final Color? color;
  final double? height;
  final double? width;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: color == null ? child : ColoredBox(color: color!, child: child),
    );
  }
}
