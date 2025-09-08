import 'package:fadeplay/desktop/data/has_id.dart';

class Instrument extends HasId {
  @override
  final int? id;
  final String instrument;

  Instrument({this.id, required this.instrument});
}
