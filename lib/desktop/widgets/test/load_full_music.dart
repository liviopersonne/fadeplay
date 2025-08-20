import 'dart:async';
import 'dart:developer';

import 'package:fadeplay/desktop/objects/full_music_player.dart';
import 'package:flutter/material.dart';

class TestLoadFullMusicWidget extends StatelessWidget {
  const TestLoadFullMusicWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          // future: loadMusic(),
          // future: spamPrevious(),
          future: spamNext(),
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

  final music1 =
      "/home/livio/Musique/Musique/Songs/Super Mario Odyssey/SUPER MARIO ODYSSEY ORIGINAL SOUND TRACK/Steam Gardens.mp3";
  final music2 =
      "/home/livio/Musique/Musique/Songs/Toby Fox/UNDERTALE Soundtrack/Spider Dance.mp3";
  final music3 =
      "/home/livio/Musique/Musique/Songs/Final Fantasy VII Rebirth/No Promises to Keep.mp3";

  Future<String> loadMusic() async {
    var content = "";

    final myPlayer = FullMusicPlayer();

    final success = await myPlayer.loadPlaylist(
      filePaths: [music1, music2, music3],
      initialIndex: 1,
    );

    if (success) {
      await myPlayer.play();
      await Future.delayed(Duration(seconds: 3));

      await myPlayer.crossfadeNext(crossfadeDuration: Duration(seconds: 2));
      // await myPlayer.next();
      await Future.delayed(Duration(seconds: 1));

      await myPlayer.prev();
      await Future.delayed(Duration(seconds: 2));

      await myPlayer.pause();
      await myPlayer.prev();
      await Future.delayed(Duration(seconds: 2));

      await myPlayer.play();
      await Future.delayed(Duration(seconds: 2));

      await myPlayer.dispose();
    }

    content = success ? "Loaded playlist" : "Failed to load playlist";

    return content;
  }

  Future<String> spamPrevious() async {
    var content = "";

    final myPlayer = FullMusicPlayer();

    final success = await myPlayer.loadPlaylist(
      filePaths: [music1, music2, music3],
    );

    if (success) {
      await myPlayer.play();
      await Future.delayed(Duration(seconds: 2));

      await myPlayer.prev();
      await Future.delayed(Duration(seconds: 2));

      await myPlayer.prev();
      await Future.delayed(Duration(seconds: 2));

      await myPlayer.prev();
      await Future.delayed(Duration(seconds: 2));

      await myPlayer.prev();
      await Future.delayed(Duration(seconds: 2));

      await myPlayer.dispose();
    }

    content = success ? "Loaded playlist" : "Failed to load playlist";

    return content;
  }

  Future<String> spamNext() async {
    var content = "";

    final myPlayer = FullMusicPlayer();

    final success = await myPlayer.loadPlaylist(
      filePaths: [music1, music2, music3],
      initialIndex: 1,
    );

    if (success) {
      await myPlayer.next();
      await myPlayer.play();
      await Future.delayed(Duration(seconds: 2));

      await myPlayer.next();
      await Future.delayed(Duration(seconds: 2));

      await myPlayer.next();
      await Future.delayed(Duration(seconds: 2));

      await myPlayer.next();
      await Future.delayed(Duration(seconds: 2));

      await myPlayer.next();
      await Future.delayed(Duration(seconds: 2));

      await myPlayer.dispose();
    }

    content = success ? "Loaded playlist" : "Failed to load playlist";

    return content;
  }
}
