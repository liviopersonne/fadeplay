import 'package:fadeplay/desktop/widgets/column_browser/column_browser.dart';
import 'package:flutter/material.dart';

class TestLoadSingleMusicWidget extends StatelessWidget {
  const TestLoadSingleMusicWidget({super.key});

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
    return Scaffold(body: Center(child: ColumnBrowser()));
  }
}
