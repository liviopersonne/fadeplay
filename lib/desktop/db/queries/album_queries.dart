part of 'queries.dart';

Future<List<obj.Album>> _getAlbums({
  List<OrderingTerm Function(db.$SourcesTable u)>? orderBy,
  Expression<bool> Function(db.$SourcesTable u)? filter,
}) => throw UnimplementedError();

Future<void> _upsertAlbum({required obj.Album album}) =>
    throw UnimplementedError();
