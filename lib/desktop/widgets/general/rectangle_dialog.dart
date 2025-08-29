import 'package:fadeplay/desktop/settings/theme.dart';
import 'package:fadeplay/desktop/widgets/general/color_size_box.dart';
import 'package:flutter/material.dart';

/// A model for a `Dialog` that is a rectangular window with a title bar,
/// and some content underneath, with a set height and width
class RectangleDialog extends StatelessWidget {
  const RectangleDialog({
    super.key,
    required this.title,
    required this.height,
    required this.width,
    required this.content,
  });

  final String title;
  final double height;
  final double width;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      insetPadding: const EdgeInsets.all(100),
      child: ColorSizeBox(
        color: MyTheme.backgroundLight,
        height: height,
        width: width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // title bar
            Container(
              color: MyTheme.backgroundDark,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(
                horizontal: MyTheme.paddingBig,
                vertical: MyTheme.paddingSmall,
              ),
              child: Text(title, style: MyTheme.textStyleTitle),
            ),

            const Divider(height: 1, thickness: 1),

            // body
            Expanded(child: content),
          ],
        ),
      ),
    );
  }
}
