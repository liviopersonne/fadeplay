import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

part 'schemas.g.dart';

// FIXME: Fix recursive getters on checks (I've commented them out for now)

// Mixins
mixin Id on Table {
  IntColumn get id => integer().autoIncrement()();
}

mixin DateAndId on Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get creationTime =>
      dateTime().withDefault(currentDateAndTime)();
}

mixin TrackId on Table {
  IntColumn get trackId => integer().references(Tracks, #id)();
}

// ENUMS

enum TransitionType { manual, automatic, mix }

enum ArtistType { artist, featured, composer, remixer, cover }

enum Safety { safe, lyrics, language, weirdVoice, screaming, ost, other }

// Checks
Expression<bool> positiveOrNull(Column<int> number) =>
    (number.isNull() | number.isBiggerThanValue(0));

Expression<bool> validTrackDiskNumbers(Column<int> track, Column<int> disk) =>
    (track.isNull() & disk.isNull()) |
    (track.isBiggerThanValue(0) & disk.isNull()) |
    (track.isBiggerThanValue(0) & disk.isBiggerThanValue(0));

Expression<bool> clipTimeCondition(Column<int> clip, Column<int> total) =>
    (clip.isNull() | clip.isBetween(const Constant(0), total));

Expression<bool> ratingCondition(Column<double> rating) =>
    rating.isIn([0.0, 0.5, 1.0, 1.5, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0]);

// Data tables
class Tracks extends Table with DateAndId {
  TextColumn get title => text()();
  TextColumn get artistString => text()();
  // IntColumn get trackNumber => integer().nullable().check(
  //   validTrackDiskNumbers(trackNumber, diskNumber),
  // )();
  IntColumn get trackNumber => integer().nullable()();
  // IntColumn get diskNumber => integer().nullable().check(
  //   validTrackDiskNumbers(trackNumber, diskNumber),
  // )();
  IntColumn get diskNumber => integer().nullable()();
  // IntColumn get duration => integer().check(duration.isBiggerThanValue(0))();
  IntColumn get duration => integer()();
  // IntColumn get year => integer().check(positiveOrNull(year))();
  IntColumn get year => integer()();
  // IntColumn get startTime =>
  //     integer().nullable().check(clipTimeCondition(startTime, duration))();
  IntColumn get startTime => integer().nullable()();
  // IntColumn get endTime =>
  //     integer().nullable().check(clipTimeCondition(endTime, duration))();
  IntColumn get endTime => integer().nullable()();
  // RealColumn get rating => real().nullable().check(ratingCondition(rating))();
  RealColumn get rating => real().nullable()();
  IntColumn get albumId => integer().nullable().references(Albums, #id)();
  IntColumn get sourceId => integer().nullable().references(Sources, #id)();
  TextColumn get imagePath => text().nullable()();
  TextColumn get lyricsPath => text().nullable()();
}

class Artists extends Table with Id {
  TextColumn get name => text()();
  TextColumn get originalName => text()();
  TextColumn get imagePath => text()();
}

class Albums extends Table with Id {
  TextColumn get title => text()();
  TextColumn get originalTitle => text().nullable()();
  TextColumn get imagePath => text().nullable()();
}

class Sources extends Table with Id {
  TextColumn get title => text()();
  TextColumn get originalTitle => text().nullable()();
  TextColumn get imagePath => text().nullable()();
}

class Playlists extends Table with Id {
  TextColumn get name => text()();
  TextColumn get imagePath => text()();
}

class Transitions extends Table with DateAndId {
  @ReferenceName("track1Transitions")
  IntColumn get trackId1 => integer().references(Tracks, #id)();
  @ReferenceName("track2Transitions")
  IntColumn get trackId2 => integer().references(Tracks, #id)();
  // IntColumn get fadeoutEnd =>
  //     integer().check(fadeoutEnd.isBiggerOrEqualValue(0))();
  IntColumn get fadeoutEnd => integer()();
  // IntColumn get fadeoutduration =>
  //     integer().check(fadeoutduration.isBiggerOrEqualValue(0))();
  IntColumn get fadeoutduration => integer()();
  // IntColumn get fadeinStart =>
  //     integer().check(fadeinStart.isBiggerOrEqualValue(0))();
  IntColumn get fadeinStart => integer()();
  // IntColumn get fadeinduration =>
  //     integer().check(fadeinduration.isBiggerOrEqualValue(0))();
  IntColumn get fadeinduration => integer()();
  RealColumn get delay => real().withDefault(const Constant(0.0))();
  TextColumn get comment => text().nullable()();
  IntColumn get type => intEnum<TransitionType>()();
}

// Enum tables
// enum Mood { banger, battle, bop, chill, epic, exploration, melancholy }
class Moods extends Table with Id {
  TextColumn get label => text()();
}

/*enum Instrument {
  amenDrums,
  bass,
  choir,
  cuivres,
  flute,
  guitare,
  guitareElectrique,
  harpe,
  piano,
  saxophone,
  traditionalJapanese,
  violon,
  voix,
}
*/
class Instruments extends Table with Id {
  TextColumn get label => text()();
}

//enum Language { franch, english, japanese, chaosLanguage, latin }
class Languages extends Table with Id {
  TextColumn get label => text()();
}

// Relation tables
class TrackMoods extends Table with TrackId {
  IntColumn get moodId => integer().references(Moods, #id)();
}

class TrackInstruments extends Table with TrackId {
  IntColumn get instrumentId => integer().references(Instruments, #id)();
}

class TrackSolos extends Table with TrackId {
  IntColumn get instrumentId => integer().references(Instruments, #id)();
}

class TrackLanguages extends Table with TrackId {
  IntColumn get languageId => integer().references(Languages, #id)();
}

class TrackArtists extends Table with TrackId {
  IntColumn get artistId => integer().references(Artists, #id)();
  IntColumn get artistType => intEnum<ArtistType>()();
}

class TrackSafeties extends Table with TrackId {
  IntColumn get safetyId => intEnum<Safety>()();
}

class PlaylistTracks extends Table {
  IntColumn get playlistId => integer().references(Playlists, #id)();
  IntColumn get trackId => integer().references(Tracks, #id)();
}

// Database generate
@DriftDatabase(
  tables: [
    Tracks,
    Artists,
    Albums,
    Sources,
    Playlists,
    Transitions,
    Moods,
    Instruments,
    Languages,
    TrackMoods,
    TrackInstruments,
    TrackSolos,
    TrackLanguages,
    TrackArtists,
    TrackSafeties,
    PlaylistTracks,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'my_database',
      native: DriftNativeOptions(
        // NOTE: For a private database in ~/.local/share/<appName> | .../data/data/<package>/files
        // databaseDirectory: getApplicationSupportDirectory,

        // NOTE: For a public database in ~/Documents | .../data/data/<package>/app_flutter
        // databaseDirectory: getApplicationDocumentsDirectory,

        // NOTE: For perfect control of the db path
        databasePath: () async {
          final dir = Directory('lib/desktop/db');
          await dir.create(recursive: true);
          return '${dir.path}/db.sqlite';
        },
      ),
      // TODO: Set this up correctly
      // If you need web support, see https://drift.simonbinder.eu/platforms/web/
    );
  }
}
