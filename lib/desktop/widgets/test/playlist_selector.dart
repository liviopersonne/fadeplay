import 'package:fadeplay/desktop/data/tracks/playlist.dart';
import 'package:fadeplay/desktop/data/tracks/playlist_folder.dart';
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
    final allFolders = [folder1, folder2, folder3, folder4, folder5];

    final playlist1 = Playlist(name: "1", containingFolder: folder1);

    return Scaffold(
      body: Center(
        child: ColorSizeBox(
          color: Colors.grey,
          height: 400,
          width: 500,
          child: Center(
            child: Column(
              children: [
                PlaylistFolderSelector(
                  folder: allFolders.first,
                  remainingFolders: allFolders,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
