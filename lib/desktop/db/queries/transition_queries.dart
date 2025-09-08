part of 'queries.dart';

Future<List<obj.Transition>> _getTransitions({
  List<OrderingTerm Function(db.$TransitionsTable u)>? orderBy,
  Expression<bool> Function(db.$TransitionsTable u)? filter,
}) async {
  final query = database.select(database.transitions);

  if (filter != null) {
    query.where(filter);
  }

  if (orderBy != null) {
    query.orderBy(orderBy);
  }

  final allTransitions = await query.get();

  final allTransitionObjects = <obj.Transition>[];

  for (var row in allTransitions) {
    allTransitionObjects.add(
      obj.Transition(
        id: row.id,
        createdAt: row.creationTime,
        type: row.type,
        comment: row.comment,
        delay: Duration(milliseconds: row.delay),
        fadeinStart: Duration(milliseconds: row.fadeinStart),
        fadeinDuration: Duration(milliseconds: row.fadeinduration),
        fadeoutEnd: Duration(milliseconds: row.fadeoutEnd),
        fadeoutDuration: Duration(milliseconds: row.fadeoutduration),
        track1: (await _getTracks(
          filter: (t) => t.id.equals(row.trackId1),
        )).first,
        track2: (await _getTracks(
          filter: (t) => t.id.equals(row.trackId2),
        )).first,
      ),
    );
  }

  return allTransitionObjects;
}

Future<int> _upsertTransition({required obj.Transition transition}) async {
  return await database
      .into(database.transitions)
      .insertOnConflictUpdate(
        db.TransitionsCompanion.insert(
          id: Value.absentIfNull(transition.id),
          creationTime: Value.absentIfNull(transition.createdAt),
          fadeinStart: transition.fadeinStart.inMilliseconds,
          fadeinduration: transition.fadeinDuration.inMilliseconds,
          fadeoutEnd: transition.fadeoutEnd.inMilliseconds,
          fadeoutduration: transition.fadeoutDuration.inMilliseconds,
          delay: Value(transition.delay.inMilliseconds),
          trackId1:
              transition.track1.id ??
              await _upsertTrack(track: transition.track1),
          trackId2:
              transition.track2.id ??
              await _upsertTrack(track: transition.track2),
          type: transition.type,
          comment: Value(transition.comment),
        ),
      );
}
