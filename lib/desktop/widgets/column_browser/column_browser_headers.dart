import 'package:fadeplay/desktop/objects/column_browser/column_browser_layout.dart';
import 'package:fadeplay/desktop/objects/logger.dart';
import 'package:fadeplay/desktop/widgets/column_browser/column_browser.dart';
import 'package:flutter/material.dart';

final logger = Logging("ColumnBrowserHeaders");

/// The full header row on top of a ColumnBrowser. With it you can
/// - Exchange the position of 2 columns with drag and drop
/// - Change the size of the columns by dragging the separator
class ColumnBrowserHeaders extends StatelessWidget {
  const ColumnBrowserHeaders({
    super.key,
    required this.controller,
    required this.columnLayout,
    required this.separatorWidth,
    required this.dragTargetWidth,
  });

  final ColumnBrowserController controller;
  final ColumnBrowserLayout columnLayout;
  final double separatorWidth;
  final double dragTargetWidth;

  @override
  Widget build(BuildContext context) {
    final List<Widget> rowContent = [];
    final List<Widget> stackContent = [];
    double currentOffset = 0;

    for (int i = 0; i < columnLayout.elems.length; i++) {
      rowContent.add(
        ColumnBrowserHeaderLabel(
          colWithWidth: columnLayout.elems[i],
          separatorWidth: separatorWidth,
        ),
      );

      if (i != 0) {
        // 1st column has no separator
        stackContent.addAll([
          ColumnBrowserHeaderDragTarget(
            dragTargetWidth: dragTargetWidth,
            offset: currentOffset,
            controller: controller,
            separatorWidth: separatorWidth,
            index: i,
            layoutScale: columnLayout.scale,
          ),
        ]);
      }

      currentOffset += columnLayout.elems[i].columnWidth;
    }

    return Stack(
      fit: StackFit.passthrough,
      children: [
        Row(children: rowContent),
        ...stackContent,
      ],
    );
  }
}

/// The text part of the column header
class ColumnBrowserHeaderLabel extends StatelessWidget {
  const ColumnBrowserHeaderLabel({
    super.key,
    required this.colWithWidth,
    required this.separatorWidth,
  });

  final ColumnWithWidths colWithWidth;
  final double separatorWidth;

  Widget titleContainer({required Color color}) => Container(
    color: color,
    width: colWithWidth.columnWidth,
    child: Padding(
      padding: EdgeInsets.only(
        left: separatorWidth + 3, // TODO: Get extra padding from layout
      ),
      child: Text(colWithWidth.column.label, overflow: TextOverflow.ellipsis),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Draggable<int>(
      // TODO: Normalize all this UI with themes
      data: 42,
      feedback: Container(
        color: Colors.deepPurple,
        child: Text(
          colWithWidth.column.label,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.normal,
            decoration: TextDecoration.none,
            fontSize: 24,
          ), // TODO: Make the column just move on the x axis
        ),
      ),
      childWhenDragging: titleContainer(color: Colors.grey),
      child: titleContainer(color: Colors.amber),
    );
  }
}

/// The part between the column headers where you can drop a column to move it
class ColumnBrowserHeaderDragTarget extends StatelessWidget {
  const ColumnBrowserHeaderDragTarget({
    super.key,
    required this.offset,
    required this.dragTargetWidth,
    required this.controller,
    required this.separatorWidth,
    required this.index,
    required this.layoutScale,
  });

  final double offset;
  final double dragTargetWidth;
  final ColumnBrowserController controller;
  final double separatorWidth;
  final int index;
  final double layoutScale;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: offset - dragTargetWidth / 2,
      top: 0,
      bottom: 0,
      child: DragTarget<int>(
        onAcceptWithDetails: (details) {
          logger.log(
            "Accepted with ${details.data}",
          ); // TODO: Actually implement column swapping
        },
        builder: (context, candidateData, rejectedData) => Container(
          color: Colors.green, // TODO: Make this appear only when I'm dragging
          width: dragTargetWidth,
          child: Center(
            // The separator is inside the drag target so you can
            // correctly drop columns inside the separator
            child: ColumnBrowserHeaderSeparator(
              controller: controller,
              separatorWidth: separatorWidth,
              index: index,
              layoutScale: layoutScale,
            ),
          ),
        ),
      ),
    );
  }
}

/// The part between the column headers that you can drag to change the column's size
class ColumnBrowserHeaderSeparator extends StatelessWidget {
  const ColumnBrowserHeaderSeparator({
    super.key,
    required this.controller,
    required this.separatorWidth,
    required this.index,
    required this.layoutScale,
  });

  final ColumnBrowserController controller;
  final double separatorWidth;
  final int index;
  final double layoutScale;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.resizeLeftRight,
      child: GestureDetector(
        child: Container(
          color: Colors.red, // TODO: Get color from theme
          width: separatorWidth, // TODO: Get separator width from layout
        ),
        onTap: () {
          SystemMouseCursors.resizeLeftRight;
        },
        onHorizontalDragUpdate: (details) {
          final delta = details.primaryDelta;
          // delta is:
          // - 0 if no change
          // - -1 if moved to the left
          // - +1 if moved to the right
          if (delta != null) {
            controller.incrementColumnSize(
              colIndex: index,
              delta: delta / layoutScale, // division to counteract scaling
            );
          }
        },
      ),
    );
  }
}
