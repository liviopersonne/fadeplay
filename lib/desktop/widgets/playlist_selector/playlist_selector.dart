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

class PlaylistFolderSelector extends StatelessWidget {
  const PlaylistFolderSelector({
    super.key,
    required this.folder,
    required this.remainingFolders,
  });

  final PlaylistFolder folder;
  final List<PlaylistFolder> remainingFolders;

  @override
  Widget build(BuildContext context) {
    /* TODO: Here's the plan
      1. Take yourself out of remainingFolders
      2. Find all of the folder's children
      3. Add all of their selectors to a padded row
      4. Add a title on top
    */
    logger.log(
      "Recursion step ${folder.name} with remaining: ${remainingFolders.map((f) => f.name)}",
    );

    final myChildren = remainingFolders
        .where((f) => f.containingFolder == folder)
        .toList();
    remainingFolders
      ..remove(folder)
      ..removeWhere((f) => f.containingFolder == folder);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(folder.name),
        Padding(
          padding: EdgeInsets.only(left: MyTheme.paddingSmall),
          child: Column(
            children: [
              for (final child in myChildren)
                PlaylistFolderSelector(
                  folder: child,
                  remainingFolders: remainingFolders,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
