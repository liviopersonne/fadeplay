import 'package:fadeplay/desktop/objects/column_browser/item_column.dart';
import 'package:fadeplay/desktop/objects/logger.dart';

final logger = Logging("ColumnBrowserLayout");

/// Element of a layout that maps a column to its corresponding width and minimum width
class ColumnWithWidth {
  final ItemColumn column;
  double columnWidth;

  ColumnWithWidth({required this.column, double? columnWidth})
    : columnWidth = columnWidth ?? column.defaultWidth {
    checkWidth();
  }

  ColumnWithWidth.fromId({required String columnId, double? columnWidth})
    : column = ItemColumn.allColumns[columnId]!,
      columnWidth =
          columnWidth ?? ItemColumn.allColumns[columnId]!.defaultWidth {
    checkWidth();
  }

  /// Checks that the column is bigger than the minimum width, and grows it if not
  void checkWidth() {
    if (columnWidth < column.minWidth) {
      logger.warn(
        "Column $column was loaded with a smaller width than minimal: $columnWidth -> ${column.minWidth}. Growing it to minimum size.",
      );
      columnWidth = column.minWidth;
    }
  }
}

/// Layout for a column browser which dictates the columns and their respective sizes
class ColumnBrowserLayout {
  final List<ColumnWithWidth> elems;

  /// The sum of the widths of each column
  final double _totalWidth;

  /// The scale at which the layout is shown (see adaptedToWidth)
  double scale = 1;

  /// Wether or not some columns have been cropped
  bool isCropped = false;

  ColumnBrowserLayout({required this.elems})
    : _totalWidth = elems.fold(
        0,
        (double prev, elem) => prev + elem.columnWidth,
      );

  /// Special constructor used for copying
  ColumnBrowserLayout._initWithWidth({
    required this.elems,
    required double totalWidth,
  }) : _totalWidth = totalWidth;

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
          .map((col) => ColumnWithWidth(column: col))
          .toList(),
    );
  }

  /// Create a copy of an existing layout
  static ColumnBrowserLayout copy(ColumnBrowserLayout layout) {
    final List<ColumnWithWidth> newElems = List.from(layout.elems);

    for (int i = 0; i < newElems.length; i++) {
      final oldCol = layout.elems[i];
      newElems[i] = ColumnWithWidth(
        column: oldCol.column,
        columnWidth: oldCol.columnWidth,
      );
    }

    return ColumnBrowserLayout._initWithWidth(
      elems: newElems,
      totalWidth: layout._totalWidth,
    );
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
    if (newValue1 < col1.column.minWidth || newValue2 < col2.column.minWidth) {
      return;
    }

    col1.columnWidth = newValue1;
    col2.columnWidth = newValue2;
  }

  /// Adapts the layout to the width of space available `maxWidth`
  ///
  /// This works by making all the columns disappear from right to left if they don't all fit
  ///
  /// If the layout takes less spae than needed, we expand every column by a specific factor
  ColumnBrowserLayout adaptedToWidth(double maxWidth) {
    final adaptedLayout = copy(this);
    if (_totalWidth <= maxWidth) {
      // we can expand the layout to make it fit
      final ratio = maxWidth / _totalWidth;
      for (var elem in adaptedLayout.elems) {
        elem.columnWidth *= ratio;
      }
      adaptedLayout.scale = ratio;
    } else {
      // we need to delete or shrink some columns to make it fit

      double remainder = _totalWidth - maxWidth; // what remains to be deleted

      while (remainder > 0) {
        final lastElem = adaptedLayout.elems.last;
        final lastElemRemainder =
            lastElem.columnWidth - lastElem.column.minWidth;

        if (lastElemRemainder > remainder) {
          // we can just shrink the last column
          lastElem.columnWidth -= remainder;
          remainder = 0;
        } else {
          // we have to delete the last column
          remainder -= lastElem.columnWidth;
          adaptedLayout.elems.removeLast();
          adaptedLayout.isCropped = true;
        }
      }

      adaptedLayout.elems.last.columnWidth -= remainder;
    }
    return adaptedLayout;
  }

  /// Inserts the `columnId` column at `index`
  void insertColumn({required String columnId, required int index}) {
    if (!logger.check(
      index >= 0 && index <= elems.length,
      message: "Invalid index reached when adding column",
    )) {
      return;
    }

    elems.insert(index, ColumnWithWidth.fromId(columnId: columnId));
  }

  /// Removes the `columnId` column
  void removeColumn({required int index}) {
    if (!logger.check(
      index >= 0 && index <= elems.length,
      message: "Invalid index reached when adding column",
    )) {
      return;
    }

    elems.removeAt(index);
  }
}
