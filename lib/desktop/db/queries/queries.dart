import 'package:drift/drift.dart';
import 'package:fadeplay/desktop/data/tracks/album.dart' as obj;
import 'package:fadeplay/desktop/data/tracks/artist.dart' as obj;
import 'package:fadeplay/desktop/data/tracks/playlist_folder.dart' as obj;
import 'package:fadeplay/desktop/data/tracks/playlist.dart' as obj;
import 'package:fadeplay/desktop/data/tracks/source.dart' as obj;
import 'package:fadeplay/desktop/data/tracks/track.dart' as obj;
import 'package:fadeplay/desktop/data/mixes/transition.dart' as obj;
import 'package:fadeplay/desktop/db/schemas.dart' as db;
import 'package:fadeplay/desktop/objects/logger.dart';

part 'source_queries.dart';

final logger = Logging("DbQuery");

/// A class that wraps all queries made to the database
class DbQuery {
  DbQuery._();

  static Future<List<obj.Album>> getAlbums({
    List<OrderingTerm Function(db.$SourcesTable u)>? orderBy,
    Expression<bool> Function(db.$SourcesTable u)? filter,
  }) => throw UnimplementedError();

  static Future<void> upsertAlbum({required obj.Album album}) =>
      throw UnimplementedError();

  static Future<List<obj.Artist>> getArtists({
    List<OrderingTerm Function(db.$SourcesTable u)>? orderBy,
    Expression<bool> Function(db.$SourcesTable u)? filter,
  }) => throw UnimplementedError();

  static Future<void> upsertArtist({required obj.Artist artist}) =>
      throw UnimplementedError();

  static Future<List<obj.PlaylistFolder>> getPlaylistFolders({
    List<OrderingTerm Function(db.$SourcesTable u)>? orderBy,
    Expression<bool> Function(db.$SourcesTable u)? filter,
  }) => throw UnimplementedError();

  static Future<void> upsertPlaylistFolder({
    required obj.PlaylistFolder folder,
  }) => throw UnimplementedError();

  static Future<List<obj.Playlist>> getPlaylists({
    List<OrderingTerm Function(db.$SourcesTable u)>? orderBy,
    Expression<bool> Function(db.$SourcesTable u)? filter,
  }) => throw UnimplementedError();

  static Future<void> upsertPlaylist({required obj.Playlist playlist}) =>
      throw UnimplementedError();

  static Future<List<obj.Source>> getSources({
    List<OrderingTerm Function(db.$SourcesTable u)>? orderBy,
    Expression<bool> Function(db.$SourcesTable u)? filter,
  }) => _getSources(orderBy: orderBy, filter: filter);

  static Future<void> upsertSource({required obj.Source source}) =>
      _upsertSource(source: source);

  static Future<List<obj.Track>> getTracks({
    List<OrderingTerm Function(db.$SourcesTable u)>? orderBy,
    Expression<bool> Function(db.$SourcesTable u)? filter,
  }) => throw UnimplementedError();

  static Future<void> upsertTrack({required obj.Track track}) =>
      throw UnimplementedError();

  static Future<List<obj.Transition>> getTransition({
    List<OrderingTerm Function(db.$SourcesTable u)>? orderBy,
    Expression<bool> Function(db.$SourcesTable u)? filter,
  }) => throw UnimplementedError();

  static Future<void> upsertTransition({required obj.Transition transition}) =>
      throw UnimplementedError();
}
