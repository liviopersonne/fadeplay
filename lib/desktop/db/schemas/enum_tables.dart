import 'package:drift/drift.dart';
import 'mixins.dart';

class Moods extends Table with Id {
  TextColumn get label => text().unique()();
}

class Instruments extends Table with Id {
  TextColumn get label => text().unique()();
}

class Languages extends Table with Id {
  TextColumn get label => text().unique()();
}

class Safeties extends Table with Id {
  TextColumn get label => text().unique()();
}
