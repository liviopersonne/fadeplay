import 'dart:async';
import 'dart:developer';

import 'package:fadeplay/desktop/objects/full_music_player.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class TestLoadFullMusicWidget extends StatelessWidget {
  const TestLoadFullMusicWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          // future: loadMusic(),
          // future: spamNext(),
          // future: spamPrevious(),
          // future: spamNextPastEnd(),
          // future: spamPrevPastStart(),
          // future: testAutoReachEnd(),
          // future: testManualReachEnd(),
          // future: testCrossfade(),
          future: testPausingDuringCrossfade(),
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
  // Lasts 3:35
  final music2 =
      "/home/livio/Musique/Musique/Songs/Toby Fox/UNDERTALE Soundtrack/Spider Dance.mp3";
  final music3 =
      "/home/livio/Musique/Musique/Songs/Cowboy Bepop/COWBOY BEBOP (Original Motion Picture Soundtrack 3 - Blue)/Adieu.mp3";
  final music4 =
      "/home/livio/Musique/Musique/Songs/Izar/There Are Stars Inside of Me/There Are Stars Inside of Me.mp3";

  Future<String> loadMusic() async {
    var content = "";

    final fileList = [music1, music2, music3];
    final playlist = fileList.map((f) => AudioSource.uri(Uri.file(f))).toList();

    final myPlayer = FullMusicPlayer();

    final success = await myPlayer.loadPlaylist(
      audioSources: playlist,
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
    final fileList = [music1, music2, music3, music4, music1, music2];
    final playlist = fileList.map((f) => AudioSource.uri(Uri.file(f))).toList();

    final myPlayer = FullMusicPlayer();

    final success = await myPlayer.loadPlaylist(
      audioSources: playlist,
      initialIndex: 4,
    );

    if (success) {
      await myPlayer.play();
      logger.log("Start delay 1");
      await Future.delayed(Duration(seconds: 2));
      logger.log("End delay 1");

      await myPlayer.prev();
      logger.log("Start delay 2");
      await Future.delayed(Duration(seconds: 2));
      logger.log("End delay 2");

      await myPlayer.pause();
      await myPlayer.prev();
      logger.log("Start delay 3");
      await Future.delayed(Duration(seconds: 2));
      logger.log("End delay 3");

      await myPlayer.prev();
      logger.log("Start delay 4");
      await Future.delayed(Duration(seconds: 2));
      logger.log("End delay 4");

      await myPlayer.prev();
      await myPlayer.play();
      logger.log("Start delay 5");
      await Future.delayed(Duration(seconds: 2));
      logger.log("End delay 5");

      await myPlayer.next();
      logger.log("Start delay 6");
      await Future.delayed(Duration(seconds: 2));
      logger.log("End delay 6");

      await myPlayer.dispose();
    }

    content = success ? "Loaded playlist" : "Failed to load playlist";

    return content;
  }

  Future<String> spamNextPastEnd() async {
    var content = "";
    final fileList = [music1, music2, music3];

    final List<AudioSource> playlist = fileList
        .map((f) => AudioSource.uri(Uri.file(f)))
        .toList();

    final myPlayer = FullMusicPlayer();

    final success = await myPlayer.loadPlaylist(audioSources: playlist);

    if (success) {
      await myPlayer.next();
      await myPlayer.play();
      await Future.delayed(Duration(seconds: 2));

      await myPlayer.prev();
      await Future.delayed(Duration(seconds: 2));

      await myPlayer.next();
      await Future.delayed(Duration(seconds: 2));

      await myPlayer.next();
      await Future.delayed(Duration(seconds: 2));

      await myPlayer.prev();
      await Future.delayed(Duration(seconds: 2));

      await myPlayer.next();
      await Future.delayed(Duration(seconds: 2));
      await myPlayer.next();
      await Future.delayed(Duration(seconds: 3));
      await myPlayer.next();
      await Future.delayed(Duration(seconds: 2));

      await myPlayer.dispose();
    }

    content = success ? "Loaded playlist" : "Failed to load playlist";

    return content;
  }

  Future<String> spamPrevPastStart() async {
    var content = "";
    final fileList = [music1, music2, music3];

    final List<AudioSource> playlist = fileList
        .map((f) => AudioSource.uri(Uri.file(f)))
        .toList();

    final myPlayer = FullMusicPlayer();

    final success = await myPlayer.loadPlaylist(
      audioSources: playlist,
      initialIndex: 1,
    );

    if (success) {
      await myPlayer.play();
      await Future.delayed(Duration(seconds: 2));

      await myPlayer.prev();
      await Future.delayed(Duration(seconds: 2));

      await myPlayer.next();
      await Future.delayed(Duration(seconds: 2));

      await myPlayer.prev();
      await Future.delayed(Duration(seconds: 2));

      await myPlayer.prev();
      await Future.delayed(Duration(seconds: 3));

      await myPlayer.next();
      await Future.delayed(Duration(seconds: 2));

      await myPlayer.prev();
      await Future.delayed(Duration(seconds: 3));
      await myPlayer.prev();
      await Future.delayed(Duration(seconds: 2));

      await myPlayer.dispose();
    }

    content = success ? "Loaded playlist" : "Failed to load playlist";

    return content;
  }

  Future<String> spamNext() async {
    var content = "";
    final fileList = [music1, music2, music3, music1, music2, music3, music1];
    final playlist = fileList.map((f) => AudioSource.uri(Uri.file(f))).toList();

    final myPlayer = FullMusicPlayer();

    final success = await myPlayer.loadPlaylist(audioSources: playlist);

    if (success) {
      await myPlayer.play();
      logger.log("Start delay 1");
      await Future.delayed(Duration(seconds: 2));
      logger.log("End delay 1");

      await myPlayer.next();
      logger.log("Start delay 2");
      await Future.delayed(Duration(seconds: 2));
      logger.log("End delay 2");

      await myPlayer.pause();
      await myPlayer.next();
      logger.log("Start delay 3");
      await Future.delayed(Duration(seconds: 2));
      logger.log("End delay 3");

      await myPlayer.next();
      logger.log("Start delay 4");
      await Future.delayed(Duration(seconds: 2));
      logger.log("End delay 4");

      await myPlayer.next();
      await myPlayer.play();
      logger.log("Start delay 5");
      await Future.delayed(Duration(seconds: 2));
      logger.log("End delay 5");

      await myPlayer.next();
      logger.log("Start delay 6");
      await Future.delayed(Duration(seconds: 2));
      logger.log("End delay 6");

      await myPlayer.dispose();
    }

    content = success ? "Loaded playlist" : "Failed to load playlist";

    return content;
  }

  Future<String> testAutoReachEnd() async {
    final fileList = [music1, music2, music3, music1];
    final playlist = fileList.map((f) => AudioSource.uri(Uri.file(f))).toList();

    final myPlayer = FullMusicPlayer();

    final loaded = await myPlayer.loadPlaylist(audioSources: playlist);

    if (loaded) {
      await myPlayer.play();
      await myPlayer.seek(Duration(seconds: 210));
      await Future.delayed(Duration(seconds: 10));
      await myPlayer.seek(Duration(seconds: 100));
      await Future.delayed(Duration(seconds: 10));
      await myPlayer.prev();
      await Future.delayed(Duration(seconds: 4));
      await myPlayer.dispose();
    }

    return "Loaded song";
  }

  Future<String> testManualReachEnd() async {
    final fileList = [music1, music2, music3];
    final playlist = fileList.map((f) => AudioSource.uri(Uri.file(f))).toList();

    final myPlayer = FullMusicPlayer();

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

  Future<String> testCrossfade() async {
    final fileList = [music1, music2, music3];

    final List<AudioSource> playlist = fileList
        .map((f) => AudioSource.uri(Uri.file(f)))
        .toList();

    final myPlayer = FullMusicPlayer();

    final success = await myPlayer.loadPlaylist(audioSources: playlist);

    if (success) {
      await myPlayer.play();
      await Future.delayed(Duration(seconds: 2));

      await myPlayer.crossfadeNext(crossfadeDuration: Duration(seconds: 1));
      await Future.delayed(Duration(seconds: 2));

      await myPlayer.crossfadeNext(crossfadeDuration: Duration(seconds: 1));
      await Future.delayed(Duration(seconds: 2));

      await myPlayer.crossfadeNext(crossfadeDuration: Duration(seconds: 1));
      await Future.delayed(Duration(seconds: 2));

      await myPlayer.crossfadeNext(crossfadeDuration: Duration(seconds: 1));
      await Future.delayed(Duration(seconds: 2));

      await myPlayer.dispose();
    }

    return "Crossfades worked";
  }

  Future<String> testPausingDuringCrossfade() async {
    final fileList = [music1, music2, music3];

    final List<AudioSource> playlist = fileList
        .map((f) => AudioSource.uri(Uri.file(f)))
        .toList();

    final myPlayer = FullMusicPlayer();

    final success = await myPlayer.loadPlaylist(audioSources: playlist);

    if (success) {
      await myPlayer.play();
      await Future.delayed(Duration(seconds: 2));

      myPlayer.crossfadeNext(crossfadeDuration: Duration(seconds: 5));
      await Future.delayed(Duration(seconds: 1));

      await myPlayer.pause();
      await Future.delayed(Duration(seconds: 1));

      await myPlayer.play();
      await Future.delayed(Duration(seconds: 3));
      // await myPlayer.play();
      await Future.delayed(Duration(seconds: 20));

      // await myPlayer.crossfadeNext(crossfadeDuration: Duration(seconds: 1));

      // await Future.delayed(Duration(seconds: 3));
      // await myPlayer.play();

      // await Future.delayed(Duration(seconds: 2));

      // await myPlayer.crossfadeNext(crossfadeDuration: Duration(seconds: 1));
      // await Future.delayed(Duration(seconds: 2));

      // await myPlayer.crossfadeNext(crossfadeDuration: Duration(seconds: 1));
      // await Future.delayed(Duration(seconds: 2));

      await Future.delayed(Duration(seconds: 5));
      await myPlayer.dispose();
    }

    return "Crossfades worked";
  }
}
