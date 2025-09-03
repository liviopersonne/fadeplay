import 'package:fadeplay/desktop/objects/logger.dart';
import 'package:fadeplay/desktop/settings/theme.dart';
import 'package:fadeplay/desktop/widgets/general/button.dart';
import 'package:fadeplay/desktop/widgets/general/color_size_box.dart';
import 'package:fadeplay/desktop/widgets/general/column_elem.dart';
import 'package:flutter/material.dart';

final logger = Logging("RectangleDialog");

/// A model for a `Dialog` that is a rectangular window with a title bar,
/// and some content underneath, with a set height and width
///
/// The content is passed in a `pages` map which maps a page title to the page.
/// If this map contains only 1 page, then no page bar will be shown above the page.
/// If the map contains more than 1 page, the page bar will be shown
///
/// By setting `onConfirm` != null, a cancel and a confirm button will appear beneath
/// the page, clicking on the confirm button will call `onConfirm`
class RectangleDialog extends StatefulWidget {
  const RectangleDialog({
    super.key,
    required this.title,
    required this.height,
    required this.width,
    required this.pages,
    this.onConfirm,
  });

  final String title;
  final double height;
  final double width;
  final Map<String, Widget> pages;
  final void Function()? onConfirm;

  @override
  State<RectangleDialog> createState() => _RectangleDialogState();
}

class _RectangleDialogState extends State<RectangleDialog> {
  PageController? _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = widget.pages.length > 1 ? PageController() : null;
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dialogParts = <Widget>[
      // title bar
      Container(
        color: MyTheme.colorBackgroundUltraDark,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(
          horizontal: MyTheme.paddingMedium,
          vertical: MyTheme.paddingSmall,
        ),
        child: Text(widget.title, style: MyTheme.textStyleTitle),
      ),

      Divider(height: 1, thickness: 1),
    ];

    // pages bar
    if (widget.pages.length > 1) {
      dialogParts.addAll([
        ColoredBox(
          color: MyTheme.colorBackgroundVeryDark,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: MyTheme.paddingMedium),
            child: Row(
              children: List.generate(
                widget.pages.length,
                (i) => MyButton.menuButton(
                  text: widget.pages.keys.elementAt(i),
                  onTap: () => _pageController?.animateToPage(
                    i,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  ),
                ),
              ),
            ),
          ),
        ),

        Divider(height: 1, thickness: 1),

        Expanded(
          child: PageView(
            scrollDirection: Axis.horizontal,
            physics: NeverScrollableScrollPhysics(),

            controller: _pageController,
            children: widget.pages.values.map((page) => page).toList(),
          ),
        ),
      ]);
    } else if (widget.pages.length == 1) {
      // body
      dialogParts.addAll([Expanded(child: widget.pages.values.first)]);
    } else {
      logger.error(
        "Invalid number of pages were passed to the RectangleDialog: '${widget.pages.length}",
      );
      throw Error();
    }

    // Cancel & Confirm buttons at the bottom
    if (widget.onConfirm != null) {
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
                MyButton(text: "Confirm", onTap: widget.onConfirm),
                MyButton(text: "Cancel", onTap: () => Navigator.pop(context)),
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
      child: ColorSizeBox(
        color: MyTheme.colorBackgroundDark,
        height: widget.height,
        width: widget.width,
        child: Column(mainAxisSize: MainAxisSize.min, children: dialogParts),
      ),
    );
  }
}
