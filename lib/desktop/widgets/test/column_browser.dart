import 'package:fadeplay/desktop/objects/tracks/track.dart';
import 'package:fadeplay/desktop/widgets/column_browser/column_browser.dart';
import 'package:fadeplay/desktop/widgets/column_browser/columns/title_column.dart';
import 'package:flutter/material.dart';

class TestColumnBrowserWidget extends StatelessWidget {
  const TestColumnBrowserWidget({super.key});

  final music1 =
      "/home/livio/Musique/Musique/Songs/Super Mario Odyssey/SUPER MARIO ODYSSEY ORIGINAL SOUND TRACK/Steam Gardens.mp3";
  // Lasts 3:35
  final music2 =
      "/home/livio/Musique/Musique/Songs/Toby Fox/UNDERTALE Soundtrack/Spider Dance.mp3";
  final music3 =
      "/home/livio/Musique/Musique/Songs/Cowboy Bepop/COWBOY BEBOP (Original Motion Picture Soundtrack 3 - Blue)/Adieu.mp3";
  final music4 =
      "/home/livio/Musique/Musique/Songs/Izar/There Are Stars Inside of Me/There Are Stars Inside of Me.mp3";

  @override
  Widget build(BuildContext context) {
    final track1 = Track(title: "Steam Gardens", fileUri: Uri.file(music1));
    final track2 = Track(title: "Spider Dance", fileUri: Uri.file(music2));
    final track3 = Track(title: "Adieu", fileUri: Uri.file(music3));
    final track4 = Track(
      title: "There Are Stars Inside of Me",
      fileUri: Uri.file(music4),
    );
    final tracks = [track1, track2, track3, track4];
    final longPlaylist = List.filled(100, track1);
    final columns = [TitleColumn()];
    final controller = ColumnBrowserController();
    controller.updateColumns(columns);
    // controller.updateTracks(tracks);
    controller.updateTracks(longPlaylist);
    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.grey[200],
          height: 500,
          width: 500,
          child: ColumnBrowser(controller: controller),
        ),
      ),
    );
  }
}
