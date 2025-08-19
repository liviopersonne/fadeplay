import 'package:drift/drift.dart';
import 'package:fadeplay/desktop/db/schemas/mixins.dart';
import 'enum_tables.dart';
import 'data_tables.dart';
import 'enums.dart';

class TrackMoods extends Table with TrackId {
  IntColumn get moodId => integer().references(
    Moods,
    #id,
    onUpdate: KeyAction.cascade,
    onDelete: KeyAction.cascade,
  )();
}

class TrackInstruments extends Table with TrackId {
  IntColumn get instrumentId => integer().references(
    Instruments,
    #id,
    onUpdate: KeyAction.cascade,
    onDelete: KeyAction.cascade,
  )();
}

class TrackSolos extends Table with TrackId {
  IntColumn get instrumentId => integer().references(
    Instruments,
    #id,
    onUpdate: KeyAction.cascade,
    onDelete: KeyAction.cascade,
  )();
}

class TrackLanguages extends Table with TrackId {
  IntColumn get languageId => integer().references(
    Languages,
    #id,
    onUpdate: KeyAction.cascade,
    onDelete: KeyAction.cascade,
  )();
}

class TrackArtists extends Table with TrackId {
  IntColumn get artistId => integer().references(
    Artists,
    #id,
    onUpdate: KeyAction.cascade,
    onDelete: KeyAction.cascade,
  )();
  IntColumn get artistType => intEnum<ArtistType>()();
}

class TrackSafeties extends Table with TrackId {
  IntColumn get safetyId => intEnum<Safety>()();
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
}
