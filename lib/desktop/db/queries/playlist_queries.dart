part of 'queries.dart';

/// `recursiveFolderLevel` represents the number of containing folders that are fetched
/// it it is null, then we fetch all containing folders
Future<List<obj.Playlist>> _getPlaylists({
  List<OrderingTerm Function(db.$PlaylistsTable u)>? orderBy,
  Expression<bool> Function(db.$PlaylistsTable u)? filter,
}) async {
  final singleQuery = database.select(database.playlists);

  if (filter != null) {
    singleQuery.where(filter);
  }

  if (orderBy != null) {
    singleQuery.orderBy(orderBy);
  }

  final allPlaylists = await singleQuery.get();

  return allPlaylists.map((p) {
    return obj.Playlist(
      id: p.id,
      name: p.name,
      imageUri: p.imagePath != null ? Uri.parse(p.imagePath!) : null,
      getContainingFolder: p.containingFolderId != null
          ? () => _getPlaylistFolder(id: p.containingFolderId!)
          : null,
      getTracks: throw UnimplementedError(), // FIXME: Fetch tracks
    );
  }).toList();
}

Future<int> _upsertPlaylist({required obj.Playlist playlist}) async {
  final folderId = await upsertDependancy(
    dependancy: await playlist.getContainingFolder?.call(),
    upsertFunction: (folder) => _upsertPlaylistFolder(folder: folder),
  );

  return await database
      .into(database.playlists)
      .insertOnConflictUpdate(
        db.PlaylistsCompanion.insert(
          id: Value.absentIfNull(playlist.id),
          name: playlist.name,
          containingFolderId: Value(folderId),
          imagePath: Value(playlist.imageUri?.toString()),
        ),
      );
}
