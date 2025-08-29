import 'package:fadeplay/desktop/objects/column_browser/column_browser_layout.dart';
import 'package:fadeplay/desktop/objects/column_browser/item_column.dart';
import 'package:fadeplay/desktop/objects/logger.dart';
import 'package:fadeplay/desktop/widgets/column_browser/column_browser.dart';
import 'package:fadeplay/desktop/widgets/column_selector/selectable_column_list.dart';
import 'package:fadeplay/desktop/widgets/column_selector/selected_column_list.dart';
import 'package:flutter/material.dart';

final logger = Logging("ColumnSelector");

class ColumnSelector extends StatefulWidget {
  ColumnSelector({super.key, required this.controller});

  final List<String> allColumns = ItemColumn.allColumns.keys.toList();
  final ColumnBrowserController controller;

  @override
  State<ColumnSelector> createState() => _ColumnSelectorState();
}

class _ColumnSelectorState extends State<ColumnSelector> {
  bool dragging = false;

  void setDragging(bool value) => setState(() => dragging = value);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ColumnBrowserLayout>(
      valueListenable: widget.controller.columnsLayout,
      builder: (context, value, child) {
        final List<ColumnWithWidth> selectedColumns = value.elems;
        final List<String> selectedColumnNames = selectedColumns
            .map((elem) => elem.column.id)
            .toList();
        final List<String> otherColumnNames = ItemColumn.allColumns.keys
            .where((id) => !selectedColumnNames.contains(id))
            .toList();

        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: SelectableColumnList(
                selectedColumnNames,
                otherColumnNames,
                setDragging: setDragging,
                dragging: dragging,
              ),
            ),
            Expanded(
              child: SelectedColumnList(
                selectedColumnNames,
                otherColumnNames,
                controller: widget.controller,
                dragging: dragging,
              ),
            ),
          ],
        );
      },
    );
  }
}
