part of 'queries.dart';

Future<List<obj.PlaylistFolder>> _getPlaylistFolders({
  List<OrderingTerm Function(db.$SourcesTable u)>? orderBy,
  Expression<bool> Function(db.$SourcesTable u)? filter,
}) => throw UnimplementedError();

Future<void> _upsertPlaylistFolder({required obj.PlaylistFolder folder}) =>
    throw UnimplementedError();
