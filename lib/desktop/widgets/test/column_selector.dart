import 'package:fadeplay/desktop/objects/column_browser/column_browser_layout.dart';
import 'package:fadeplay/desktop/settings/theme.dart';
import 'package:fadeplay/desktop/widgets/column_browser/column_browser.dart';
import 'package:fadeplay/desktop/widgets/column_selector/column_selector.dart';
import 'package:fadeplay/desktop/widgets/general/color_size_box.dart';
import 'package:fadeplay/desktop/widgets/general/column_elem.dart';
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
        child: DialogColumnSelector(controller: controller),
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

class DialogColumnSelector extends StatelessWidget {
  const DialogColumnSelector({super.key, required this.controller});

  final ColumnBrowserController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: ColumnElem(
        inactiveTextStyle: MyTheme.textStyleNormal,
        inactiveColor: Colors.deepOrange,
        activeColor: Colors.blue,
        clickable: true,
        hoverable: true,
        hoveringCursor: SystemMouseCursors.click,
        onTap: () =>
            ColumnSelector(controller: controller).showAsDialog(context),
        child: SizedBox(
          child: Text("Choose columns", textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
