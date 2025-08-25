import 'package:flutter/material.dart';
import 'package:fadeplay/desktop/objects/tracks/track.dart';
import 'item_column.dart';

class ColumnBrowser extends StatefulWidget {
  const ColumnBrowser({super.key});

  @override
  State<ColumnBrowser> createState() => _ColumnBrowserState();
}

class _ColumnBrowserState extends State<ColumnBrowser> {
  List<Track> tracks = []; // TODO: Load in constructor ?
  List<ItemColumn<Track>> columns = []; // TODO: Load from settings

  void updateTracks(List<Track> newTracks) {
    setState(() {
      tracks = newTracks;
    });
  }

  void updateColumns(List<ItemColumn<Track>> newColumns) {
    setState(() {
      columns = newColumns;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: columns
              .map(
                (column) =>
                    SizedBox(width: column.width, child: Text(column.label)),
              )
              .toList(),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: ListView.builder(
            itemBuilder: (context, index) => Row(
              children: columns
                  .map(
                    (column) => SizedBox(
                      width: column.width,
                      child: Text(column.getValue(tracks[index])),
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
