import 'package:fadeplay/desktop/objects/column_browser/item_column.dart';
import 'package:fadeplay/desktop/objects/tracks/track.dart';
import 'package:flutter/material.dart';

class BrowserTrack extends StatelessWidget {
  const BrowserTrack({super.key, required this.track, required this.columns});

  final List<ItemColumn> columns;
  final Track track;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: columns
          .map(
            (column) => Expanded(
              child: Container(
                color: Colors.blue, // TODO: Get color from theme
                // width: 100, // TODO: Get width from layout
                child: Text(
                  column.getValue(track),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
