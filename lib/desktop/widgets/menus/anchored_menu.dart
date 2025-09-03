import 'package:fadeplay/desktop/settings/theme.dart';
import 'package:fadeplay/desktop/widgets/general/button.dart';
import 'package:flutter/material.dart';

/// Wrapped around an `child` that shows a menu when you `primaryClick` on it.
/// The menu is showed under the `child`.
/// - `menuItems`: map that links the action's name to what it does
/// - `child`: the Widget that you click on to open the menu
class AnchoredMenu extends StatelessWidget {
  const AnchoredMenu({
    super.key,
    required this.menuItems,
    this.width,
    required this.child,
    required this.menuController,
  });

  final Map<String, void Function()?> menuItems;
  final Widget child;
  final double? width;
  final MenuController menuController;

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      consumeOutsideTap: true,
      controller: menuController,
      style: MenuStyle(
        shape: WidgetStatePropertyAll(
          BeveledRectangleBorder(
            side: BorderSide(
              width: 0.3,
              color: MyTheme.colorBackgroundUltraDark,
            ),
          ),
        ),
      ),
      menuChildren: menuItems.entries
          .map(
            (item) => MyButton.menuButton(
              focusable: false,
              text: item.key,
              onTap: () {
                item.value?.call();
                menuController.close();
              },
              width: width,
            ),
          )
          .toList(),
      // NOTE: I can use `builder` instead of `child` if I want the child to depend on the controller
      child: child,
    );
  }
}
