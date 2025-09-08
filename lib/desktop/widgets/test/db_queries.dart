import 'package:drift/drift.dart';
import 'package:fadeplay/desktop/data/tracks/album.dart';
import 'package:fadeplay/desktop/data/tracks/artist.dart';
import 'package:fadeplay/desktop/data/tracks/source.dart';
import 'package:fadeplay/desktop/data/tracks/track.dart';
import 'package:fadeplay/desktop/db/queries/queries.dart';
import 'package:fadeplay/desktop/db/schemas.dart' as db;
import 'package:fadeplay/desktop/objects/logger.dart';
import 'package:fadeplay/desktop/widgets/general/color_size_box.dart';
import 'package:flutter/material.dart';

final logger = Logging("TestDbQueries");
final database = db.AppDatabase();

class TestDbQueries extends StatelessWidget {
  const TestDbQueries({super.key});

  @override
  Widget build(BuildContext context) {
    // final request = testSources();
    // final request = testArtists();
    final request = testTracks();
    return Scaffold(
      body: Center(
        child: ColorSizeBox(
          height: 500,
          width: 800,
          color: Colors.grey,
          child: FutureBuilder(
            future: request,
            builder: (context, asyncSnapshot) {
              return Center(
                child: Text(
                  asyncSnapshot.hasData
                      ? "${asyncSnapshot.data}"
                      : "loading...",
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

Future<List<Source>> testSources() async {
  final imgUri1 = Uri.file("/home/livio/Bureau/fadeplay_tests/img1.png");
  database.delete(database.sources).go();
  await DbQuery.upsertSource(
    source: Source(title: "source 2", originalTitle: "og 2"),
  );
  await DbQuery.upsertSource(
    source: Source(title: "source 1", imageUri: imgUri1),
  );
  await DbQuery.upsertSource(source: Source(title: "source 3"));
  return await DbQuery.getSources(
    orderBy: [
      (u) => OrderingTerm(expression: u.title, mode: OrderingMode.desc),
    ],
    filter: (u) => u.title.isBiggerOrEqualValue("source 2"),
  );
}

Future<List<Artist>> testArtists() async {
  final imgUri1 = Uri.file("/home/livio/Bureau/fadeplay_tests/img1.png");
  database.delete(database.artists).go();
  final artistId = await DbQuery.upsertArtist(
    artist: Artist(
      name: "artist 1",
      originalName: "og artist 1",
      imageUri: imgUri1,
    ),
  );

  logger.log("Id: $artistId");

  await DbQuery.upsertArtist(
    artist: Artist(id: artistId, name: "artist 1 new name"),
  );

  return await DbQuery.getArtists();
}

Future<List<Track>> testTracks() async {
  final imgUri1 = Uri.file("/home/livio/Bureau/fadeplay_tests/img1.png");
  final fileUri1 = Uri.file(
    "/home/livio/Bureau/fadeplay_tests/timber_hearth.mp3",
  );

  database.delete(database.tracks).go();
  final trackId = await DbQuery.upsertTrack(
    track: Track(
      fileUri: fileUri1,
      imageUri: imgUri1,
      title: "Track 1",
      artistString: "Artists of track 1",
      album: Album(title: "Album 1"),
      // source: Source(title: "Source 1"),
      // FIXME: Replace with left joins to get the tracks
    ),
  );

  final tracks = await DbQuery.getTracks();

  for (var track in tracks) {
    logger.log(track.detailedString());
  }

  return tracks;
}
