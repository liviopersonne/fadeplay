import 'package:fadeplay/desktop/objects/logger.dart';
import 'package:fadeplay/desktop/settings/theme.dart';
import 'package:fadeplay/desktop/widgets/general/text_column_elem.dart';
import 'package:flutter/material.dart';

final logger = Logging("TestTextColumnElem");

class TestTextColumnElem extends StatelessWidget {
  const TestTextColumnElem({super.key});

  @override
  Widget build(BuildContext context) {
    final itemCount = 10;
    return Scaffold(
      body: Center(
        child: Container(
          height: 500,
          width: 500,
          color: Colors.grey,
          child: Column(
            children: List.generate(
              itemCount,
              (index) => TextColumnElem(
                text: "Elem $index",
                inactiveTextStyle: MyTheme.textStyleInactive,
                inactiveColor: Colors.orange,
                activeTextStyle: MyTheme.textStyleNormal,
                activeColor: Colors.pink,
                clickable: true,
                onTap: () => logger.log("Clicked !!"),
                hoverable: true,
                hoveringCursor: SystemMouseCursors.click,
                draggable: true,
                draggableData: 1,
                draggableText: "Burger !!",
              ),
            ),
          ),
        ),
      ),
    );
  }
}
