import 'package:fadeplay/desktop/objects/column_browser/column_browser_layout.dart';
import 'package:fadeplay/desktop/objects/column_browser/item_column.dart';
import 'package:fadeplay/desktop/objects/logger.dart';
import 'package:fadeplay/desktop/settings/theme.dart';
import 'package:fadeplay/desktop/widgets/column_browser/column_browser.dart';
import 'package:fadeplay/desktop/widgets/column_selector/selectable_column_list.dart';
import 'package:fadeplay/desktop/widgets/column_selector/selected_column_list.dart';
import 'package:fadeplay/desktop/widgets/general/rectangle_dialog.dart';
import 'package:flutter/material.dart';

final logger = Logging("ColumnSelector");

class ColumnSelector extends StatelessWidget {
  ColumnSelector({super.key, required this.controller});

  final List<String> _allColumns = ItemColumn.allColumns.keys.toList();
  final ColumnBrowserController controller;
  final _dragNotifier = ValueNotifier<bool>(false);

  List<ItemColumn> _getSelectedColumns(ColumnBrowserLayout layout) {
    return layout.elems.map((elem) => elem.column).toList();
  }

  List<ItemColumn> _getUnselectedColumns(ColumnBrowserLayout layout) {
    final selectedIds = layout.elems.map((elem) => elem.column.id).toList();
    final unselectedIds = _allColumns.where((id) => !selectedIds.contains(id));
    return unselectedIds.map((id) => ItemColumn.allColumns[id]!).toList();
  }

  /// Shows the dialog containing this widget
  void showAsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return RectangleDialog(
          title: "Set Displayed Fields",
          height: 400,
          width: 600,
          content: this,
        );
      },
    );
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
                columns: _getUnselectedColumns(layout),
                dragNotifier: _dragNotifier,
              ),
            ),
            VerticalDivider(width: 1),
            Expanded(
              child: SelectedColumnList(
                controller: controller,
                columns: _getSelectedColumns(layout),
                dragNotifier: _dragNotifier,
              ),
            ),
          ],
        );
      },
    );
  }
}
