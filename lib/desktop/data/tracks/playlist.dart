import 'dart:async';

import 'package:fadeplay/desktop/data/has_id.dart';
import 'package:fadeplay/desktop/data/tracks/playlist_folder.dart';
import 'package:fadeplay/desktop/data/tracks/track.dart';

class Playlist extends HasId {
  @override
  final int? id; // if id is null then the playlist is not in db
  String name;
  Future<List<Track>> Function()? getTracks;
  Uri? imageUri;
  FutureOr<PlaylistFolder> Function()? getContainingFolder;

  Playlist({
    this.id,
    required this.name,
    this.getTracks,
    this.imageUri,
    this.getContainingFolder,
  });

  @override
  bool operator ==(Object other) {
    if (other is Playlist) {
      if (id == null) {
        return other.id == null && other.name == name;
      }
      return other.id == id;
    }
    return false;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Playlist<${id != null ? "id:$id" : "no id"}, $name>';
  }
}
