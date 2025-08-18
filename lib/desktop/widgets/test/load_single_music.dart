import 'dart:async';
import 'dart:developer';

import 'package:fadeplay/desktop/data/single_music_player.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class TestLoadSingleMusicWidget extends StatelessWidget {
  const TestLoadSingleMusicWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          // future: loadMusic(),
          future: loadPlaylist(),
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

    final myPlayer = SingleMusicPlayer();

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

  Future<String> loadPlaylist() async {
    final music1 =
        "/home/livio/Musique/Musique/Songs/Super Mario Odyssey/SUPER MARIO ODYSSEY ORIGINAL SOUND TRACK/Steam Gardens.mp3";
    final music2 =
        "/home/livio/Musique/Musique/Songs/Toby Fox/UNDERTALE Soundtrack/Spider Dance.mp3";
    final music3 =
        "/home/livio/Musique/Musique/Songs/Final Fantasy VII Rebirth/Chocobo Racing Theme.mp3";

    final fileList = [music1, music2, music3];
    final playlist = fileList.map((f) => AudioSource.uri(Uri.file(f))).toList();

    var content = "";

    final myPlayer = SingleMusicPlayer();

    final loaded = await myPlayer.loadPlaylist(audioSources: playlist);

    if (loaded) {
      content = "Music load succeeded";
      await myPlayer.fadein(duration: Duration(seconds: 1));
      await Future.delayed(Duration(seconds: 5));

      await myPlayer.pause();
      await myPlayer.next();
      await Future.delayed(Duration(seconds: 2));

      await myPlayer.fadein(duration: Duration(seconds: 1));
      await Future.delayed(Duration(seconds: 5));

      await myPlayer.fadeout(duration: Duration(seconds: 3));
      content = "Fadeout finished !";
    } else {
      content = "Music load failed";
    }

    return content;
  }
}
