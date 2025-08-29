import 'package:fadeplay/desktop/objects/logger.dart';
import 'package:fadeplay/desktop/settings/theme.dart';
import 'package:fadeplay/desktop/widgets/general/row_elem.dart';
import 'package:flutter/material.dart';

final logger = Logging("TestRowElem");

class TestRowElem extends StatelessWidget {
  const TestRowElem({super.key});

  @override
  Widget build(BuildContext context) {
    final itemCount = 10;
    final dragging = ValueNotifier<bool>(false);
    return Scaffold(
      body: Center(
        child: Container(
          height: 500,
          width: 500,
          color: Colors.grey,
          child: Column(
            children: List.generate(
              itemCount,
              (index) => RowElem(
                inactiveTextStyle: MyTheme.textStyleInactive,
                inactiveColor: Colors.orange,
                activeTextStyle: MyTheme.textStyleNormal,
                activeColor: Colors.pink,
                clickable: true,
                onTap: () => logger.log("Clicked $index !!"),
                hoverable: true,
                hoveringCursor: SystemMouseCursors.click,
                draggable: true,
                dragNotifier: dragging,
                draggableData: 1,
                draggableText: "Elem $index",
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [Text("Elem $index"), Text("Hello !!")],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
