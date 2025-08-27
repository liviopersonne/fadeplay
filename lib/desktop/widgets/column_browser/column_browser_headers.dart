import 'package:fadeplay/desktop/objects/column_browser/item_column.dart';
import 'package:flutter/material.dart';

class ColumnBrowserHeaders extends StatelessWidget {
  const ColumnBrowserHeaders({super.key, required this.columns});

  final List<ItemColumn> columns;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: columns
          .map(
            (column) => Expanded(
              child: Stack(
                children: [
                  ColumnBrowserHeaderLabel(label: column.label),
                  ColumnBrowserHeaderSeparator(),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class ColumnBrowserHeaderLabel extends StatelessWidget {
  const ColumnBrowserHeaderLabel({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber, // TODO: Get color from theme
      //width: 100, // TODO: Get width from layout
      child: Padding(
        padding: const EdgeInsets.only(
          left: 8, // TODO: Get padding from layout
        ),
        child: Text(label, overflow: TextOverflow.ellipsis),
      ),
    );
  }
}

class ColumnBrowserHeaderSeparator extends StatelessWidget {
  const ColumnBrowserHeaderSeparator({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      top: 0,
      bottom: 0,
      child: Container(
        color: Colors.red, // TODO: Get color from theme
        width: 5, // TODO: Get separator width from layout
      ),
    );
  }
}
