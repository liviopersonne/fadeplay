import 'package:fadeplay/desktop/objects/column_browser/column_browser_layout.dart';
import 'package:fadeplay/desktop/widgets/column_browser/column_browser.dart';
import 'package:flutter/material.dart';

class ColumnBrowserHeaders extends StatelessWidget {
  const ColumnBrowserHeaders({
    super.key,
    required this.controller,
    required this.columnLayout,
    required this.separatorWidth,
  });

  final ColumnBrowserController controller;
  final ColumnBrowserLayout columnLayout;
  final double separatorWidth;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < columnLayout.elems.length; i++) ...[
          i == 0
              // 1st column with no separator
              ? ColumnBrowserHeaderLabel(
                  colWithWidth: columnLayout.elems[i],
                  separatorWidth: separatorWidth,
                )
              // Other columns
              : Stack(
                  fit: StackFit.passthrough,
                  children: [
                    ColumnBrowserHeaderLabel(
                      colWithWidth: columnLayout.elems[i],
                      separatorWidth: separatorWidth,
                    ),
                    ColumnBrowserHeaderSeparator(
                      controller: controller,
                      separatorWidth: separatorWidth,
                      index: i,
                      layoutScale: columnLayout.scale,
                    ),
                  ],
                ),
        ],
      ],
    );
  }
}

class ColumnBrowserHeaderLabel extends StatelessWidget {
  const ColumnBrowserHeaderLabel({
    super.key,
    required this.colWithWidth,
    required this.separatorWidth,
  });

  final ColumnWithWidths colWithWidth;
  final double separatorWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber, // TODO: Get color from theme
      width: colWithWidth.columnWidth,
      child: Padding(
        padding: EdgeInsets.only(
          left: separatorWidth + 3, // TODO: Get extra padding from layout
        ),
        child: Text(colWithWidth.column.label, overflow: TextOverflow.ellipsis),
      ),
    );
  }
}

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
    return Positioned(
      left: 0,
      top: 0,
      bottom: 0,
      child: MouseRegion(
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
            // logger.log(details.toString());
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
      ),
    );
  }
}
