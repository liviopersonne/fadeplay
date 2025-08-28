import 'package:fadeplay/desktop/objects/column_browser/column_browser_layout.dart';
import 'package:fadeplay/desktop/objects/column_browser/item_column.dart';
import 'package:fadeplay/desktop/widgets/column_browser/column_browser.dart';
import 'package:fadeplay/desktop/widgets/general/hoverable_text.dart';
import 'package:flutter/material.dart';

class ColumnSelector extends StatefulWidget {
  ColumnSelector({super.key, required this.controller});

  final List<String> allColumns = ItemColumn.allColumns.keys.toList();
  final ColumnBrowserController controller;

  @override
  State<ColumnSelector> createState() => _ColumnSelectorState();
}

class _ColumnSelectorState extends State<ColumnSelector> {
  @override
  Widget build(BuildContext context) {
    // TODO: Bring that back
    // final List<ColumnWithWidths> selectedColumns =
    //     widget.controller.columnsLayout.value.elems;
    // final List<String> selectedColumnNames = selectedColumns
    //     .map((elem) => elem.column.id)
    //     .toList();
    // final List<String> otherColumnNames = ItemColumn.allColumns.keys
    //     .where((id) => !selectedColumnNames.contains(id))
    //     .toList();

    final List<String> selectedColumnNames = List.generate(
      10,
      (index) => "Column $index",
    );
    final List<String> otherColumnNames = List.generate(
      10,
      (index) => "Column ${index + 10}",
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.max,
      children: [
        SelectableColumnList(selectedColumnNames, otherColumnNames),
        ActiveColumnList(selectedColumnNames, otherColumnNames),
      ],
    );
  }
}

class SelectableColumnList extends StatefulWidget {
  const SelectableColumnList(this.selected, this.other, {super.key});

  final List<String> selected;
  final List<String> other;

  @override
  State<SelectableColumnList> createState() => _SelectableColumnListState();
}

class _SelectableColumnListState extends State<SelectableColumnList> {
  bool dragging = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: widget.other.length,
        itemBuilder: (context, index) => Draggable(
          onDragStarted: () {
            setState(() {
              dragging = true;
            });
          },
          onDragEnd: (_) {
            setState(() {
              dragging = false;
            });
          },
          feedback: Material(child: Text(widget.other[index])),
          childWhenDragging: Text(widget.other[index]),
          child: dragging
              ? Text(widget.other[index])
              : HoverableText(
                  text: widget.other[index],
                  backgroundActive: Colors.lightBlue,
                  hoveringCursor: SystemMouseCursors.click,
                ),
        ),
      ),
    );
  }
}

class ActiveColumnList extends StatelessWidget {
  const ActiveColumnList(this.selected, this.other, {super.key});

  final List<String> selected;
  final List<String> other;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: selected.length,
        itemBuilder: (context, index) => Text(selected[index]),
      ),
    );
  }
}
