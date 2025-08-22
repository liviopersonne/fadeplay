/// An album and its metadata
class Album {
  String title;
  String? originalTitle;
  Uri? imageUri;

  Album({required this.title, this.originalTitle, this.imageUri});
}
