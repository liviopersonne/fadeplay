import 'package:fadeplay/desktop/objects/column_browser/column_browser_layout.dart';
import 'package:fadeplay/desktop/widgets/column_browser/column_browser.dart';
import 'package:fadeplay/desktop/widgets/column_browser/column_selector.dart';
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
        child: Container(
          color: Colors.grey[200],
          height: 500,
          width: 700,
          child: ColumnSelector(controller: controller),
        ),
      ),
    );
  }
}
