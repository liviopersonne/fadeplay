part of 'queries.dart';

Future<List<obj.Transition>> _getTransition({
  List<OrderingTerm Function(db.$SourcesTable u)>? orderBy,
  Expression<bool> Function(db.$SourcesTable u)? filter,
}) => throw UnimplementedError();

Future<void> _upsertTransition({required obj.Transition transition}) =>
    throw UnimplementedError();
