import 'package:fadeplay/desktop/objects/column_browser/item_column.dart';
import 'package:fadeplay/desktop/objects/logger.dart';
import 'package:fadeplay/desktop/objects/music_players/single_music_player.dart';
import 'package:fadeplay/desktop/db/schemas.dart';
import 'package:fadeplay/desktop/widgets/test/audio_metadata.dart';
import 'package:fadeplay/desktop/widgets/test/column_browser.dart';
import 'package:fadeplay/desktop/widgets/test/column_selector.dart';
import 'package:fadeplay/desktop/widgets/test/database.dart';
import 'package:fadeplay/desktop/widgets/test/load_full_music.dart';
import 'package:fadeplay/desktop/widgets/test/load_single_music.dart';
import 'package:flutter/material.dart';
import 'package:window_size/window_size.dart';

late final AppDatabase database;

void desktopMain() {
  WidgetsFlutterBinding.ensureInitialized();
  SingleMusicPlayer.initialize(); // for audio playing
  final database = AppDatabase();
  registerAllColumns(); // for the columnBrowser

  setWindowTitle("Fadeplay");
  // setWindowMinSize(Size(300, 300)); // TODO: Set this

  // database
  //     .into(database.tracks)
  //     .insert(
  //       TracksCompanion.insert(
  //         duration: 1,
  //         filePath: "",
  //         title: "Test",
  //         artistString: "Test",
  //       ),
  //     )
  //     .then((value) {
  //       Logging("main").log("Set up database ! $value");
  //     });

  runApp(const DesktopApp());
}

class DesktopApp extends StatelessWidget {
  const DesktopApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // home: TestLoadSingleMusicWidget(),
      // home: TestLoadFullMusicWidget(),
      // home: TestDatabaseWidget(),
      // home: TestAudioMetadata(),
      // home: TestColumnBrowserWidget(),
      home: TestColumnSelectorWidget(),
      debugShowCheckedModeBanner: false,
    );
  }
}
