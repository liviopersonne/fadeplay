part of 'queries.dart';

Future<List<obj.Album>> _getAlbums({
  List<OrderingTerm Function(db.$AlbumsTable u)>? orderBy,
  Expression<bool> Function(db.$AlbumsTable u)? filter,
}) async {
  final query = database.select(database.albums);

  if (filter != null) {
    query.where(filter);
  }

  if (orderBy != null) {
    query.orderBy(orderBy);
  }

  final allAlbums = await query.get();

  return allAlbums
      .map(
        (a) => obj.Album(
          id: a.id,
          title: a.title,
          originalTitle: a.originalTitle,
          imageUri: a.imagePath != null ? Uri.parse(a.imagePath!) : null,
        ),
      )
      .toList();
}

Future<int> _upsertAlbum({required obj.Album album}) async {
  return await database
      .into(database.albums)
      .insertOnConflictUpdate(
        db.AlbumsCompanion.insert(
          id: Value.absentIfNull(album.id),
          title: album.title,
          originalTitle: Value(album.originalTitle),
          imagePath: Value(album.imageUri?.toString()),
        ),
      );
}
