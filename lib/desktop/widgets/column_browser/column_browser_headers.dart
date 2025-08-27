import 'package:fadeplay/desktop/objects/column_browser/column_browser_layout.dart';
import 'package:flutter/material.dart';

class ColumnBrowserHeaders extends StatelessWidget {
  const ColumnBrowserHeaders({
    super.key,
    required this.columnLayout,
    required this.separatorWidth,
  });

  final ColumnBrowserLayout columnLayout;
  final double separatorWidth;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < columnLayout.elems.length; i++) ...[
          i == 0
              // 1st column with no separator
              ? Expanded(
                  child: ColumnBrowserHeaderLabel(
                    label: columnLayout.elems[i].column.label,
                    separatorWidth: separatorWidth,
                  ),
                )
              // Other columns
              : Expanded(
                  child: Stack(
                    fit: StackFit.passthrough,
                    children: [
                      ColumnBrowserHeaderLabel(
                        label: columnLayout.elems[i].column.label,
                        separatorWidth: separatorWidth,
                      ),
                      ColumnBrowserHeaderSeparator(
                        separatorWidth: separatorWidth,
                      ),
                    ],
                  ),
                ),
        ],
      ],
    );
  }
}

class ColumnBrowserHeaderLabel extends StatelessWidget {
  const ColumnBrowserHeaderLabel({
    super.key,
    required this.label,
    required this.separatorWidth,
  });

  final String label;
  final double separatorWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber, // TODO: Get color from theme
      //width: 100, // TODO: Get width from layout
      child: Padding(
        padding: EdgeInsets.only(
          left: separatorWidth + 3, // TODO: Get extra padding from layout
        ),
        child: Text(label, overflow: TextOverflow.ellipsis),
      ),
    );
  }
}

class ColumnBrowserHeaderSeparator extends StatelessWidget {
  const ColumnBrowserHeaderSeparator({super.key, required this.separatorWidth});

  final double separatorWidth;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      top: 0,
      bottom: 0,
      child: GestureDetector(
        child: Container(
          color: Colors.red, // TODO: Get color from theme
          width: separatorWidth, // TODO: Get separator width from layout
        ),
        onHorizontalDragUpdate: (details) {
          // logger.log(details.toString());
          final delta = details.primaryDelta;
          // delta is:
          // - 0 if no change
          // - -1 if moved to the left
          // - +1 if moved to the right
        },
      ),
    );
  }
}
