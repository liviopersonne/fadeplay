import 'package:fadeplay/desktop/settings/theme.dart';
import 'package:fadeplay/desktop/widgets/general/column_elem.dart';
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  const MyButton({
    super.key,
    required this.text,
    this.onTap,
    this.onSecondaryTap,
    this.onTapDown,
    this.onSecondaryTapDown,
    this.onDoubleTap,
    this.width,
  });

  final String text;
  final double? width;
  final void Function()? onTap;
  final void Function()? onSecondaryTap;
  final void Function(TapDownDetails details)? onTapDown;
  final void Function(TapDownDetails details)? onSecondaryTapDown;
  final void Function()? onDoubleTap;

  @override
  Widget build(BuildContext context) {
    return ColumnElem(
      activeColor: MyTheme.colorAccentHigh,
      inactiveColor: MyTheme.colorAccentLow,
      minimumWidth: true,
      hoverable: true,
      hoveringCursor: SystemMouseCursors.click,
      clickable: true,
      onTap: onTap,
      onSecondaryTap: onSecondaryTap,
      onTapDown: onTapDown,
      onSecondaryTapDown: onSecondaryTapDown,
      onDoubleTap: onDoubleTap,
      inactiveTextStyle: MyTheme.textStyleNormal,
      child: width != null
          ? SizedBox(
              width: width,
              child: Center(child: Text(text)),
            )
          : Padding(
              padding: EdgeInsetsGeometry.symmetric(
                horizontal: MyTheme.paddingSmall,
              ),
              child: Center(child: Text(text)),
            ),
    );
  }
}
