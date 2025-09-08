import 'package:drift/drift.dart';
import 'mixins.dart';
import 'enums.dart';
import 'checks.dart';

class Tracks extends Table with DateAndId {
  TextColumn get title => text()();
  TextColumn get originalTitle => text().nullable()();
  TextColumn get filePath => text().unique()();
  TextColumn get artistString => text()();
  late final IntColumn trackNumber = integer().nullable().check(
    validTrackDiskNumbers(trackNumber, diskNumber),
  )();
  late final IntColumn trackTotal = integer().nullable().check(
    validTrackDiskNumbers(trackTotal, diskTotal),
  )();
  late final IntColumn diskNumber = integer().nullable().check(
    validTrackDiskNumbers(trackNumber, diskNumber),
  )();
  late final IntColumn diskTotal = integer().nullable().check(
    validTrackDiskNumbers(trackTotal, diskTotal),
  )();
  late final IntColumn duration = integer().check(
    duration.isBiggerThanValue(0),
  )();
  late final IntColumn year = integer().nullable().check(
    positiveOrNull(year),
  )();
  late final IntColumn startTime = integer().nullable().check(
    clipTimeCondition(startTime, duration),
  )();
  late final IntColumn endTime = integer().nullable().check(
    clipTimeCondition(endTime, duration),
  )();
  late final IntColumn rating = integer().nullable().check(
    rating.isBetweenValues(0, 10),
  )();
  IntColumn get albumId => integer().nullable().references(
    Albums,
    #id,
    onUpdate: KeyAction.cascade, // if the album's id is modified, albumId too
    onDelete: KeyAction.restrict, // can't delete album if a track has it
  )();
  IntColumn get sourceId => integer().nullable().references(
    Sources,
    #id,
    onUpdate: KeyAction.cascade,
    onDelete: KeyAction.restrict,
  )();
  TextColumn get imagePath => text().nullable()();
  TextColumn get lyricsPath => text().nullable()();
}

class Artists extends Table with DateAndId {
  TextColumn get name => text()();
  TextColumn get originalName => text().nullable()();
  TextColumn get imagePath => text().nullable()();
}

class Albums extends Table with DateAndId {
  TextColumn get title => text()();
  TextColumn get originalTitle => text().nullable()();
  TextColumn get imagePath => text().nullable()();
}

class Sources extends Table with DateAndId {
  TextColumn get title => text()();
  TextColumn get originalTitle => text().nullable()();
  TextColumn get imagePath => text().nullable()();
}

class Playlists extends Table with DateAndId {
  TextColumn get name => text()();
  TextColumn get imagePath => text().nullable()();
  IntColumn get containingFolderId => integer().nullable().references(
    PlaylistFolder,
    #id,
    onUpdate: KeyAction.cascade,
    onDelete: KeyAction
        .cascade, // NOTE: If a playlist group is deleted, all its contained playlists are also deleted
  )();
}

// TODO: Always check that there isn't a circular dependancy
class PlaylistFolder extends Table with DateAndId {
  TextColumn get name => text()();
  TextColumn get imagePath => text().nullable()();
  IntColumn get containingFolderId => integer().nullable().references(
    PlaylistFolder,
    #id,
    onUpdate: KeyAction.cascade,
    onDelete: KeyAction.cascade,
  )();
}

class Transitions extends Table with DateAndId {
  @ReferenceName("track1Transitions")
  IntColumn get trackId1 => integer().references(
    Tracks,
    #id,
    onUpdate: KeyAction.cascade,
    onDelete: KeyAction.cascade,
  )();
  @ReferenceName("track2Transitions")
  IntColumn get trackId2 => integer().references(
    Tracks,
    #id,
    onUpdate: KeyAction.cascade,
    onDelete: KeyAction.cascade,
  )();
  late final IntColumn fadeoutEnd = integer().check(
    fadeoutEnd.isBiggerOrEqualValue(0),
  )();
  late final IntColumn fadeoutduration = integer().check(
    fadeoutduration.isBiggerOrEqualValue(0),
  )();
  late final IntColumn fadeinStart = integer().check(
    fadeinStart.isBiggerOrEqualValue(0),
  )();
  late final IntColumn fadeinduration = integer().check(
    fadeinduration.isBiggerOrEqualValue(0),
  )();
  IntColumn get delay => integer().withDefault(const Constant(0))();
  TextColumn get comment => text().nullable()();
  IntColumn get type => intEnum<TransitionType>()();
}
