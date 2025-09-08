import 'package:drift/drift.dart';
import 'package:fadeplay/desktop/data/tracks/album.dart';
import 'package:fadeplay/desktop/data/tracks/artist.dart';
import 'package:fadeplay/desktop/data/tracks/source.dart';
import 'package:fadeplay/desktop/data/tracks/track.dart';
import 'package:fadeplay/desktop/db/queries/queries.dart';
import 'package:fadeplay/desktop/db/schemas.dart' as db;
import 'package:fadeplay/desktop/db/schemas/enums.dart';
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
  final music = "/home/livio/Bureau/fadeplay_tests/timber_hearth.mp3";
  final image1 = "/home/livio/Bureau/fadeplay_tests/img1.png";
  final image2 = "/home/livio/Bureau/fadeplay_tests/img2.png";
  final image3 = "/home/livio/Bureau/fadeplay_tests/img3.png";
  final image4 = "/home/livio/Bureau/fadeplay_tests/img4.png";
  final image5 = "/home/livio/Bureau/fadeplay_tests/img5.png";
  final image6 = "/home/livio/Bureau/fadeplay_tests/img6.png";

  final artist1 = Artist(
    name: "Artist 1",
    originalName: "Original Artist 1",
    imageUri: Uri.file(image1),
  );
  final artist2 = Artist(
    name: "Artist 2",
    originalName: "Original Artist 2",
    imageUri: Uri.file(image2),
  );
  final artist3 = Artist(
    name: "Artist 3",
    originalName: "Original Artist 3",
    imageUri: Uri.file(image3),
  );
  final source = Source(
    title: "Source title",
    originalTitle: "Original Source title",
    imageUri: Uri.file(image4),
  );
  final album = Album(
    title: "Album title",
    originalTitle: "Original album title",
    imageUri: Uri.file(image5),
  );
  final moods = await DbQuery.allMoods;
  final instruments = await DbQuery.allInstruments;
  final safeties = await DbQuery.allSafeties;

  logger.log(moods.toString());
  logger.log(instruments.toString());
  logger.log(safeties.toString());

  final Track track = Track(
    title: "Song title",
    originalTitle: "Original song title",
    artistString: "Song artists",
    fileUri: Uri.file(music),
    imageUri: Uri.file(image6),
    album: album,
    diskNumber: 1,
    diskTotal: 3,
    trackNumber: 4,
    trackTotal: 28,
    releaseYear: 2025,
    rating: 3.5,
    startTime: Duration(seconds: 31),
    endTime: Duration(seconds: 90),
    moods: List.generate(3, (i) => moods[i]),
    instruments: List.generate(3, (i) => instruments[i]),
    artists: {
      artist1: ArtistRole.artist,
      artist2: ArtistRole.composer,
      artist3: ArtistRole.cover,
    },
    source: source,
    safeties: List.generate(1, (i) => safeties[i]),
    lyricsUri: null,
  );

  database.delete(database.tracks).go();
  database.delete(database.albums).go();
  database.delete(database.artists).go();
  database.delete(database.sources).go();
  database.delete(database.trackArtists).go();
  database.delete(database.trackInstruments).go();
  database.delete(database.trackMoods).go();
  database.delete(database.trackSafeties).go();
  await DbQuery.upsertTrack(track: track);

  final tracks = await DbQuery.getTracks();

  for (var track in tracks) {
    logger.log(track.detailedString());
  }

  return tracks;
}
