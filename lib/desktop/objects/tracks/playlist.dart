import 'package:fadeplay/desktop/objects/tracks/playlist_folder.dart';
import 'package:fadeplay/desktop/objects/tracks/track.dart';

class Playlist {
  String name;
  List<Track> tracks;
  Uri? imageUri;
  PlaylistFolder? containingFolder;

  Playlist({
    required this.name,
    this.tracks = const [],
    this.imageUri,
    this.containingFolder,
  });
}
