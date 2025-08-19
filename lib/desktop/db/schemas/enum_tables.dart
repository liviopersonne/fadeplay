import 'package:drift/drift.dart';
import 'mixins.dart';

// enum Mood { banger, battle, bop, chill, epic, exploration, melancholy }
class Moods extends Table with Id {
  TextColumn get label => text()();
}

/*enum Instrument {
  amenDrums,
  bass,
  choir,
  cuivres,
  flute,
  guitare,
  guitareElectrique,
  harpe,
  piano,
  saxophone,
  traditionalJapanese,
  violon,
  voix,
}
*/
class Instruments extends Table with Id {
  TextColumn get label => text()();
}

//enum Language { franch, english, japanese, chaosLanguage, latin }
class Languages extends Table with Id {
  TextColumn get label => text()();
}
