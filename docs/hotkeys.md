Here is all the information I have on hotkeys

There are 3 kinds of ways to listen to hotkeys:

1. `KeyboardListener` -> For unique keystrokes in the scope of a widget

2. `HotKeyRecorder` -> For multiple keystrokes in the scope of a widget

3. `hotKeyManager`.register -> For system-wide keystrokes

`HotKeyRecorder` shows the shortcuts that are being entered in a visual button representation
However, it only works if it is in the widget tree, and even `SizedBox.shrink` can't hide it
I found the solution ! Wrap it with `Offstage`
Aha ! `HardwareKeyboard` is what I'm looking for !

A `HotKey` object has a cool property called `debugName` that shows the text of a hotKey (ex. Shift Left + Key A)

Hotkeys registered with the `hotKeyManager` dont work if their scope is `inapp`, but `system` works
`system` hotkeys will only work if they have a modifier with them
If you don't put a modifier on them, they will actually eat the input if you are in the app or vscode, and not work elsewhere
^ This will also raise an error: don't do it
