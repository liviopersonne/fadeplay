import 'package:drift/drift.dart';
import 'package:fadeplay/desktop/db/schemas/mixins.dart';
import 'enum_tables.dart';
import 'data_tables.dart';
import 'enums.dart';

// TODO: Add indexes on each column for faster searching

class TrackMoods extends Table with TrackId {
  IntColumn get moodId => integer().references(
    Moods,
    #id,
    onUpdate: KeyAction.cascade,
    onDelete: KeyAction.cascade,
  )();

  @override
  List<Set<Column>>? get uniqueKeys => [
    {trackId, moodId},
  ];
}

class TrackInstruments extends Table with TrackId {
  IntColumn get instrumentId => integer().references(
    Instruments,
    #id,
    onUpdate: KeyAction.cascade,
    onDelete: KeyAction.cascade,
  )();

  @override
  List<Set<Column>>? get uniqueKeys => [
    {trackId, instrumentId},
  ];
}

class TrackSolos extends Table with TrackId {
  IntColumn get instrumentId => integer().references(
    Instruments,
    #id,
    onUpdate: KeyAction.cascade,
    onDelete: KeyAction.cascade,
  )();

  @override
  List<Set<Column>>? get uniqueKeys => [
    {trackId, instrumentId},
  ];
}

class TrackLanguages extends Table with TrackId {
  IntColumn get languageId => integer().references(
    Languages,
    #id,
    onUpdate: KeyAction.cascade,
    onDelete: KeyAction.cascade,
  )();

  @override
  List<Set<Column>>? get uniqueKeys => [
    {trackId, languageId},
  ];
}

class TrackArtists extends Table with TrackId {
  IntColumn get artistId => integer().references(
    Artists,
    #id,
    onUpdate: KeyAction.cascade,
    onDelete: KeyAction.cascade,
  )();
  IntColumn get artistRole => intEnum<ArtistRole>()();

  @override
  List<Set<Column>>? get uniqueKeys => [
    {trackId, artistId},
  ];
}

class TrackSafeties extends Table with TrackId {
  IntColumn get safetyId => intEnum<Safety>()();
  @override
  List<Set<Column>>? get uniqueKeys => [
    {trackId, safetyId},
  ];
}

class PlaylistTracks extends Table {
  IntColumn get playlistId => integer().references(
    Playlists,
    #id,
    onUpdate: KeyAction.cascade,
    onDelete: KeyAction.cascade,
  )();
  IntColumn get trackId => integer().references(
    Tracks,
    #id,
    onUpdate: KeyAction.cascade,
    onDelete: KeyAction.cascade,
  )();

  @override
  List<Set<Column>>? get uniqueKeys => [
    {playlistId, trackId},
  ];
}
