import 'package:fadeplay/desktop/settings/theme.dart';
import 'package:fadeplay/desktop/widgets/general/column_elem.dart';
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  const MyButton({super.key, required this.text, this.onTap, this.width});

  final void Function()? onTap;
  final String text;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return ColumnElem(
      activeColor: MyTheme.highAccentColor,
      inactiveColor: MyTheme.lowAccentColor,
      minimumWidth: true,
      hoverable: true,
      hoveringCursor: SystemMouseCursors.click,
      clickable: true,
      onTap: onTap,
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
