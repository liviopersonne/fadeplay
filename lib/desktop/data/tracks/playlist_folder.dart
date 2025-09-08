import 'dart:async';

import 'package:fadeplay/desktop/data/has_id.dart';

class PlaylistFolder extends HasId {
  @override
  int? id;
  String name;
  Uri? imageUri;
  FutureOr<PlaylistFolder> Function()? getContainingFolder;

  PlaylistFolder({
    this.id,
    required this.name,
    this.imageUri,
    this.getContainingFolder,
  });

  @override
  bool operator ==(Object other) {
    if (other is PlaylistFolder) {
      if (id == null) {
        return other.id == null && other.name == name;
      }
      return other.id == id;
    }
    return false;
  }

  @override
  int get hashCode => id.hashCode;
}
