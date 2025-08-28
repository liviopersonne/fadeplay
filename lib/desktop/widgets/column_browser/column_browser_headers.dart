import 'package:fadeplay/desktop/objects/column_browser/column_browser_layout.dart';
import 'package:fadeplay/desktop/objects/logger.dart';
import 'package:fadeplay/desktop/settings/theme.dart';
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

    for (int i = 0; i <= columnLayout.elems.length; i++) {
      // add dragTargets
      stackContent.addAll([
        ColumnBrowserHeaderDragTarget(
          dragTargetWidth: dragTargetWidth,
          offset: currentOffset,
          controller: controller,
          separatorWidth: separatorWidth,
          index: i,
          layoutScale: columnLayout.scale,
          // first and last columns has no separator
          withSeparator: i > 0 && i < columnLayout.elems.length,
        ),
      ]);

      // add column labels
      if (i < columnLayout.elems.length) {
        rowContent.add(
          ColumnBrowserHeaderLabel(
            colWithWidth: columnLayout.elems[i],
            separatorWidth: separatorWidth,
            index: i,
          ),
        );
        currentOffset += columnLayout.elems[i].columnWidth;
      }
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
    required this.index,
  });

  final ColumnWithWidths colWithWidth;
  final double separatorWidth;
  final int index;

  Widget titleContainer({required Color color}) => Container(
    color: color,
    width: colWithWidth.columnWidth,
    child: Padding(
      padding: EdgeInsets.only(
        left: separatorWidth + MyTheme.headerLabelPadding,
      ),
      child: Text(colWithWidth.column.label, overflow: TextOverflow.ellipsis),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Draggable<int>(
      data: index,
      feedback: Container(
        color: MyTheme.headerDraggingColor,
        child: Text(
          colWithWidth.column.label,
          style: MyTheme
              .headerDraggingTextStyle, // TODO: Make the column just move on the x axis
        ),
      ),
      childWhenDragging: titleContainer(color: MyTheme.headerSecondaryColor),
      child: titleContainer(color: MyTheme.headerBaseColor),
    );
  }
}

/// The part between the column headers where you can drop a column to move it
class ColumnBrowserHeaderDragTarget extends StatefulWidget {
  const ColumnBrowserHeaderDragTarget({
    super.key,
    required this.offset,
    required this.dragTargetWidth,
    required this.controller,
    required this.separatorWidth,
    required this.index,
    required this.layoutScale,
    required this.withSeparator,
  });

  final double offset;
  final double dragTargetWidth;
  final ColumnBrowserController controller;
  final double separatorWidth;
  final int index;
  final double layoutScale;
  final bool withSeparator;

  @override
  State<ColumnBrowserHeaderDragTarget> createState() =>
      _ColumnBrowserHeaderDragTargetState();
}

class _ColumnBrowserHeaderDragTargetState
    extends State<ColumnBrowserHeaderDragTarget> {
  bool dragHovering = false;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.offset - widget.dragTargetWidth / 2,
      top: 0,
      bottom: 0,
      child: DragTarget<int>(
        onWillAcceptWithDetails: (details) {
          final indexDifference = widget.index - details.data;
          final rep = indexDifference != 0 && indexDifference != 1;
          logger.debug(
            "Hover index difference: $indexDifference, ${rep ? 'Accepted' : 'Not Accepted'}",
          );
          if (rep) {
            setState(() {
              dragHovering = true;
            });
          }
          return rep;
        },
        onLeave: (data) {
          logger.debug("Hover left zone");
          setState(() {
            dragHovering = false;
          });
        },
        onAcceptWithDetails: (details) {
          logger.debug("Accepted hover with ${details.data}");
          setState(() {
            dragHovering = false;
          });
          widget.controller.insertDraggedColumn(
            colIndex: details.data,
            separatorIndex: widget.index,
          );
        },
        builder: (context, candidateData, rejectedData) => Container(
          color: dragHovering
              ? Colors.white
              : null, // make the target appear only when I'm dragging over it
          width: widget.dragTargetWidth,
          child: widget.withSeparator && !dragHovering
              ? Center(
                  // The separator is inside the drag target so you can
                  // correctly drop columns inside the separator
                  child: ColumnBrowserHeaderSeparator(
                    controller: widget.controller,
                    separatorWidth: widget.separatorWidth,
                    index: widget.index,
                    layoutScale: widget.layoutScale,
                  ),
                )
              : null, // hide the separator if I'm dragging a column here
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
