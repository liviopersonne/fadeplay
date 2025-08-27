import 'package:fadeplay/desktop/objects/logger.dart';
import 'package:flutter/material.dart';
import 'package:fadeplay/desktop/objects/tracks/track.dart';
import '../../objects/columns/item_column.dart';

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
  const ColumnBrowser({super.key, required this.controller});

  final ColumnBrowserController controller;

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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: widget.controller.columns
              .map(
                (column) => Container(
                  color: Colors.amber, // TODO: Get color from theme
                  width: 100, // TODO: Get width from layout
                  child: Text(column.label, overflow: TextOverflow.ellipsis),
                ),
              )
              .toList(),
        ),

        Expanded(
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: widget.controller.tracks.length,
            itemBuilder: (context, index) => Row(
              children: widget.controller.columns
                  .map(
                    (column) => Container(
                      color: Colors.blue, // TODO: Get color from theme
                      width: 100, // TODO: Get width from layout
                      child: Text(
                        column.getValue(widget.controller.tracks[index]),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
