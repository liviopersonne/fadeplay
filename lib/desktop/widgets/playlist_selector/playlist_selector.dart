import 'package:fadeplay/desktop/data/tracks/playlist.dart';
import 'package:fadeplay/desktop/data/tracks/playlist_folder.dart';
import 'package:fadeplay/desktop/objects/playlist_selector/playlist_or_folder.dart';
import 'package:fadeplay/desktop/widgets/playlist_selector/general_elem.dart';
import 'package:fadeplay/desktop/widgets/playlist_selector/playlist_elem.dart';
import 'package:flutter/material.dart';

class PlaylistSelector extends StatelessWidget {
  const PlaylistSelector({
    super.key,
    required this.playlists,
    required this.folders,
  });

  final List<Playlist> playlists;
  final List<PlaylistFolder> folders;

  @override
  Widget build(BuildContext context) {
    final List<PlaylistOrFolder> allElems = playlists
        .map((p) => PlaylistOrFolder.playlist(p))
        .followedBy(folders.map((f) => PlaylistOrFolder.folder(f)))
        .toList();

    final List<PlaylistOrFolder> rootElems = allElems
        .where(
          (e) => e.isFolder
              ? e.folder!.getContainingFolder == null
              : e.playlist!.getContainingFolder == null,
        )
        .toList();

    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final child in rootElems)
                child.isFolder
                    ? PlaylistSelectorElem(
                        folder: child.folder!,
                        remainingElems: allElems,
                        width: constraints.maxWidth,
                      )
                    : PlaylistSelectorPlaylistElem(
                        playlist: child.playlist!,
                        width: constraints.maxWidth,
                      ),
            ],
          ),
        ),
      ),
    );
  }
}
