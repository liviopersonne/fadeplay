import 'package:fadeplay/desktop/objects/column_browser/item_column.dart';
import 'package:flutter/material.dart';

class ColumnBrowserHeaders extends StatelessWidget {
  const ColumnBrowserHeaders({
    super.key,
    required this.columns,
    required this.separatorWidth,
  });

  final List<ItemColumn> columns;
  final double separatorWidth;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < columns.length; i++) ...[
          i == 0
              // 1st column with no separator
              ? Expanded(
                  child: ColumnBrowserHeaderLabel(
                    label: columns[i].label,
                    separatorWidth: separatorWidth,
                  ),
                )
              // Other columns
              : Expanded(
                  child: Stack(
                    children: [
                      ColumnBrowserHeaderLabel(
                        label: columns[i].label,
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
      child: Container(
        color: Colors.red, // TODO: Get color from theme
        width: separatorWidth, // TODO: Get separator width from layout
      ),
    );
  }
}
