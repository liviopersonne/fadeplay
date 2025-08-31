import 'package:fadeplay/desktop/objects/logger.dart';
import 'package:fadeplay/desktop/widgets/general/button.dart';
import 'package:fadeplay/desktop/widgets/general/color_size_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hotkey_manager/hotkey_manager.dart';

final logger = Logging("TestKeyboardListener");

class TestKeyboardListener extends StatefulWidget {
  const TestKeyboardListener({super.key});

  @override
  State<TestKeyboardListener> createState() => _TestKeyboardListenerState();
}

class _TestKeyboardListenerState extends State<TestKeyboardListener> {
  String content = "Hello";
  final _focusNodes = List.generate(2, (_) => FocusNode());
  HotKey? listenedHotkey;

  @override
  void dispose() {
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    registerHotkey().then((_) => logger.log("Assigned hotkey"));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                2,
                (i) => KeyboardListener(
                  focusNode: _focusNodes[i],
                  // autofocus: true,
                  autofocus: false,
                  onKeyEvent: (value) {
                    logger.log("Heard key on $i");
                    setState(() => content = value.toString());
                  },
                  child: GestureDetector(
                    onTap: () => setState(() {
                      // _focusNode.requestFocus();
                      FocusScope.of(context).requestFocus(_focusNodes[i]);
                    }),
                    child: ColorSizeBox(
                      height: 300,
                      width: 300,
                      color: _focusNodes[i].hasFocus
                          ? Colors.teal
                          : Colors.grey,
                      child: Center(
                        child: Text(
                          _focusNodes[i].hasFocus ? content : "Unfocused",
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Text("Pressed ${listenedHotkey?.debugName}"),
            Offstage(
              child: HotKeyRecorder(
                onHotKeyRecorded: (hotKey) => setState(() {
                  listenedHotkey = hotKey;
                }),
              ),
            ),
            Text(hotKeyManager.registeredHotKeyList.toString()),
            MyButton(
              text: "Unfocus",
              width: 200,
              onTap: () => setState(() {
                // _focusNode.unfocus();
                FocusScope.of(context).unfocus();
              }),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> registerHotkey() async {
  final HotKey hotkey = HotKey(
    key: PhysicalKeyboardKey.end,
    modifiers: [HotKeyModifier.shift],
    scope: HotKeyScope.system,
  );

  await hotKeyManager.register(
    hotkey,
    keyDownHandler: (hotKey) {
      logger.log("Pressed hotkey: $hotKey");
    },
  );
  logger.log("1");
}
