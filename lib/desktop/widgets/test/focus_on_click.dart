import 'package:fadeplay/desktop/widgets/general/button.dart';
import 'package:fadeplay/desktop/widgets/general/color_size_box.dart';
import 'package:fadeplay/desktop/widgets/general/focus_on_click.dart';
import 'package:flutter/material.dart';

class TestFocusOnClick extends StatelessWidget {
  const TestFocusOnClick({super.key});

  @override
  Widget build(BuildContext context) {
    final focusNode = FocusNode();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ColorSizeBox(
              height: 200,
              width: 200,
              color: Colors.grey,
              child: FocusOnClick(
                unfocusedWidget: Text("Unfocused"),
                focusedWidget: Text("Focused"),
                focusNode: focusNode,
                // focusNode: null,
              ),
            ),
            MyButton(text: "Focus", onTap: () => focusNode.requestFocus()),
          ],
        ),
      ),
    );
  }
}
