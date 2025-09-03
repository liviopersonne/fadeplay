import 'package:fadeplay/desktop/data/tracks/playlist_folder.dart';
import 'package:fadeplay/desktop/data/tracks/track.dart';

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

  @override
  bool operator ==(Object other) {
    if (other is Playlist) {
      return other.name == name || other.containingFolder == containingFolder;
    }
    return false;
  }

  @override
  int get hashCode => name.hashCode + containingFolder.hashCode;
}
