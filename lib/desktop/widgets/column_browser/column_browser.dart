import 'package:fadeplay/desktop/objects/logger.dart';
import 'package:fadeplay/desktop/widgets/column_browser/column_browser_headers.dart';
import 'package:fadeplay/desktop/widgets/column_browser/column_browser_track.dart';
import 'package:flutter/material.dart';
import 'package:fadeplay/desktop/objects/tracks/track.dart';
import '../../objects/column_browser/item_column.dart';

final logger = Logging("ColumnBrowser");

class ColumnBrowserController {
  final ValueNotifier<List<Track>> tracks = ValueNotifier([]);
  final ValueNotifier<List<ItemColumn>> columns = ValueNotifier(
    [],
  ); // TODO: Load from settings

  void updateTracks(List<Track> newTracks) {
    logger.debug("Updating tracks (${tracks.value.length} new tracks)");
    tracks.value = newTracks;
  }

  void addTrack(Track newTrack) {
    logger.debug("Adding track ${newTrack.title}");
    tracks.value = List.from(tracks.value)..add(newTrack);
    // the List.from is used so that the list doesn't mutate:
    // the value changes => the notification is sent
  }

  void updateColumns(List<String> newColumns) {
    logger.debug("Updating columns");
    final trackCols = ItemColumn.allColumns;
    final List<ItemColumn> newTrackColumns = [];
    for (var label in newColumns) {
      final col = trackCols[label];
      if (col == null) {
        logger.error("Invalid TrackItemColumn label '$label'");
      } else {
        newTrackColumns.add(col);
      }
    }

    columns.value = newTrackColumns;
  }
}

class ColumnBrowser extends StatefulWidget {
  const ColumnBrowser({
    super.key,
    required this.controller,
    this.separatorWidth = 2, // TODO: Get separator width from layout
  });

  final ColumnBrowserController controller;
  final double separatorWidth;

  @override
  State<ColumnBrowser> createState() => _ColumnBrowserState();
}

class _ColumnBrowserState extends State<ColumnBrowser> {
  @override
  Widget build(BuildContext context) {
    logger.debug(
      "Building ColumnBrowser with columns '${widget.controller.columns}'",
    );
    return ValueListenableBuilder<List<ItemColumn>>(
      valueListenable: widget.controller.columns,
      builder: (context, columns, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: [
            ColumnBrowserHeaders(
              columns: columns,
              separatorWidth: widget.separatorWidth,
            ),

            Expanded(
              child: ValueListenableBuilder<List<Track>>(
                valueListenable: widget.controller.tracks,
                builder: (context, trackList, child) {
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: trackList.length,
                    itemBuilder: (context, index) => BrowserTrack(
                      track: trackList[index],
                      columns: columns,
                      separatorWidth: widget.separatorWidth,
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
