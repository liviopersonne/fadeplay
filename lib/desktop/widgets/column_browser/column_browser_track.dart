import 'package:fadeplay/desktop/objects/column_browser/item_column.dart';
import 'package:fadeplay/desktop/objects/tracks/track.dart';
import 'package:flutter/material.dart';

class BrowserTrack extends StatelessWidget {
  const BrowserTrack({
    super.key,
    required this.track,
    required this.columns,
    required this.separatorWidth,
  });

  final List<ItemColumn> columns;
  final Track track;
  final double separatorWidth;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: columns
          .map(
            (column) => Expanded(
              child: Container(
                color: Colors.blue, // TODO: Get color from theme
                // width: 100, // TODO: Get width from layout
                child: Padding(
                  padding: EdgeInsets.only(
                    left:
                        separatorWidth +
                        3, // TODO: Get extra padding from layout
                  ),
                  child: Text(
                    column.getValue(track),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
