import 'package:fadeplay/desktop/objects/logger.dart';
import 'package:fadeplay/desktop/settings/theme.dart';
import 'package:fadeplay/desktop/widgets/general/column_elem.dart';
import 'package:fadeplay/desktop/widgets/general/color_size_box.dart';
import 'package:flutter/material.dart';

final logger = Logging("TestColumnElem");

class TestColumnElem extends StatelessWidget {
  const TestColumnElem({super.key});

  @override
  Widget build(BuildContext context) {
    final itemCount = 10;
    final dragging = ValueNotifier<bool>(false);
    return Scaffold(
      body: Center(
        child: ColorSizeBox(
          height: 500,
          width: 500,
          color: Colors.grey,
          child: Column(
            children: List.generate(
              itemCount,
              (index) => ColumnElem(
                inactiveTextStyle: MyTheme.textStyleInactive,
                inactiveColor: Colors.orange,
                activeTextStyle: MyTheme.textStyleNormal,
                activeColor: Colors.pink,
                clickable: true,
                onTap: () => logger.log("onTap $index !!"),
                onTapDown: (_) => logger.log("onTapDown $index !!"),
                onSecondaryTap: () => logger.log("onSecondaryTap $index !!"),
                onSecondaryTapDown: (_) =>
                    logger.log("onSecondaryTapDown $index !!"),
                onDoubleTap: () => logger.log("onDoubleTap $index !!"),
                hoverable: true,
                hoveringCursor: SystemMouseCursors.click,
                draggable: true,
                dragNotifier: dragging,
                draggableData: 1,
                draggableText: "Elem $index",
                focusable: true,
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
