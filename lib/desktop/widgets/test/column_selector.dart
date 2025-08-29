import 'dart:convert';

import 'package:desktop_multi_window/desktop_multi_window.dart';
import 'package:fadeplay/desktop/objects/column_browser/column_browser_layout.dart';
import 'package:fadeplay/desktop/objects/logger.dart';
import 'package:fadeplay/desktop/objects/window_manager.dart';
import 'package:fadeplay/desktop/settings/theme.dart';
import 'package:fadeplay/desktop/widgets/column_browser/column_browser.dart';
import 'package:fadeplay/desktop/widgets/column_selector/column_selector.dart';
import 'package:fadeplay/desktop/widgets/general/color_size_box.dart';
import 'package:fadeplay/desktop/widgets/general/row_elem.dart';
import 'package:flutter/material.dart';

final logger = Logging("TestColumnSelectorWidget");

class TestColumnSelectorWidget extends StatelessWidget {
  const TestColumnSelectorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final columnIds = ['title', 'duration'];
    final controller = ColumnBrowserController();
    controller.updateLayout(ColumnBrowserLayout.fromIds(columnIds));

    return Scaffold(
      body: Center(
        // child: BaseColumnSelector(controller: controller),
        child: WindowColumnSelector(controller: controller),
      ),
    );
  }
}

class BaseColumnSelector extends StatelessWidget {
  const BaseColumnSelector({super.key, required this.controller});

  final ColumnBrowserController controller;

  @override
  Widget build(BuildContext context) {
    return ColorSizeBox(
      color: Colors.grey[200],
      height: 500,
      width: 700,
      child: ColumnSelector(controller: controller),
    );
  }
}

class WindowColumnSelector extends StatelessWidget {
  const WindowColumnSelector({super.key, required this.controller});

  final ColumnBrowserController controller;

  Future<void> showWindow() async {
    // final window = await DesktopMultiWindow.createWindow(jsonEncode({}));
    // window
    //   ..setFrame(const Offset(100, 100) & const Size(800, 600))
    //   ..setTitle('Sub Window')
    //   ..center()
    //   ..show();

    await WindowManager.createWindow(idName: "1", title: "Hello !");
    await WindowManager.showWindow(idName: "1");
    await Future.delayed(Duration(seconds: 3));
    await WindowManager.hideWindow(idName: "1");
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: RowElem(
        inactiveTextStyle: MyTheme.textStyleNormal,
        inactiveColor: Colors.deepOrange,
        activeColor: Colors.blue,
        clickable: true,
        hoverable: true,
        hoveringCursor: SystemMouseCursors.click,
        onTap: () => showWindow(),
        // onTap: () => showDialog(
        //   context: context,
        //   builder: (_) => AlertDialog(
        //     constraints: BoxConstraints.tight(Size(500, 500)),
        //     title: Text("Set Displayed Fields", style: MyTheme.textStyleTitle),
        //     content: ColumnSelector(controller: controller),
        //   ),
        // ),
        child: SizedBox(
          child: Text("Choose columns", textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
