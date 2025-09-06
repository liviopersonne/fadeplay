part of 'queries.dart';

Future<List<obj.Playlist>> _getPlaylists({
  List<OrderingTerm Function(db.$SourcesTable u)>? orderBy,
  Expression<bool> Function(db.$SourcesTable u)? filter,
}) => throw UnimplementedError();

Future<void> _upsertPlaylist({required obj.Playlist playlist}) =>
    throw UnimplementedError();
