import 'package:fadeplay/desktop/data/single_music_player.dart';
import 'package:fadeplay/desktop/widgets/test/load_full_music.dart';
import 'package:fadeplay/desktop/widgets/test/load_single_music.dart';
import 'package:flutter/material.dart';

void desktopMain() {
  SingleMusicPlayer.initialize();
  runApp(const DesktopApp());
}

class DesktopApp extends StatelessWidget {
  const DesktopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TestLoadFullMusicWidget(),
      // home: TestLoadSingleMusicWidget(),
      debugShowCheckedModeBanner: false,
    );
  }
}
