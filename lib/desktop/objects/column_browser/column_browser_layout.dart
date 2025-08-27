import 'dart:math';

import 'package:fadeplay/desktop/objects/column_browser/item_column.dart';
import 'package:fadeplay/desktop/objects/logger.dart';
import 'package:fadeplay/desktop/settings/settings.dart';

final logger = Logging("ColumnBrowserLayout");

/// Layout that maps the column to its corresponding width
class ColumnWithWidths {
  final ItemColumn column;
  late final double columnWidth;
  final double minColumnWidth;

  ColumnWithWidths({
    required this.column,
    double? columnWidth,
    double? minColumnWidth,
  }) : minColumnWidth = ((minColumnWidth ?? 0) > 0)
           ? minColumnWidth!
           : Settings.minColumnWidth {
    columnWidth = max(columnWidth ?? 0, this.minColumnWidth);
  }
}

class ColumnBrowserLayout {
  List<ColumnWithWidths> elems;

  ColumnBrowserLayout({required this.elems});

  static ColumnBrowserLayout fromIds(List<String> columnIds) {
    final allCols = ItemColumn.allColumns;
    final List<ItemColumn> newTrackColumns = [];
    for (String id in columnIds) {
      final col = allCols[id];
      if (col == null) {
        logger.error("Invalid ItemColumn id '$id'");
      } else {
        newTrackColumns.add(col);
      }
    }
    return ColumnBrowserLayout(
      elems: newTrackColumns
          .map((col) => ColumnWithWidths(column: col))
          .toList(),
    );
  }
}
