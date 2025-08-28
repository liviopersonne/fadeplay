import 'package:fadeplay/desktop/objects/column_browser/column_browser_layout.dart';
import 'package:fadeplay/desktop/objects/column_browser/item_column.dart';
import 'package:fadeplay/desktop/widgets/column_browser/column_browser.dart';
import 'package:fadeplay/desktop/widgets/general/hoverable.dart';
import 'package:flutter/material.dart';

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
            SelectableColumnList(
              selectedColumnNames,
              otherColumnNames,
              setDragging: setDragging,
              dragging: dragging,
            ),
            ActiveColumnList(
              selectedColumnNames,
              otherColumnNames,
              controller: widget.controller,
              dragging: dragging,
            ),
          ],
        );
      },
    );
  }
}

class SelectableColumnList extends StatefulWidget {
  const SelectableColumnList(
    this.selected,
    this.other, {
    super.key,
    required this.setDragging,
    required this.dragging,
  });

  final List<String> selected;
  final List<String> other;
  final void Function(bool) setDragging;
  final bool dragging;

  @override
  State<SelectableColumnList> createState() => _SelectableColumnListState();
}

class _SelectableColumnListState extends State<SelectableColumnList> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: widget.other.length,
        itemBuilder: (context, index) => Draggable<String>(
          data: widget.other[index],
          onDragStarted: () => widget.setDragging(true),
          onDragEnd: (_) => widget.setDragging(false),
          feedback: Material(child: Text(widget.other[index])),
          childWhenDragging: Text(widget.other[index]),
          child: widget.dragging
              ? Text(widget.other[index])
              : Hoverable(
                  hoveredWidget: Container(
                    color: Colors.lightBlue,
                    child: Text(widget.other[index]),
                  ),
                  unhoveredWidget: Text(widget.other[index]),
                  hoveringCursor: SystemMouseCursors.grab,
                ),
        ),
      ),
    );
  }
}

class ActiveColumnList extends StatefulWidget {
  const ActiveColumnList(
    this.selected,
    this.other, {
    super.key,
    required this.controller,
    required this.dragging,
  });

  final List<String> selected;
  final List<String> other;
  final ColumnBrowserController controller;
  final bool dragging;

  @override
  State<ActiveColumnList> createState() => _ActiveColumnListState();
}

class _ActiveColumnListState extends State<ActiveColumnList> {
  /// Index of the item that's being hovered
  int? hoveringIndex;

  Widget baseWidget({required String content}) => Text(content);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        scrollDirection: Axis.vertical,
        itemCount: widget.selected.length + 1,

        // exchanged separator and item to have separators at the edges
        separatorBuilder: (context, index) => widget.dragging
            ? baseWidget(content: widget.selected[index])
            : GestureDetector(
                child: Hoverable(
                  hoveringCursor: SystemMouseCursors.click,
                  unhoveredWidget: baseWidget(content: widget.selected[index]),
                  hoveredWidget: Container(
                    color: Colors.blue,
                    child: baseWidget(content: widget.selected[index]),
                  ),
                ),
                onTap: () {
                  widget.controller.removeColumn(index: index);
                },
              ),
        itemBuilder: (context, index) => DragTarget<String>(
          onWillAcceptWithDetails: (_) {
            setState(() => hoveringIndex = index);
            return true;
          },
          onLeave: (_) => setState(() => hoveringIndex = null),
          onAcceptWithDetails: (details) => {
            setState(() => hoveringIndex = null),
            widget.controller.insertColumn(
              columnId: details.data,
              index: index,
            ),
          },
          builder: (context, candidateData, rejectedData) => Container(
            color: hoveringIndex == index ? Colors.white : Colors.red,
            height: 5,
          ),
        ),
      ),
    );
  }
}
