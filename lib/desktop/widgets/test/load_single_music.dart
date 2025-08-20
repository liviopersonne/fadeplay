import 'dart:async';
import 'dart:developer';

import 'package:fadeplay/desktop/objects/single_music_player.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class TestLoadSingleMusicWidget extends StatelessWidget {
  const TestLoadSingleMusicWidget({super.key});

  final music1 =
      "/home/livio/Musique/Musique/Songs/Super Mario Odyssey/SUPER MARIO ODYSSEY ORIGINAL SOUND TRACK/Steam Gardens.mp3";
  // Lasts 3:35
  final music2 =
      "/home/livio/Musique/Musique/Songs/Toby Fox/UNDERTALE Soundtrack/Spider Dance.mp3";
  final music3 =
      "/home/livio/Musique/Musique/Songs/Final Fantasy VII Rebirth/Chocobo Racing Theme.mp3";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          // future: loadMusic(),
          // future: loadPlaylist(),
          // future: testAutoReachEnd(),
          future: testManualReachEnd(),
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

  Future<String> testAutoReachEnd() async {
    final fileList = [music1, music2, music3];
    final playlist = fileList.map((f) => AudioSource.uri(Uri.file(f))).toList();

    final myPlayer = SingleMusicPlayer();

    final loaded = await myPlayer.loadPlaylist(audioSources: playlist);

    if (loaded) {
      await myPlayer.play();
      await myPlayer.player.seek(Duration(seconds: 210));
      await Future.delayed(Duration(seconds: 10));
      await myPlayer.play();
      await Future.delayed(Duration(seconds: 4));
      await myPlayer.dispose();
    }

    return "Loaded song";
  }

  Future<String> testManualReachEnd() async {
    final fileList = [music1, music2, music3];
    final playlist = fileList.map((f) => AudioSource.uri(Uri.file(f))).toList();

    final myPlayer = SingleMusicPlayer();

    final loaded = await myPlayer.loadPlaylist(audioSources: playlist);

    if (loaded) {
      await myPlayer.play();
      await Future.delayed(Duration(seconds: 3));
      await myPlayer.next();
      await Future.delayed(Duration(seconds: 3));
      await myPlayer.play();
      await Future.delayed(Duration(seconds: 3));
      await myPlayer.prev();
      await Future.delayed(Duration(seconds: 3));
      await myPlayer.play();
      await Future.delayed(Duration(seconds: 4));
      await myPlayer.dispose();
    }

    return "Loaded song";
  }
}
