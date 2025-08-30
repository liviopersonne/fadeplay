import 'package:fadeplay/desktop/settings/theme.dart';
import 'package:fadeplay/desktop/widgets/column_browser/column_browser_headers.dart';
import 'package:fadeplay/desktop/widgets/general/button.dart';
import 'package:fadeplay/desktop/widgets/general/color_size_box.dart';
import 'package:fadeplay/desktop/widgets/menus/anchored_menu.dart';
import 'package:flutter/material.dart';

class TestMenu extends StatelessWidget {
  const TestMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final menuController = MenuController();

    return Scaffold(
      body: Center(
        child: AnchoredMenu(
          width: 100,
          menuController: menuController,
          menuItems: {
            "Item 1": () => logger.log("Clicked item 1"),
            "Item 2": () => logger.log("Clicked item 2"),
            "Item 3": () => logger.log("Clicked item 3"),
          },
          // child: smallMenuButton(menuController),
          child: fullscreenMenuButton(menuController),
        ),
      ),
    );
  }
}

Widget smallMenuButton(MenuController menuController) {
  return MyButton(
    text: "Open menu",
    width: 200,
    onTap: () {
      menuController.isOpen ? menuController.close() : menuController.open();
    },
    onSecondaryTapDown: (details) => menuController.isOpen
        ? menuController.close()
        : menuController.open(position: details.localPosition),
  );
}

Widget fullscreenMenuButton(MenuController menuController) {
  return GestureDetector(
    child: ColorSizeBox(
      color: Colors.blueGrey,
      width: 800,
      child: Center(child: Text("Open menu !", style: MyTheme.textStyleTitle)),
    ),
    onTapDown: (details) =>
        menuController.open(position: details.localPosition),
  );
}
