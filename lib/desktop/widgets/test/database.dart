import 'dart:async';
import 'dart:developer';

import 'package:fadeplay/desktop/objects/music_players/full_music_player.dart';
import 'package:fadeplay/desktop/db/schemas.dart';
import 'package:fadeplay/desktop/db/schemas/enums.dart';
import 'package:flutter/material.dart';

class TestDatabaseWidget extends StatelessWidget {
  const TestDatabaseWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          // future: connect(),
          future: checkUnique(),
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

  final musicPath1 =
      "/home/livio/Musique/Musique/Songs/Super Mario Odyssey/SUPER MARIO ODYSSEY ORIGINAL SOUND TRACK/Steam Gardens.mp3";
  final musicPath2 =
      "/home/livio/Musique/Musique/Songs/Toby Fox/UNDERTALE Soundtrack/Spider Dance.mp3";
  final musicPath3 =
      "/home/livio/Musique/Musique/Songs/Final Fantasy VII Rebirth/No Promises to Keep.mp3";

  Future<(int, int, int)> addTracks() async {
    final db = AppDatabase();
    await db.delete(db.tracks).go();
    final b = await db
        .into(db.tracks)
        .insert(
          TracksCompanion.insert(
            duration: 100,
            title: "Music 1",
            filePath: musicPath1,
            artistString: "Artist 1",
          ),
        );
    final c = await db
        .into(db.tracks)
        .insert(
          TracksCompanion.insert(
            duration: 200,
            title: "Music 2",
            filePath: musicPath2,
            artistString: "Artist 2",
          ),
        );
    final d = await db
        .into(db.tracks)
        .insert(
          TracksCompanion.insert(
            duration: 300,
            title: "Music 3",
            filePath: musicPath3,
            artistString: "Artist 3",
          ),
        );

    return (b, c, d);
  }

  Future<(int, int)> addArtists() async {
    final db = AppDatabase();
    await db.delete(db.artists).go();
    final a = await db
        .into(db.artists)
        .insert(ArtistsCompanion.insert(name: "Cool artist"));
    final b = await db
        .into(db.artists)
        .insert(ArtistsCompanion.insert(name: "Cooler artist"));

    return (a, b);
  }

  Future<String> connect() async {
    /* Checkout links with:
      SELECT t.title, a.name FROM tracks as t
      JOIN track_artists ON t.id = track_id
      JOIN artists as a ON a.id = artist_id
    */

    final db = AppDatabase();
    final (t1, t2, t3) = await addTracks();
    final (a1, a2) = await addArtists();

    await db
        .into(db.trackArtists)
        .insert(
          TrackArtistsCompanion.insert(
            trackId: t1,
            artistId: a1,
            artistRole: ArtistRole.artist,
          ),
        );
    await db
        .into(db.trackArtists)
        .insert(
          TrackArtistsCompanion.insert(
            trackId: t2,
            artistId: a1,
            artistRole: ArtistRole.artist,
          ),
        );
    await db
        .into(db.trackArtists)
        .insert(
          TrackArtistsCompanion.insert(
            trackId: t2,
            artistId: a2,
            artistRole: ArtistRole.artist,
          ),
        );
    await db
        .into(db.trackArtists)
        .insert(
          TrackArtistsCompanion.insert(
            trackId: t3,
            artistId: a1,
            artistRole: ArtistRole.artist,
          ),
        );
    await db
        .into(db.trackArtists)
        .insert(
          TrackArtistsCompanion.insert(
            trackId: t1,
            artistId: a2,
            artistRole: ArtistRole.artist,
          ),
        );

    return "success !";
  }

  Future<String> checkUnique() async {
    final db = AppDatabase();
    final (t1, t2, t3) = await addTracks();
    final (a1, a2) = await addArtists();

    await db
        .into(db.trackArtists)
        .insert(
          TrackArtistsCompanion.insert(
            trackId: t3,
            artistId: a1,
            artistRole: ArtistRole.artist,
          ),
        );

    await db
        .into(db.trackArtists)
        .insert(
          TrackArtistsCompanion.insert(
            trackId: t3,
            artistId: a1,
            artistRole: ArtistRole.artist,
          ),
        );

    return "unique check failed !!!!";
  }
}
