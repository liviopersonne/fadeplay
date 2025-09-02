import 'package:fadeplay/desktop/settings/theme.dart';
import 'package:fadeplay/desktop/widgets/general/button.dart';
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
    this.onConfirm,
  });

  final String title;
  final double height;
  final double width;
  final Widget content;
  final void Function()? onConfirm;

  @override
  Widget build(BuildContext context) {
    final dialogParts = [
      // title bar
      Container(
        color: MyTheme.colorBackgroundUltraDark,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(
          horizontal: MyTheme.paddingMedium,
          vertical: MyTheme.paddingSmall,
        ),
        child: Text(title, style: MyTheme.textStyleTitle),
      ),

      Divider(height: 1, thickness: 1),

      // body
      Expanded(child: content),
    ];

    if (onConfirm != null) {
      dialogParts.addAll([
        Divider(height: 1, thickness: 1),
        ColoredBox(
          color: MyTheme.colorBackgroundUltraDark,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MyTheme.paddingMedium,
              vertical: MyTheme.paddingSmall,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              spacing: MyTheme.paddingMedium,
              children: [
                MyButton(text: "Cancel"),
                MyButton(text: "Confirm"),
              ],
            ),
          ),
        ),
      ]);
    }

    return Dialog(
      shape: BeveledRectangleBorder(
        side: BorderSide(width: 0.3, color: MyTheme.colorBackgroundUltraDark),
      ),
      // insetPadding: const EdgeInsets.all(50),
      child: ColorSizeBox(
        color: MyTheme.colorBackgroundDark,
        height: height,
        width: width,
        child: Column(mainAxisSize: MainAxisSize.min, children: dialogParts),
      ),
    );
  }
}
