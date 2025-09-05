import 'package:fadeplay/desktop/data/tracks/playlist.dart';
import 'package:fadeplay/desktop/widgets/general/button.dart';
import 'package:flutter/material.dart';

class PlaylistSelectorPlaylistElem extends StatelessWidget {
  const PlaylistSelectorPlaylistElem({super.key, required this.playlist});

  final Playlist playlist;

  @override
  Widget build(BuildContext context) {
    return MyButton(text: playlist.name);
  }
}
