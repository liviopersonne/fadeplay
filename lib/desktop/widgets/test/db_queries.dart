import 'package:drift/drift.dart';
import 'package:fadeplay/desktop/data/tracks/source.dart';
import 'package:fadeplay/desktop/db/queries/source.dart';
import 'package:fadeplay/desktop/db/schemas.dart' as db;
import 'package:fadeplay/desktop/objects/logger.dart';
import 'package:fadeplay/desktop/widgets/general/color_size_box.dart';
import 'package:flutter/material.dart';

final logger = Logging("TestDbQueries");
final database = db.AppDatabase();

class TestDbQueries extends StatelessWidget {
  const TestDbQueries({super.key});

  @override
  Widget build(BuildContext context) {
    final request = testGetSources();
    return Scaffold(
      body: Center(
        child: ColorSizeBox(
          height: 500,
          width: 800,
          color: Colors.grey,
          child: FutureBuilder(
            future: request,
            builder: (context, asyncSnapshot) {
              return Center(
                child: Text(
                  asyncSnapshot.hasData
                      ? "${asyncSnapshot.data}"
                      : "loading...",
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

Future<List<Source>> testGetSources() async {
  final imgUri1 = Uri.file("/home/livio/Bureau/fadeplay_tests/img1.png");
  database.delete(database.sources).go();
  await upsertSource(
    source: Source(title: "source 2", originalTitle: "og 2"),
  );
  await upsertSource(
    source: Source(title: "source 1", imageUri: imgUri1),
  );
  await upsertSource(source: Source(title: "source 3"));
  return await getSources(orderBy: [(u) => OrderingTerm(expression: u.title)]);
}
