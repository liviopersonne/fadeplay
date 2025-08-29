import 'dart:convert';

import 'package:fadeplay/desktop/objects/column_browser/column_browser_layout.dart';
import 'package:fadeplay/desktop/settings/theme.dart';
import 'package:fadeplay/desktop/widgets/column_browser/column_browser.dart';
import 'package:fadeplay/desktop/widgets/column_selector/column_selector.dart';
import 'package:fadeplay/desktop/widgets/general/color_size_box.dart';
import 'package:fadeplay/desktop/widgets/general/row_elem.dart';
import 'package:flutter/material.dart';

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
        onTap: () => showDialog(
          context: context,
          builder: (_) => AlertDialog(
            constraints: BoxConstraints.tight(Size(500, 500)),
            title: Text("Set Displayed Fields", style: MyTheme.textStyleTitle),
            content: ColumnSelector(controller: controller),
          ),
        ),
        child: SizedBox(
          child: Text("Choose columns", textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
