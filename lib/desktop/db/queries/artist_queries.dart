part of 'queries.dart';

Future<List<obj.Artist>> _getArtists({
  List<OrderingTerm Function(db.$SourcesTable u)>? orderBy,
  Expression<bool> Function(db.$SourcesTable u)? filter,
}) => throw UnimplementedError();

Future<void> _upsertArtist({required obj.Artist artist}) =>
    throw UnimplementedError();
