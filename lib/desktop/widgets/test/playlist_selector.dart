import 'package:fadeplay/desktop/data/tracks/playlist.dart';
import 'package:fadeplay/desktop/data/tracks/playlist_folder.dart';
import 'package:fadeplay/desktop/settings/theme.dart';
import 'package:fadeplay/desktop/widgets/general/color_size_box.dart';
import 'package:fadeplay/desktop/widgets/playlist_selector/playlist_selector.dart';
import 'package:flutter/material.dart';

class TestPlaylistSelector extends StatelessWidget {
  const TestPlaylistSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final folder1 = PlaylistFolder(name: "11");
    final folder2 = PlaylistFolder(name: "12", containingFolder: folder1);
    final folder3 = PlaylistFolder(name: "13", containingFolder: folder1);
    final folder4 = PlaylistFolder(name: "14");
    final folder5 = PlaylistFolder(name: "15", containingFolder: folder3);
    final folder6 = PlaylistFolder(name: "16", containingFolder: folder1);
    final allFolders = [folder1, folder2, folder3, folder4, folder5, folder6];

    final playlist1 = Playlist(name: "1", containingFolder: folder1);
    final playlist2 = Playlist(name: "2", containingFolder: folder2);
    final playlist3 = Playlist(name: "3", containingFolder: folder3);
    final playlist4 = Playlist(name: "4", containingFolder: folder4);
    final playlist5 = Playlist(name: "5", containingFolder: folder5);
    final playlist6 = Playlist(name: "6", containingFolder: folder6);
    final allPlaylists = [
      playlist1,
      playlist2,
      playlist3,
      playlist4,
      playlist5,
      playlist6,
      ...List.generate(10, (i) => Playlist(name: (i + 20).toString())),
    ];

    return Scaffold(
      body: Center(
        child: ColorSizeBox(
          color: MyTheme.colorBackgroundVeryDark,
          height: 400,
          width: 300,
          child: Center(
            child: Column(
              children: [
                PlaylistSelector(playlists: allPlaylists, folders: allFolders),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
