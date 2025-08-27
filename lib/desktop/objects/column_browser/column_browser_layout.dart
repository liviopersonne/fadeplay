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

  /// Create a copy of an existing layout
  static ColumnBrowserLayout copy(ColumnBrowserLayout layout) {
    final List<ColumnWithWidths> newElems = List.from(layout.elems);

    for (int i = 0; i < newElems.length; i++) {
      final oldCol = layout.elems[i];
      newElems[i] = ColumnWithWidths(
        column: oldCol.column,
        columnWidth: oldCol.columnWidth,
        minColumnWidth: oldCol.minColumnWidth,
      );
    }

    return ColumnBrowserLayout(elems: newElems);
  }

  /// Adds or substracts an amount `delta` to the column at index `colIndex`
  void incrementColumnSize({required int colIndex, required double delta}) {
    if (!logger.check(
      colIndex > 0 && colIndex < elems.length,
      message: "Incrementing a column size of invalid index '$colIndex'",
      // note that we can't modify column 0 because there isn't supposed to be a separator
    )) {
      return;
    }

    final col1 = elems[colIndex];
    final col2 = elems[colIndex - 1];
    final newValue1 = col1.columnWidth - delta;
    final newValue2 = col2.columnWidth + delta;

    // check that I don't go under the minimum width
    if (newValue1 < col1.minColumnWidth || newValue2 < col2.minColumnWidth) {
      return;
    }

    col1.columnWidth = newValue1;
    col2.columnWidth = newValue2;
  }
}
