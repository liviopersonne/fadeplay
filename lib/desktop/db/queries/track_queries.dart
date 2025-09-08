part of 'queries.dart';

Future<List<obj.Track>> _getTracks({
  List<OrderingTerm Function(db.$TracksTable u)>? orderBy,
  Expression<bool> Function(db.$TracksTable u)? filter,
}) async {
  final query = database.select(database.tracks);

  if (filter != null) {
    query.where(filter);
  }

  if (orderBy != null) {
    query.orderBy(orderBy);
  }

  // FIXME: Replace with left joins
  final fullQuery = query.join([
    innerJoin(
      database.albums,
      database.albums.id.equalsExp(database.tracks.albumId),
    ),
    innerJoin(
      database.sources,
      database.sources.id.equalsExp(database.tracks.sourceId),
    ),
  ]);

  final artistsQuery = query.join([
    innerJoin(
      database.trackArtists,
      database.trackArtists.trackId.equalsExp(database.tracks.id),
    ),
    innerJoin(
      database.artists,
      database.artists.id.equalsExp(database.trackArtists.artistId),
    ),
  ]);

  final moodsQuery = query.join([
    innerJoin(
      database.trackMoods,
      database.trackMoods.trackId.equalsExp(database.tracks.id),
    ),
    innerJoin(
      database.moods,
      database.moods.id.equalsExp(database.trackMoods.moodId),
    ),
  ]);

  final instrumentsQuery = query.join([
    innerJoin(
      database.trackInstruments,
      database.trackInstruments.trackId.equalsExp(database.tracks.id),
    ),
    innerJoin(
      database.instruments,
      database.instruments.id.equalsExp(database.trackInstruments.instrumentId),
    ),
  ]);

  final safetiesQuery = query.join([
    innerJoin(
      database.trackSafeties,
      database.trackSafeties.trackId.equalsExp(database.tracks.id),
    ),
  ]);

  final allRows = await fullQuery.get();

  final allTracks = <obj.Track>[];

  // TODO: Do a single query with multiple joins and then multiple wheres

  for (var row in allRows) {
    final track = row.readTable(database.tracks);
    final source = row.readTable(database.sources);
    final album = row.readTable(database.albums);
    final artists =
        await (artistsQuery..where(database.tracks.id.equals(track.id))).get();
    final moods = await (moodsQuery..where(database.tracks.id.equals(track.id)))
        .get();
    final instruments =
        await (instrumentsQuery..where(database.tracks.id.equals(track.id)))
            .get();
    final safeties =
        await (safetiesQuery..where(database.tracks.id.equals(track.id))).get();

    allTracks.add(
      obj.Track(
        id: track.id,
        createdAt: track.creationTime,
        title: track.title,
        originalTitle: track.originalTitle,
        fileUri: Uri.parse(track.filePath),
        artistString: track.artistString,
        trackNumber: track.trackNumber,
        trackTotal: track.trackTotal,
        diskNumber: track.diskNumber,
        diskTotal: track.diskTotal,
        releaseYear: track.year,
        imageUri: track.imagePath != null ? Uri.parse(track.imagePath!) : null,
        lyricsUri: track.lyricsPath != null
            ? Uri.parse(track.lyricsPath!)
            : null,
        startTime: track.startTime != null
            ? Duration(milliseconds: track.startTime!)
            : null,
        endTime: track.endTime != null
            ? Duration(milliseconds: track.endTime!)
            : null,
        rating: track.rating != null ? track.rating! / 2 : null,
        source: obj.Source(
          title: source.title,
          originalTitle: source.originalTitle,
          imageUri: source.imagePath != null
              ? Uri.parse(source.imagePath!)
              : null,
        ),
        album: obj.Album(
          title: album.title,
          originalTitle: album.originalTitle,
          imageUri: album.imagePath != null
              ? Uri.parse(album.imagePath!)
              : null,
        ),

        artists: Map.fromEntries(
          artists.map((row) {
            final artist = row.readTable(database.artists);
            return MapEntry(
              obj.Artist(
                name: artist.name,
                originalName: artist.originalName,
                imageUri: artist.imagePath != null
                    ? Uri.parse(artist.imagePath!)
                    : null,
              ),
              row.readTable(database.trackArtists).artistRole,
            );
          }),
        ),

        moods: moods.map((r) {
          final m = r.readTable(database.moods);
          return obj.Mood(mood: m.label, id: m.id);
        }).toList(),
        instruments: instruments.map((r) {
          final i = r.readTable(database.instruments);
          return obj.Instrument(instrument: i.label, id: i.id);
        }).toList(),
        safeties: safeties.map((r) {
          final s = r.readTable(database.safeties);
          return obj.Safety(safety: s.label, id: s.id);
        }).toList(),
      ),
    );
  }
  return allTracks;
}

Future<int> _upsertTrack({required obj.Track track}) async {
  final albumId = await upsertDependancy(
    dependancy: track.album,
    upsertFunction: (album) => _upsertAlbum(album: album),
  );

  final sourceId = await upsertDependancy(
    dependancy: track.source,
    upsertFunction: (source) => _upsertSource(source: source),
  );

  // delete all existing m-n links: artists, moods, instruments, safeties
  if (track.id != null) {
    await (database.delete(
      database.trackArtists,
    )..where((row) => row.trackId.equals(track.id!))).go();

    await (database.delete(
      database.trackMoods,
    )..where((row) => row.trackId.equals(track.id!))).go();

    await (database.delete(
      database.trackInstruments,
    )..where((row) => row.trackId.equals(track.id!))).go();

    await (database.delete(
      database.trackSafeties,
    )..where((row) => row.trackId.equals(track.id!))).go();
  }

  final trackId = await database
      .into(database.tracks)
      .insertOnConflictUpdate(
        db.TracksCompanion.insert(
          id: Value.absentIfNull(track.id),
          creationTime: Value.absentIfNull(track.createdAt),
          duration: track.duration.inMilliseconds,
          title: track.title,
          filePath: track.fileUri.toString(),
          artistString: track.artistString ?? "Unknown Artist",
          albumId: Value(albumId),
          trackNumber: Value(track.trackNumber),
          trackTotal: Value(track.trackTotal),
          diskNumber: Value(track.diskNumber),
          diskTotal: Value(track.diskTotal),
          startTime: Value(track.startTime?.inMilliseconds),
          endTime: Value(track.endTime?.inMilliseconds),
          year: Value(track.releaseYear),
          originalTitle: Value(track.originalTitle),
          rating: Value(
            track.rating != null ? (track.rating! * 2).round() : null,
          ),
          sourceId: Value(sourceId),
          imagePath: Value(track.imageUri?.toString()),
          lyricsPath: Value(track.lyricsUri?.toString()),
        ),
      );

  // create all new m-n links: artists, moods, instruments, safeties
  track.artists.forEach((artist, role) async {
    database
        .into(database.trackArtists)
        .insert(
          TrackArtistsCompanion.insert(
            trackId: trackId,
            artistId: artist.id ?? await _upsertArtist(artist: artist),
            artistRole: role,
          ),
        );
  });
  for (obj.Mood mood in track.moods) {
    final moodId = mood.id ?? await _upsertMood(mood: mood);
    await database
        .into(database.trackMoods)
        .insert(TrackMoodsCompanion.insert(trackId: trackId, moodId: moodId));
  }
  for (obj.Instrument instrument in track.instruments) {
    final instrumentId =
        instrument.id ?? await _upsertInstrument(instrument: instrument);
    await database
        .into(database.trackInstruments)
        .insert(
          TrackInstrumentsCompanion.insert(
            trackId: trackId,
            instrumentId: instrumentId,
          ),
        );
  }
  for (obj.Safety safety in track.safeties) {
    final safetyId = safety.id ?? await _upsertSafety(safety: safety);
    await database
        .into(database.trackSafeties)
        .insert(
          TrackSafetiesCompanion.insert(trackId: trackId, safetyId: safetyId),
        );
  }

  return trackId;
}
