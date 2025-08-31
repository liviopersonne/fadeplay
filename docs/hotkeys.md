Here is all the information I have on hotkeys

There are 3 kinds of ways to listen to hotkeys:

1. `KeyboardListener` -> For unique keystrokes in the scope of a widget

2. `HotKeyRecorder` -> For multiple keystrokes in the scope of a widget

3. `hotKeyManager`.register -> For system-wide keystrokes

`HotKeyRecorder` shows the shortcuts that are being entered in a visual button representation
However, it only works if it is in the widget tree, and even `SizedBox.shrink` can't hide it
I found the solution ! Wrap it with `Offstage`
Aha ! `HardwareKeyboard` is what I'm looking for !
Aha v2 ! Actually it's already built into Flutter with Focus -> Shortcut -> Action

A `HotKey` object has a cool property called `debugName` that shows the text of a hotKey (ex. Shift Left + Key A)

Hotkeys registered with the `hotKeyManager` dont work if their scope is `inapp`, but `system` works
`system` hotkeys will only work if they have a modifier with them
If you don't put a modifier on them, they will actually eat the input if you are in the app or vscode, and not work elsewhere
^ This will also raise an error: don't do it

---

## UPDATED VERSION

Check out [this](https://docs.flutter.dev/ui/interactivity/actions-and-shortcuts) for more info

For system-wide hotkeys, it's still hotKeyManager

I've learned that there is a built-in method of detecting hotkeys inside the application.

```dart
Shortcuts(
    shortcuts: Map<KeyStroke, Intent>
    child: Actions(
        actions: Map<Intent, Action>
        child: Focus()
    )
)
```

If there are multiple Widgets that can perform the same hotkeys but you want to pass personallized data in the action then:

- `Shortcuts` represents the scope where the hotkey exists, it cover all the widgets together
- `Actions` needs to cover each widget separately to pass personallized data
- `Focus` is wrapped around each widget separately

If the widgets are separately focusable but don't pass personallized data to the action, then `Actions` can cover all the widgets together

There are ways to simplify stuff, as described in the article:

- You can avoid separating `Intent` and `Action` by using `CallbackShortcuts` but you can't pass arguments to the action if you do this

- Instead of creating a subclass for `Action`, you can just call `CallbackAction`

You can invoke actions without using the `Shortcuts` widget:

```dart
// Find the actions
Action<SelectAllIntent>? selectAll = Actions.maybeFind<SelectAllIntent>(
  context,
);

// Invoke the action
Object? result;
if (selectAll != null) {
  result = Actions.of(
    context,
  ).invokeAction(selectAll, const SelectAllIntent());
}

// The 2 at the same time
Object? result = Actions.maybeInvoke<SelectAllIntent>(
  context,
  const SelectAllIntent(),
);

// Invoke an Action with a button press
@override
Widget build(BuildContext context) {
  return Actions(
    actions: <Type, Action<Intent>>{SelectAllIntent: SelectAllAction(model)},
    // A builder is used to provide a small context which prevents the handler from searching up the widget tree
    child: Builder(
      builder: (context) => TextButton(
        onPressed: Actions.handler<SelectAllIntent>(
          context,
          SelectAllIntent(controller: controller),
        ),
        child: const Text('SELECT ALL'),
      ),
    ),
  );
}
```
