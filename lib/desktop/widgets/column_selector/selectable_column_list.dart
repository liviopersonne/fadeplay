import 'package:fadeplay/desktop/objects/column_browser/item_column.dart';
import 'package:fadeplay/desktop/settings/theme.dart';
import 'package:fadeplay/desktop/widgets/general/row_elem.dart';
import 'package:flutter/material.dart';

class SelectableColumnList extends StatelessWidget {
  const SelectableColumnList({
    super.key,
    required this.columns,
    required this.dragNotifier,
  });

  final List<ItemColumn> columns;
  final ValueNotifier<bool> dragNotifier;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: columns.length,
      itemBuilder: (_, i) => RowElem(
        inactiveTextStyle: MyTheme.textStyleNormal,
        activeColor: Colors.pink,
        inactiveColor: Colors.teal,
        draggable: true,
        dragNotifier: dragNotifier,
        draggableData: columns[i],
        draggableText: columns[i].label,
        hoverable: true,
        hoveringCursor: SystemMouseCursors.grab,
        child: Text(columns[i].label),
      ),
    );
  }
}
