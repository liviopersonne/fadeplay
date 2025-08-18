import 'package:drift/drift.dart';

part 'schemas.g.dart';

// Mixins
mixin Id on Table {
  late final id = integer().autoIncrement()();
}

mixin DateAndId on Table {
  late final id = integer().autoIncrement()();
  late final creationTime = dateTime().withDefault(currentDateAndTime)();
}

mixin TrackId on Table {
  late final trackId = integer().references(Tracks, #id)();
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
  late final title = text()();
  late final artistString = text()();
  late final Column<int> trackNumber = integer().nullable().check(
    validTrackDiskNumbers(trackNumber, diskNumber),
  )();
  late final Column<int> diskNumber = integer().nullable().check(
    validTrackDiskNumbers(trackNumber, diskNumber),
  )();
  late final Column<int> duration = integer().check(
    duration.isBiggerThanValue(0),
  )();
  late final Column<int> year = integer().check(positiveOrNull(year))();
  late final Column<int> startTime = integer().nullable().check(
    clipTimeCondition(startTime, duration),
  )();
  late final Column<int> endTime = integer().nullable().check(
    clipTimeCondition(endTime, duration),
  )();
  late final Column<double> rating = real().nullable().check(
    ratingCondition(rating),
  )();
  late final albumId = integer().nullable().references(Albums, #id)();
  late final sourceId = integer().nullable().references(Sources, #id)();
  late final imagePath = text().nullable()();
  late final lyricsPath = text().nullable()();
}

class Artists extends Table with Id {
  late final name = text()();
  late final originalName = text()();
  late final imagePath = text()();
}

class Albums extends Table with Id {
  late final title = text()();
  late final originalTitle = text().nullable()();
  late final imagePath = text().nullable()();
}

class Sources extends Table with Id {
  late final title = text()();
  late final originalTitle = text().nullable()();
  late final imagePath = text().nullable()();
}

class Playlists extends Table with Id {
  late final name = text()();
  late final imagePath = text()();
}

class Transitions extends Table with DateAndId {
  late final trackId1 = integer().references(Tracks, #id)();
  late final trackId2 = integer().references(Tracks, #id)();
  late final Column<int> fadeoutEnd = integer().check(
    fadeoutEnd.isBiggerOrEqualValue(0),
  )();
  late final Column<int> fadeoutduration = integer().check(
    fadeoutEnd.isBiggerOrEqualValue(0),
  )();
  late final Column<int> fadeinStart = integer().check(
    fadeoutEnd.isBiggerOrEqualValue(0),
  )();
  late final Column<int> fadeinduration = integer().check(
    fadeoutEnd.isBiggerOrEqualValue(0),
  )();
  late final delay = real().withDefault(const Constant(0.0))();
  late final comment = text().nullable()();
  late final type = intEnum<TransitionType>()();
}

// Enum tables
// enum Mood { banger, battle, bop, chill, epic, exploration, melancholy }
class Moods extends Table with Id {
  late final label = text()();
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
  late final label = text()();
}

//enum Language { franch, english, japanese, chaosLanguage, latin }
class Languages extends Table with Id {
  late final label = text()();
}

// Relation tables
class TrackMoods extends Table with TrackId {
  late final moodId = integer().references(Moods, #id)();
}

class TrackInstruments extends Table with TrackId {
  late final instrumentId = integer().references(Instruments, #id)();
}

class TrackSolos extends Table with TrackId {
  late final instrumentId = integer().references(Instruments, #id)();
}

class TrackLanguages extends Table with TrackId {
  late final languageId = integer().references(Languages, #id)();
}

class TrackArtists extends Table with TrackId {
  late final artistId = integer().references(Artists, #id)();
  late final artistType = intEnum<ArtistType>()();
}

class TrackSafeties extends Table with TrackId {
  late final safetyId = intEnum<Safety>()();
}

class PlaylistTracks extends Table {
  late final playlistId = integer().references(Playlists, #id);
  late final trackId = integer().references(Tracks, #id)();
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
class AppDatabase extends _$AppDatabase {}
