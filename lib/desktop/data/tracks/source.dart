/// An source and its metadata.
/// A source is a piece of media (film, video game) which has an ost.
class Source {
  String title;
  String? originalTitle;
  Uri? imageUri;

  Source({required this.title, this.originalTitle, this.imageUri});
}
