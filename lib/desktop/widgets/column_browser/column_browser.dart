import 'package:flutter/material.dart';
import 'package:fadeplay/desktop/objects/tracks/track.dart';
import 'item_column.dart';

class ColumnBrowserController extends ChangeNotifier {
  List<Track> tracks = [];
  List<ItemColumn<Track>> columns = []; // TODO: Load from settings

  void updateTracks(List<Track> newTracks) {
    tracks = newTracks;
    notifyListeners();
  }

  void updateColumns(List<ItemColumn<Track>> newColumns) {
    columns = newColumns;
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
    logger.log("Columns: ${widget.controller.columns}");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: widget.controller.columns
              .map(
                (column) => Container(
                  color: Colors.amber,
                  width: column.width,
                  child: Text(column.label, overflow: TextOverflow.ellipsis),
                ),
              )
              .toList(),
        ),

        Column(
          children: widget.controller.tracks
              .map(
                (track) => Row(
                  children: widget.controller.columns
                      .map(
                        (column) => Container(
                          color: Colors.blue,
                          width: column.width,
                          child: Text(
                            column.getValue(track),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                      .toList(),
                ),
              )
              .toList(),
        ),

        // SingleChildScrollView(
        //   scrollDirection: Axis.vertical,
        //   child: ListView.builder(
        //     itemBuilder: (context, index) =>
        //   ),
        // ),
      ],
    );
  }
}
