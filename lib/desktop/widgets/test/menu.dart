import 'package:fadeplay/desktop/settings/theme.dart';
import 'package:fadeplay/desktop/widgets/general/button.dart';
import 'package:fadeplay/desktop/widgets/general/color_size_box.dart';
import 'package:flutter/material.dart';

class TestMenu extends StatelessWidget {
  const TestMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final menuController = MenuController();

    return Scaffold(
      body: Center(
        child: MyMenuAnchor(
          controller: menuController,
          // child: anchoredMenu(menuController),
          child: cursorMenu(menuController),
        ),
      ),
    );
  }
}

Widget anchoredMenu(MenuController menuController) {
  return MyButton(
    text: "Open menu",
    width: 200,
    onTap: () {
      menuController.open();
    },
  );
}

Widget cursorMenu(MenuController menuController) {
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

class MyMenuAnchor extends StatelessWidget {
  const MyMenuAnchor({
    super.key,
    required this.controller,
    required this.child,
  });

  final MenuController controller;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      controller: controller,
      style: MenuStyle(
        shape: WidgetStatePropertyAll(
          BeveledRectangleBorder(
            side: BorderSide(
              width: 0.3,
              color: MyTheme.colorBackgroundVeryDark,
            ),
          ),
        ),
      ),
      menuChildren: const [
        MyButton(text: "Hello 1", width: 100),
        MyButton(text: "Hello 2", width: 100),
        MyButton(text: "Hello 3", width: 100),
      ],
      // NOTE: I can use `builder` instead of `child` if I want the child to depend on the controller
      child: child,
    );
  }
}
