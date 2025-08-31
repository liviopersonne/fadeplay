import 'package:fadeplay/desktop/objects/column_browser/column_browser_layout.dart';
import 'package:fadeplay/desktop/objects/tracks/track.dart';
import 'package:fadeplay/desktop/widgets/column_browser/column_browser_hotkeys.dart';
import 'package:fadeplay/desktop/widgets/general/color_size_box.dart';
import 'package:fadeplay/desktop/widgets/general/focus_on_click.dart';
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
    return Actions(
      actions: {OpenTrackDetailsIntent: OpenTrackDetailsAction(track: track)},
      child: FocusOnClick(
        builder: (focused) => Row(
          children: [
            for (int i = 0; i < columnLayout.elems.length; i++) ...[
              ColorSizeBox(
                color: focused
                    ? Colors.blue
                    : Colors.blueGrey, // TODO: Get color from theme
                width: columnLayout.elems[i].columnWidth,
                child: Padding(
                  padding: EdgeInsets.only(
                    left:
                        separatorWidth +
                        3, // TODO: Get extra padding from layout
                  ),
                  child: Text(
                    columnLayout.elems[i].column.getValue(track),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
