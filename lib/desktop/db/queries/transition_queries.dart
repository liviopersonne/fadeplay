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

  final track1Alias = database.alias(database.tracks, 't1');
  final track2Alias = database.alias(database.tracks, 't2');

  final joinedQuery = query.join([
    innerJoin(
      track1Alias,
      track1Alias.id.equalsExp(database.transitions.trackId1),
    ),
    innerJoin(
      track2Alias,
      track2Alias.id.equalsExp(database.transitions.trackId2),
    ),
  ]);

  final allTransitions = await joinedQuery.get();

  final allTransitionObjects = <obj.Transition>[];

  for (var row in allTransitions) {
    final transition = row.readTable(database.transitions);
    final track1 = row.readTable(track1Alias);
    final track2 = row.readTable(track2Alias);
    allTransitionObjects.add(
      obj.Transition(
        id: transition.id,
        createdAt: transition.creationTime,
        type: transition.type,
        comment: transition.comment,
        delay: Duration(milliseconds: transition.delay),
        fadeinStart: Duration(milliseconds: transition.fadeinStart),
        fadeinDuration: Duration(milliseconds: transition.fadeinduration),
        fadeoutEnd: Duration(milliseconds: transition.fadeoutEnd),
        fadeoutDuration: Duration(milliseconds: transition.fadeoutduration),
        track1: obj.Track(
          id: track1.id,
          createdAt: track1.creationTime,
          title: track1.title,
          originalTitle: track1.originalTitle,
          fileUri: Uri.parse(track1.filePath),
          artistString: track1.artistString,
          trackNumber: track1.trackNumber,
          trackTotal: track1.trackTotal,
          diskNumber: track1.diskNumber,
          diskTotal: track1.diskTotal,
          imageUri: track1.imagePath != null
              ? Uri.parse(track1.imagePath!)
              : null,
          startTime: track1.startTime != null
              ? Duration(milliseconds: track1.startTime!)
              : null,
          endTime: track1.endTime != null
              ? Duration(milliseconds: track1.endTime!)
              : null,
          lyricsUri: track1.lyricsPath != null
              ? Uri.parse(track1.lyricsPath!)
              : null,
          releaseYear: track1.year,
          rating: track1.rating != null ? track1.rating! / 2 : null,
        ),
        track2: obj.Track(
          id: track2.id,
          createdAt: track2.creationTime,
          title: track2.title,
          originalTitle: track2.originalTitle,
          fileUri: Uri.parse(track2.filePath),
          artistString: track2.artistString,
          trackNumber: track2.trackNumber,
          trackTotal: track2.trackTotal,
          diskNumber: track2.diskNumber,
          diskTotal: track2.diskTotal,
          imageUri: track2.imagePath != null
              ? Uri.parse(track2.imagePath!)
              : null,
          startTime: track2.startTime != null
              ? Duration(milliseconds: track2.startTime!)
              : null,
          endTime: track2.endTime != null
              ? Duration(milliseconds: track2.endTime!)
              : null,
          lyricsUri: track2.lyricsPath != null
              ? Uri.parse(track2.lyricsPath!)
              : null,
          releaseYear: track2.year,
          rating: track2.rating != null ? track2.rating! / 2 : null,
        ),
      ),
    );
  }

  return allTransitionObjects;
}

Future<int> _upsertTransition({required obj.Transition transition}) async {
  logger.check(
    transition.track1.id != null,
    message: "Track1 of the transition isn't in the database",
    raiseError: true,
  );
  logger.check(
    transition.track2.id != null,
    message: "Track2 of the transition isn't in the database",
    raiseError: true,
  );
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
          trackId1: transition.track1.id!,
          trackId2: transition.track2.id!,
          type: transition.type,
          comment: Value(transition.comment),
        ),
      );
}
