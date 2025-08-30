import 'package:fadeplay/desktop/objects/column_browser/item_column.dart';
import 'package:fadeplay/desktop/settings/theme.dart';
import 'package:fadeplay/desktop/widgets/general/column_elem.dart';
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
    return Column(
      children: [
        Container(
          color: MyTheme.colorBackgroundLight,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(
            horizontal: MyTheme.paddingBig,
            vertical: MyTheme.paddingSmall,
          ),
          child: Text("Selectable fields", style: MyTheme.textStyleTitle),
        ),
        Expanded(
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: columns.length,
            itemBuilder: (_, i) => ColumnElem(
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
          ),
        ),
      ],
    );
  }
}
