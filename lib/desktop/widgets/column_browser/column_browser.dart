import 'package:fadeplay/desktop/objects/column_browser/column_browser_layout.dart';
import 'package:fadeplay/desktop/objects/logger.dart';
import 'package:fadeplay/desktop/widgets/column_browser/column_browser_headers.dart';
import 'package:fadeplay/desktop/widgets/column_browser/column_browser_track.dart';
import 'package:flutter/material.dart';
import 'package:fadeplay/desktop/objects/tracks/track.dart';

final logger = Logging("ColumnBrowser");

class ColumnBrowserController {
  final ValueNotifier<List<Track>> tracks = ValueNotifier([]);
  final ValueNotifier<ColumnBrowserLayout> columnsLayout = ValueNotifier(
    ColumnBrowserLayout(elems: []),
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

  void updateLayout(ColumnBrowserLayout newLayout) {
    logger.debug("Updating layout");
    columnsLayout.value = newLayout;
  }

  void incrementColumnSize({required int colIndex, required double delta}) {
    columnsLayout.value = ColumnBrowserLayout.copy(columnsLayout.value)
      ..incrementColumnSize(colIndex: colIndex, delta: delta);
    // block mutation with a .copy()
  }

  /// Inserts the header column that was dragged between 2 headers
  void insertDraggedColumn({
    required int colIndex,
    required int separatorIndex,
  }) {
    final indexDifference = separatorIndex - colIndex;
    if (!logger.check(
      indexDifference != 0 && indexDifference != 1,
      message: "Invalid index reached when dragged column header",
    )) {
      return;
    }

    final newLayout = ColumnBrowserLayout.copy(columnsLayout.value);
    final movedColumn = newLayout.elems[colIndex];
    newLayout.elems.removeAt(colIndex);
    final insertIndex = indexDifference > 0
        ? separatorIndex - 1
        : separatorIndex;
    newLayout.elems.insert(insertIndex, movedColumn);
    columnsLayout.value = newLayout;
  }

  /// Inserts the column that has been dragged in the column modifying screen
  void insertColumn({required String columnId, required int index}) {
    columnsLayout.value = ColumnBrowserLayout.copy(columnsLayout.value)
      ..insertColumn(columnId: columnId, index: index);
  }
}

class ColumnBrowser extends StatefulWidget {
  const ColumnBrowser({
    super.key,
    required this.controller,
    this.separatorWidth = 5, // TODO: Get separator width from layout
    this.dragTargetWidth = 30, // TODO: Get drag target width from layout
  });

  final ColumnBrowserController controller;
  final double separatorWidth;
  final double dragTargetWidth;

  @override
  State<ColumnBrowser> createState() => _ColumnBrowserState();
}

class _ColumnBrowserState extends State<ColumnBrowser> {
  @override
  Widget build(BuildContext context) {
    logger.debug(
      "Building ColumnBrowser with columns '${widget.controller.columnsLayout}'",
    );
    return LayoutBuilder(
      builder: (context, constraints) =>
          ValueListenableBuilder<ColumnBrowserLayout>(
            valueListenable: widget.controller.columnsLayout,
            builder: (context, columnsLayout, child) {
              final adaptedLayout = columnsLayout.adaptedToWidth(
                constraints.maxWidth,
              );
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                children: [
                  ColumnBrowserHeaders(
                    controller: widget.controller,
                    columnLayout: adaptedLayout,
                    separatorWidth: widget.separatorWidth,
                    dragTargetWidth: widget.dragTargetWidth,
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
                            columnLayout: adaptedLayout,
                            separatorWidth: widget.separatorWidth,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
    );
  }
}
