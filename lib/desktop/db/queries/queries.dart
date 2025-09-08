import 'package:drift/drift.dart';
import 'package:fadeplay/desktop/data/has_id.dart';
import 'package:fadeplay/desktop/data/tracks/album.dart' as obj;
import 'package:fadeplay/desktop/data/tracks/artist.dart' as obj;
import 'package:fadeplay/desktop/data/tracks/playlist_folder.dart' as obj;
import 'package:fadeplay/desktop/data/tracks/playlist.dart' as obj;
import 'package:fadeplay/desktop/data/tracks/source.dart' as obj;
import 'package:fadeplay/desktop/data/tracks/track.dart' as obj;
import 'package:fadeplay/desktop/data/tracks/mood.dart' as obj;
import 'package:fadeplay/desktop/data/tracks/instrument.dart' as obj;
import 'package:fadeplay/desktop/data/tracks/safety.dart' as obj;
import 'package:fadeplay/desktop/data/mixes/transition.dart' as obj;
import 'package:fadeplay/desktop/db/schemas.dart' as db;
import 'package:fadeplay/desktop/db/schemas.dart';
import 'package:fadeplay/desktop/objects/logger.dart';

part 'album_queries.dart';
part 'artist_queries.dart';
part 'playlist_folder_queries.dart';
part 'playlist_queries.dart';
part 'source_queries.dart';
part 'track_queries.dart';
part 'transition_queries.dart';
part 'enum_queries.dart';

final logger = Logging("DbQuery");
final database = db.AppDatabase();

// FIXME: Check if some `final` attributes are upserted, and if so, separate update and insert

/// A class that wraps all queries made to the database
class DbQuery {
  DbQuery._();

  static List<obj.Mood> allMoods = [];
  // ignore: non_constant_identifier_names, unused_field
  static final __ = _updateAllMoods();
  static List<obj.Instrument> allInstruments = [];
  // ignore: non_constant_identifier_names, unused_field
  static final ___ = _updateAllInstruments();
  static List<obj.Safety> allSafeties = [];
  // ignore: non_constant_identifier_names, unused_field
  static final ____ = _updateAllSafeties();

  static Future<int> upsertMood({required obj.Mood mood}) =>
      _upsertMood(mood: mood);

  static Future<int> upsertInstrument({required obj.Instrument instrument}) =>
      _upsertInstrument(instrument: instrument);

  static Future<int> upsertSafety({required obj.Safety safety}) =>
      _upsertSafety(safety: safety);

  static Future<List<obj.Album>> getAlbums({
    List<OrderingTerm Function(db.$AlbumsTable u)>? orderBy,
    Expression<bool> Function(db.$AlbumsTable u)? filter,
  }) => _getAlbums(orderBy: orderBy, filter: filter);

  static Future<int> upsertAlbum({required obj.Album album}) =>
      _upsertAlbum(album: album);

  static Future<List<obj.Artist>> getArtists({
    List<OrderingTerm Function(db.$ArtistsTable u)>? orderBy,
    Expression<bool> Function(db.$ArtistsTable u)? filter,
  }) => _getArtists(orderBy: orderBy, filter: filter);

  static Future<int> upsertArtist({required obj.Artist artist}) =>
      _upsertArtist(artist: artist);

  static Future<obj.PlaylistFolder> getPlaylistFolder({required int id}) =>
      _getPlaylistFolder(id: id);

  static Future<List<obj.PlaylistFolder>> getPlaylistFolders({
    List<OrderingTerm Function(db.$PlaylistFolderTable u)>? orderBy,
    Expression<bool> Function(db.$PlaylistFolderTable u)? filter,
  }) => _getPlaylistFolders(orderBy: orderBy, filter: filter);

  static Future<int> upsertPlaylistFolder({
    required obj.PlaylistFolder folder,
  }) => _upsertPlaylistFolder(folder: folder);

  static Future<List<obj.Playlist>> getPlaylists({
    List<OrderingTerm Function(db.$PlaylistsTable u)>? orderBy,
    Expression<bool> Function(db.$PlaylistsTable u)? filter,
  }) => _getPlaylists(orderBy: orderBy, filter: filter);

  static Future<int> upsertPlaylist({required obj.Playlist playlist}) =>
      _upsertPlaylist(playlist: playlist);

  static Future<List<obj.Source>> getSources({
    List<OrderingTerm Function(db.$SourcesTable u)>? orderBy,
    Expression<bool> Function(db.$SourcesTable u)? filter,
  }) => _getSources(orderBy: orderBy, filter: filter);

  static Future<int> upsertSource({required obj.Source source}) =>
      _upsertSource(source: source);

  static Future<List<obj.Track>> getTracks({
    List<OrderingTerm Function(db.$TracksTable u)>? orderBy,
    Expression<bool> Function(db.$TracksTable u)? filter,
  }) => _getTracks(orderBy: orderBy, filter: filter);

  static Future<int> upsertTrack({required obj.Track track}) =>
      _upsertTrack(track: track);

  static Future<List<obj.Transition>> getTransition({
    List<OrderingTerm Function(db.$TransitionsTable u)>? orderBy,
    Expression<bool> Function(db.$TransitionsTable u)? filter,
  }) => _getTransitions(orderBy: orderBy, filter: filter);

  static Future<int> upsertTransition({required obj.Transition transition}) =>
      _upsertTransition(transition: transition);
}

/// Inserts or updates a dependancy in a row, if it exists
Future<int?> upsertDependancy<T extends HasId>({
  required T? dependancy,
  required Future<int> Function(T) upsertFunction,
}) async {
  if (dependancy != null) {
    // there is a dependancy
    if (dependancy.id == null) {
      // the dependancy's not been saved to db yet
      return await upsertFunction(dependancy);
    } else {
      // the dependancy's already in db
      return dependancy.id;
    }
  }
  // there is no dependancy
  return null;
}
