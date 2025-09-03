import 'package:fadeplay/desktop/settings/theme.dart';
import 'package:fadeplay/desktop/widgets/general/column_elem.dart';
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  const MyButton({
    super.key,
    required this.text,
    this.activeColor,
    this.inactiveColor,
    this.onTap,
    this.onSecondaryTap,
    this.onTapDown,
    this.onSecondaryTapDown,
    this.onDoubleTap,
    this.width,
  }) : focusable = false;

  MyButton.menuButton({
    super.key,
    required this.text,
    this.onTap,
    this.onSecondaryTap,
    this.onTapDown,
    this.onSecondaryTapDown,
    this.onDoubleTap,
    this.width,
    this.focusable = true,
  }) : inactiveColor = MyTheme.colorBackgroundVeryDark,
       activeColor = MyTheme.colorBackgroundLight;

  final String text;
  final Color? activeColor;
  final Color? inactiveColor;
  final double? width;
  final void Function()? onTap;
  final void Function()? onSecondaryTap;
  final void Function(TapDownDetails details)? onTapDown;
  final void Function(TapDownDetails details)? onSecondaryTapDown;
  final void Function()? onDoubleTap;
  final bool focusable;

  @override
  Widget build(BuildContext context) {
    return ColumnElem(
      activeColor: activeColor ?? MyTheme.colorAccentHigh,
      inactiveColor: inactiveColor ?? MyTheme.colorAccentLow,
      minimumWidth: true,
      hoverable: true,
      hoveringCursor: SystemMouseCursors.click,
      focusable: focusable,
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
              child: Center(child: Text(text, overflow: TextOverflow.ellipsis)),
            )
          : Padding(
              padding: EdgeInsetsGeometry.symmetric(
                horizontal: MyTheme.paddingSmall,
              ),
              child: Center(child: Text(text, overflow: TextOverflow.ellipsis)),
            ),
    );
  }
}
