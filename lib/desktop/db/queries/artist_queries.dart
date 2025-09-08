part of 'queries.dart';

Future<List<obj.Artist>> _getArtists({
  List<OrderingTerm Function(db.$ArtistsTable u)>? orderBy,
  Expression<bool> Function(db.$ArtistsTable u)? filter,
}) async {
  final query = database.select(database.artists);

  if (filter != null) {
    query.where(filter);
  }

  if (orderBy != null) {
    query.orderBy(orderBy);
  }

  final allArtists = await query.get();

  return allArtists
      .map(
        (a) => obj.Artist(
          name: a.name,
          originalName: a.originalName,
          imageUri: a.imagePath != null ? Uri.parse(a.imagePath!) : null,
        ),
      )
      .toList();
}

Future<int> _upsertArtist({required obj.Artist artist}) async {
  return await database
      .into(database.artists)
      .insertOnConflictUpdate(
        db.ArtistsCompanion.insert(
          name: artist.name,
          originalName: Value(artist.originalName),
          imagePath: Value(artist.imageUri?.toString()),
        ),
      );
}
