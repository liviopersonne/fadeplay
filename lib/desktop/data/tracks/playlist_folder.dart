class PlaylistFolder {
  String name;
  Uri? imageUri;
  PlaylistFolder? containingFolder;

  PlaylistFolder({required this.name, this.imageUri, this.containingFolder});

  @override
  bool operator ==(Object other) {
    if (other is PlaylistFolder) {
      return other.name == name || other.containingFolder == containingFolder;
    }
    return false;
  }

  @override
  int get hashCode => name.hashCode + containingFolder.hashCode;
}
