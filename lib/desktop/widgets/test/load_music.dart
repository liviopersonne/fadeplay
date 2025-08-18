import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:fadeplay/desktop/data/music_player.dart';
import 'package:flutter/material.dart';

class TestLoadMusicWidget extends StatelessWidget {
  const TestLoadMusicWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: loadMusic(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Loading...");
            } else if (snapshot.hasError) {
              log(snapshot.error.toString());
              return Text("Error: ${snapshot.error}");
            } else {
              return Text(snapshot.data ?? "No result");
            }
          },
        ),
      ),
    );
  }

  Future<String> loadMusic() async {
    final music1 =
        "/home/livio/Musique/Musique/Songs/Super Mario Odyssey/SUPER MARIO ODYSSEY ORIGINAL SOUND TRACK/Steam Gardens.mp3";

    var content = "";

    final myPlayer = MusicPlayer();

    final loaded = await myPlayer.loadMusicFile(music1);

    if (loaded) {
      content = "Music load succeeded";
      await myPlayer.fadein(duration: Duration(seconds: 3));
      content = "Fadein finished !";
      await Future.delayed(Duration(seconds: 5));
      await myPlayer.fadeout(duration: Duration(seconds: 3));
      content = "Fadeout finished !";
    } else {
      content = "Music load failed";
    }

    return content;
  }
}
