part of 'queries.dart';

Future<void> _updateAllMoods() async {
  final moods = await (database.select(database.moods)).get();
  DbQuery._allMoods = moods
      .map((row) => obj.Mood(mood: row.label, id: row.id))
      .toList();
}

Future<int> _upsertMood({required obj.Mood mood}) async {
  final moodId = await database
      .into(database.moods)
      .insertOnConflictUpdate(
        MoodsCompanion.insert(
          id: Value.absentIfNull(mood.id),
          label: mood.mood,
        ),
      );

  await _updateAllMoods();

  return moodId;
}

Future<void> _updateAllInstruments() async {
  final instruments = await (database.select(database.instruments)).get();
  DbQuery._allInstruments = instruments
      .map((row) => obj.Instrument(instrument: row.label, id: row.id))
      .toList();
}

Future<int> _upsertInstrument({required obj.Instrument instrument}) async {
  final instrumentId = await database
      .into(database.instruments)
      .insertOnConflictUpdate(
        InstrumentsCompanion.insert(
          id: Value.absentIfNull(instrument.id),
          label: instrument.instrument,
        ),
      );

  await _updateAllInstruments();

  return instrumentId;
}

Future<void> _updateAllSafeties() async {
  final safeties = await (database.select(database.safeties)).get();
  DbQuery._allSafeties = safeties
      .map((row) => obj.Safety(safety: row.label, id: row.id))
      .toList();
}

Future<int> _upsertSafety({required obj.Safety safety}) async {
  final safetyId = await database
      .into(database.safeties)
      .insertOnConflictUpdate(
        SafetiesCompanion.insert(
          id: Value.absentIfNull(safety.id),
          label: safety.safety,
        ),
      );

  await _updateAllSafeties();

  return safetyId;
}
