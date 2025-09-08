part of 'queries.dart';

Future<obj.PlaylistFolder> _getPlaylistFolder({required int id}) async {
  final query = database.select(database.playlistFolder)
    ..where((tbl) => tbl.id.equals(id));

  final folder = await query.getSingle();

  return obj.PlaylistFolder(
    name: folder.name,
    id: folder.id,
    imageUri: folder.imagePath != null ? Uri.parse(folder.imagePath!) : null,
    getContainingFolder: folder.containingFolderId != null
        ? () => _getPlaylistFolder(id: folder.containingFolderId!)
        : null,
  );
}

Future<List<obj.PlaylistFolder>> _getPlaylistFolders({
  List<OrderingTerm Function(db.$PlaylistFolderTable u)>? orderBy,
  Expression<bool> Function(db.$PlaylistFolderTable u)? filter,
}) async {
  final query = database.select(database.playlistFolder);

  if (filter != null) {
    query.where(filter);
  }

  if (orderBy != null) {
    query.orderBy(orderBy);
  }

  final allPlaylistFolders = await query.get();

  return allPlaylistFolders
      .map(
        (f) => obj.PlaylistFolder(
          name: f.name,
          id: f.id,
          imageUri: f.imagePath != null ? Uri.parse(f.imagePath!) : null,
          getContainingFolder: f.containingFolderId != null
              ? () => _getPlaylistFolder(id: f.containingFolderId!)
              : null,
        ),
      )
      .toList();
}

Future<int> _upsertPlaylistFolder({required obj.PlaylistFolder folder}) async {
  final containingFolder = await folder.getContainingFolder?.call();
  int? containingFolderId;
  if (containingFolder != null) {
    // playlist has a containingFolder
    if (containingFolder.id == null) {
      // playlist has a containingFolder but it's not been saved to db yet
      containingFolderId = await _upsertPlaylistFolder(
        folder: containingFolder,
      );
    } else {
      // playlist has a containingFolder in db
      containingFolderId = containingFolder.id;
    }
  }

  return await database
      .into(database.playlistFolder)
      .insertOnConflictUpdate(
        db.PlaylistFolderCompanion.insert(
          id: Value.absentIfNull(folder.id),
          name: folder.name,
          containingFolderId: Value(containingFolderId),
          imagePath: Value(folder.imageUri?.toString()),
        ),
      );
}
