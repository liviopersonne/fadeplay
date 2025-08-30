import 'package:fadeplay/desktop/objects/column_browser/item_column.dart';
import 'package:fadeplay/desktop/settings/theme.dart';
import 'package:fadeplay/desktop/widgets/column_browser/column_browser.dart';
import 'package:fadeplay/desktop/widgets/general/column_elem.dart';
import 'package:fadeplay/desktop/widgets/general/hoverable_drag_target.dart';
import 'package:fadeplay/desktop/widgets/general/overlayed_list.dart';
import 'package:flutter/material.dart';

class SelectedColumnList extends StatelessWidget {
  const SelectedColumnList({
    super.key,
    required this.controller,
    required this.columns,
    required this.dragNotifier,
  });

  final ColumnBrowserController controller;
  final List<ItemColumn> columns;
  final ValueNotifier<bool> dragNotifier;

  @override
  Widget build(BuildContext context) {
    return OverlayedList(
      direction: Axis.vertical,
      itemCount: columns.length,
      edgeSeparators: true,
      scrollingEnabled: false,
      itemSizes: (_) => ColumnElem.getHeight(MyTheme.textStyleNormal),
      separatorSizes: (_) => 20,
      itemBuilder: (_, i) => ColumnElem(
        inactiveTextStyle: MyTheme.textStyleNormal,
        activeColor: Colors.pink,
        inactiveColor: Colors.teal,
        clickable: true,
        onTap: () => controller.removeColumn(index: i),
        hoverable: true,
        hoveringCursor: SystemMouseCursors.click,
        dragNotifier: dragNotifier,
        child: Text(columns[i].label),
      ),
      separatorBuilder: (_, i) => HoverableDragTarget<ItemColumn>(
        size: HoverableDragTargetSize.listSeparator(
          listDirection: Axis.vertical,
          fullSize: 20,
          visibleSize: 3,
        ),
        onAcceptWithDetails: (details) =>
            controller.insertColumn(columnId: details.data.id, index: i + 1),
      ),
    );
  }
}
