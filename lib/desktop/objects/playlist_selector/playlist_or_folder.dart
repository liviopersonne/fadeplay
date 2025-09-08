import 'dart:async';

import 'package:fadeplay/desktop/data/tracks/playlist.dart';
import 'package:fadeplay/desktop/data/tracks/playlist_folder.dart';

class PlaylistOrFolder {
  const PlaylistOrFolder.playlist(Playlist this.playlist)
    : isFolder = false,
      folder = null;

  const PlaylistOrFolder.folder(PlaylistFolder this.folder)
    : isFolder = true,
      playlist = null;

  final Playlist? playlist;
  final PlaylistFolder? folder;
  final bool isFolder;

  String get name => isFolder ? folder!.name : playlist!.name;

  FutureOr<PlaylistFolder> Function()? get getContainingFolder =>
      isFolder ? folder!.getContainingFolder : playlist!.getContainingFolder;
}
