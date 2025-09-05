import 'package:fadeplay/desktop/data/tracks/playlist.dart';
import 'package:fadeplay/desktop/data/tracks/playlist_folder.dart';
import 'package:fadeplay/desktop/settings/theme.dart';
import 'package:fadeplay/desktop/widgets/general/column_elem.dart';
import 'package:flutter/material.dart';

class PlaylistSelector extends StatelessWidget {
  const PlaylistSelector({
    super.key,
    required this.playlists,
    required this.folders,
  });

  final List<Playlist> playlists;
  final List<PlaylistFolder> folders;

  Widget _uniquePlaylistItem(Playlist playlist) {
    return ColumnElem(
      inactiveTextStyle: MyTheme.textStyleNormal,
      hoverable: true,
      hoveringCursor: SystemMouseCursors.click,
      child: Text(playlist.name),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class PlaylistFolderSelector extends StatefulWidget {
  const PlaylistFolderSelector({
    super.key,
    required this.folder,
    required this.remainingFolders,
  });

  final PlaylistFolder folder;
  final List<PlaylistFolder> remainingFolders;

  @override
  State<PlaylistFolderSelector> createState() => _PlaylistFolderSelectorState();
}

class _PlaylistFolderSelectorState extends State<PlaylistFolderSelector> {
  late final List<PlaylistFolder> _myChildren;
  bool _checkAdded = false; // TODO: Remove
  // bool _unfolded = true;

  @override
  void initState() {
    super.initState();
    _myChildren = widget.remainingFolders
        .where((f) => f.containingFolder == widget.folder)
        .toList();
    logger.log(
      """Recursion init step ${widget.folder.name} with children: ${_myChildren.map((e) => e.name)}
      and remaining: ${widget.remainingFolders.map((f) => "(${f.name}, ${f.containingFolder?.name})")}""",
    );
  }

  @override
  void dispose() {
    logger.log("Disposing ${widget.folder.name}");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /* TODO: Here's the plan
      1. Take yourself out of remainingFolders
      2. Find all of the folder's children
      3. Add all of their selectors to a padded row
      4. Add a title on top
    */

    Future.delayed(Duration(seconds: 2)).then((_) async {
      if (widget.folder.name == "11" && !_checkAdded) {
        setState(() {
          _checkAdded = true;
          // _myChildren.add(
          //   PlaylistFolder(name: "99", containingFolder: widget.folder),
          // );
          // _myChildren.removeWhere((f) => f.name == "13");
          _myChildren.removeWhere((f) => f.name == "12");
        });
      }
    });

    final remainingChildren = List<PlaylistFolder>.from(widget.remainingFolders)
      ..removeWhere((f) => f.containingFolder == widget.folder)
      ..remove(widget.folder)
      ..toList();

    logger.log(
      "Recursion step ${widget.folder.name} with children: ${_myChildren.map((e) => e.name)} and remaining: ${remainingChildren.map((e) => e.name)}",
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.folder.name),
        Padding(
          padding: EdgeInsets.only(left: MyTheme.paddingSmall),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final child in _myChildren)
                PlaylistFolderSelector(
                  folder: child,
                  remainingFolders: remainingChildren,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
