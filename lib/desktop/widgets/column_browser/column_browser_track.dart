import 'package:fadeplay/desktop/objects/column_browser/column_browser_layout.dart';
import 'package:fadeplay/desktop/objects/tracks/track.dart';
import 'package:flutter/material.dart';

class BrowserTrack extends StatelessWidget {
  const BrowserTrack({
    super.key,
    required this.track,
    required this.columnLayout,
    required this.separatorWidth,
  });

  final ColumnBrowserLayout columnLayout;
  final Track track;
  final double separatorWidth;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: columnLayout.elems
          .map(
            (elems) => Expanded(
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
                    elems.column.getValue(track),
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
