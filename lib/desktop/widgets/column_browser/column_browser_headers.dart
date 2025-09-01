import 'package:fadeplay/desktop/objects/column_browser/column_browser_layout.dart';
import 'package:fadeplay/desktop/objects/logger.dart';
import 'package:fadeplay/desktop/settings/theme.dart';
import 'package:fadeplay/desktop/widgets/column_browser/column_browser.dart';
import 'package:fadeplay/desktop/widgets/column_selector/column_selector.dart';
import 'package:fadeplay/desktop/widgets/general/color_size_box.dart';
import 'package:fadeplay/desktop/widgets/menus/anchored_menu.dart';
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
    final MenuController menuController = MenuController();
    final List<Widget> rowContent = [];
    final List<Widget> stackContent = [];
    double currentOffset = 0;

    for (int i = 0; i <= columnLayout.elems.length; i++) {
      // add dragTargets
      stackContent.add(
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
      );

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

    return AnchoredMenu(
      menuController: menuController,
      width: 200,
      menuItems: {
        "Select Columns": () =>
            ColumnSelector(controller: controller).showAsDialog(context),
      },
      child: GestureDetector(
        onSecondaryTapDown: (details) => menuController.isOpen
            ? menuController.close()
            : menuController.open(position: details.localPosition),
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            Row(children: rowContent),
            ...stackContent,
            if (columnLayout.isCropped) CroppedColumnsIndicator(),
          ],
        ),
      ),
    );
  }
}

class CroppedColumnsIndicator extends StatelessWidget {
  const CroppedColumnsIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: MyTheme.paddingTiny,
      top: 0,
      bottom: 0,
      child: Text("->"),
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

  final ColumnWithWidth colWithWidth;
  final double separatorWidth;
  final int index;

  Widget titleContainer({Color? color}) => ColorSizeBox(
    color: color,
    width: colWithWidth.columnWidth,
    child: Padding(
      padding: EdgeInsets.only(left: separatorWidth + MyTheme.paddingTiny),
      child: Text(colWithWidth.column.label, overflow: TextOverflow.ellipsis),
    ),
  );

  Widget draggedTitleContainer({Color? color}) => Material(
    color: color,
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: MyTheme.paddingTiny),
      child: Text(colWithWidth.column.label, overflow: TextOverflow.ellipsis),
    ),
  );

  @override
  Widget build(BuildContext context) => Draggable<int>(
    hitTestBehavior: HitTestBehavior.translucent,
    dragAnchorStrategy: (draggable, context, position) {
      // centers the draggable on the mouse when dragging starts
      final child = childDragAnchorStrategy(draggable, context, position);
      return Offset(10, child.dy);
    },
    axis: Axis.horizontal,
    data: index,
    feedback: draggedTitleContainer(color: MyTheme.headerDraggingColor),
    childWhenDragging: titleContainer(color: MyTheme.headerSecondaryColor),
    child: titleContainer(color: MyTheme.headerBaseColor),
  );
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
          if (rep) {
            setState(() => dragHovering = true);
          }
          return rep;
        },
        onLeave: (data) {
          setState(() => dragHovering = false);
        },
        onAcceptWithDetails: (details) {
          logger.debug("Accepted hover with ${details.data}");
          setState(() => dragHovering = false);
          widget.controller.insertDraggedColumn(
            colIndex: details.data,
            separatorIndex: widget.index,
          );
        },
        builder: (context, candidateData, rejectedData) => ColorSizeBox(
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
      cursor: SystemMouseCursors.resizeColumn,
      child: GestureDetector(
        child: ColorSizeBox(
          color: Colors.red, // TODO: Get color from theme
          width: separatorWidth, // TODO: Get separator width from layout
          height: double.infinity,
        ),
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
