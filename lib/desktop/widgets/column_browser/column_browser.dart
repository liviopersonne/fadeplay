import 'package:fadeplay/desktop/objects/logger.dart';
import 'package:fadeplay/desktop/widgets/column_browser/column_browser_headers.dart';
import 'package:fadeplay/desktop/widgets/column_browser/column_browser_track.dart';
import 'package:flutter/material.dart';
import 'package:fadeplay/desktop/objects/tracks/track.dart';
import '../../objects/column_browser/item_column.dart';

final logger = Logging("ColumnBrowser");

class ColumnBrowserController extends ChangeNotifier {
  List<Track> tracks = [];
  List<ItemColumn> columns = []; // TODO: Load from settings

  void updateTracks(List<Track> newTracks) {
    tracks = newTracks;
    notifyListeners();
  }

  void updateColumns(List<String> newColumns) {
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

    columns = newTrackColumns;
    notifyListeners();
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.max,
      children: [
        ColumnBrowserHeaders(
          columns: widget.controller.columns,
          separatorWidth: widget.separatorWidth,
        ),

        Expanded(
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: widget.controller.tracks.length,
            itemBuilder: (context, index) => BrowserTrack(
              track: widget.controller.tracks[index],
              columns: widget.controller.columns,
              separatorWidth: widget.separatorWidth,
            ),
          ),
        ),
      ],
    );
  }
}
