import 'dart:math';

import 'package:fadeplay/desktop/objects/column_browser/item_column.dart';
import 'package:fadeplay/desktop/objects/logger.dart';
import 'package:fadeplay/desktop/settings/settings.dart';

final logger = Logging("ColumnBrowserLayout");

/// Element of a layout that maps a column to its corresponding width and minimum width
class ColumnWithWidths {
  final ItemColumn column;
  late double columnWidth;
  double minColumnWidth;

  ColumnWithWidths({
    required this.column,
    double? columnWidth,
    double? minColumnWidth,
  }) : minColumnWidth = ((minColumnWidth ?? 0) > 0)
           ? minColumnWidth!
           : Settings.minColumnWidth,
       columnWidth =
           columnWidth ??
           100 // TODO: Hard coded value
           {
    columnWidth = max(
      this.columnWidth,
      this.minColumnWidth,
    ); // FIXME: This isn't working
  }
}

/// Layout for a column browser which dictates the columns and their respective sizes
class ColumnBrowserLayout {
  List<ColumnWithWidths> elems;

  ColumnBrowserLayout({required this.elems});

  /// Returns a basic layout where the columns are chosen by the ids passed
  ///
  /// All columns will have a default width equal to `Settings.minColumnWidth`
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

  ColumnBrowserLayout copy() {
    return ColumnBrowserLayout(elems: List.from(elems));
  }

  /// Adds or substracts an amount `delta` to the column at index `colIndex`
  ColumnBrowserLayout incrementedColumnSize({
    required int colIndex,
    required double delta,
  }) {
    // TODO: Check if it's possible to do this without having to instanciate a new object
    if (!logger.check(
      colIndex > 0 && colIndex < elems.length,
      message: "Incrementing a column size of invalid index '$colIndex'",
      // note that we can't modify column 0 because there isn't supposed to be a separator
    )) {
      this;
    }

    final List<ColumnWithWidths> newElems = List.from(elems);
    final oldCol1 = elems[colIndex];
    final oldCol2 = elems[colIndex - 1];

    if (oldCol1.columnWidth - delta < oldCol1.minColumnWidth ||
        oldCol2.columnWidth + delta < oldCol2.minColumnWidth) {
      // we don't want to go under a column's minimum size
      return this;
    }

    newElems[colIndex] = ColumnWithWidths(
      column: oldCol1.column,
      columnWidth: oldCol1.columnWidth - delta,
      minColumnWidth: oldCol1.minColumnWidth,
    );

    newElems[colIndex - 1] = ColumnWithWidths(
      column: oldCol2.column,
      columnWidth: oldCol2.columnWidth + delta,
      minColumnWidth: oldCol2.minColumnWidth,
    );

    return ColumnBrowserLayout(elems: newElems);
  }
}
