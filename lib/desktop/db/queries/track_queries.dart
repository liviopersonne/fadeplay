part of 'queries.dart';

Future<List<obj.Track>> _getTracks({
  List<OrderingTerm Function(db.$SourcesTable u)>? orderBy,
  Expression<bool> Function(db.$SourcesTable u)? filter,
}) => throw UnimplementedError();

Future<void> _upsertTrack({required obj.Track track}) =>
    throw UnimplementedError();
