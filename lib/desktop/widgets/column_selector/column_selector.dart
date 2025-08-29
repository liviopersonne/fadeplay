import 'package:fadeplay/desktop/objects/column_browser/column_browser_layout.dart';
import 'package:fadeplay/desktop/objects/column_browser/item_column.dart';
import 'package:fadeplay/desktop/objects/logger.dart';
import 'package:fadeplay/desktop/widgets/column_browser/column_browser.dart';
import 'package:fadeplay/desktop/widgets/column_selector/selectable_column_list.dart';
import 'package:fadeplay/desktop/widgets/column_selector/selected_column_list.dart';
import 'package:flutter/material.dart';

final logger = Logging("ColumnSelector");

class ColumnSelector extends StatelessWidget {
  ColumnSelector({super.key, required this.controller});

  final List<String> allColumns = ItemColumn.allColumns.keys.toList();
  final ColumnBrowserController controller;
  final dragNotifier = ValueNotifier<bool>(false);

  List<ItemColumn> getSelectedColumns(ColumnBrowserLayout layout) {
    return layout.elems.map((elem) => elem.column).toList();
  }

  List<ItemColumn> getUnselectedColumns(ColumnBrowserLayout layout) {
    final selectedIds = layout.elems.map((elem) => elem.column.id).toList();
    final unselectedIds = allColumns.where((id) => !selectedIds.contains(id));
    return unselectedIds.map((id) => ItemColumn.allColumns[id]!).toList();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ColumnBrowserLayout>(
      valueListenable: controller.columnsLayout,
      builder: (_, layout, _) {
        return Row(
          children: [
            Expanded(
              child: SelectableColumnList(
                columns: getUnselectedColumns(layout),
                dragNotifier: dragNotifier,
              ),
            ),
            Expanded(
              child: SelectedColumnList(
                controller: controller,
                columns: getSelectedColumns(layout),
                dragNotifier: dragNotifier,
              ),
            ),
          ],
        );
      },
    );
  }
}
