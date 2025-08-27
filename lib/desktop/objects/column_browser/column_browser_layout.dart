import 'package:fadeplay/desktop/objects/logger.dart';

final logger = Logging("ColumnBrowserLayout");

class ColumnBrowserLayout {
  List<String> columnIds = [];
  List<int> flexes = [];

  ColumnBrowserLayout({required this.columnIds, required this.flexes}) {
    final idsLen = columnIds.length;
    final flexLen = flexes.length;

    if (idsLen != flexLen) {
      logger.error(
        "Different number of column ids ($idsLen) than flexes ($flexLen)",
      );
      if (idsLen > flexLen) {
        columnIds = columnIds.sublist(0, flexLen);
      } else {
        flexes = flexes.sublist(0, idsLen);
      }
    }
  }
}
