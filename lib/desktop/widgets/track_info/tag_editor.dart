import 'package:fadeplay/desktop/settings/theme.dart';
import 'package:fadeplay/desktop/widgets/general/column_elem.dart';
import 'package:fadeplay/desktop/widgets/menus/anchored_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// TODO: Add autocomplete
class TagEditor extends StatelessWidget {
  const TagEditor({
    super.key,
    this.label,
    this.active = true,
    this.textFieldWidth = 400,
    this.numbersOnly = false,
    this.openDetails,
    this.textController,
  }) : values = null,
       _menuController = null,
       multiselect = false,
       _readOnly = !active;

  TagEditor.selectFromList({
    super.key,
    this.label,
    this.textFieldWidth = 300,
    required TextEditingController this.textController,
    required this.values,
    this.multiselect = false,
  }) : active = true,
       openDetails = null,
       numbersOnly = false,
       _readOnly = true,
       _menuController = MenuController();

  final String? label;
  final bool active;
  final bool _readOnly;
  final double textFieldWidth;
  final bool numbersOnly;
  final void Function()? openDetails;
  final TextEditingController? textController;
  final List<String>? values;
  final bool multiselect;
  final MenuController? _menuController;

  Widget _anchoredMenuWrapper({
    required Widget child,
    required bool isListSelector,
  }) {
    return isListSelector
        ? AnchoredMenu(
            menuItems: Map.fromIterable(
              values!,
              value: (value) => () {
                if (multiselect) {
                  throw UnimplementedError(); // TODO: This is gonna be hard
                } else {
                  textController?.text = value;
                  _menuController?.close();
                }
              },
            ),
            menuController: _menuController!,
            width: textFieldWidth,
            child: child,
          )
        : child;
  }

  void _dropdownSuffixOnTap() {
    if (_menuController!.isOpen) {
      _menuController.close();
    } else {
      _menuController.open();
    }
  }

  Widget _textBox() {
    final bool isListSelector = values != null;
    return _anchoredMenuWrapper(
      isListSelector: isListSelector,
      child: ConstrainedBox(
        constraints: BoxConstraints.loose(Size.fromWidth(textFieldWidth)),
        child: TextField(
          inputFormatters: numbersOnly
              ? [FilteringTextInputFormatter.digitsOnly]
              : null,
          autocorrect: true,
          controller: textController,
          style: MyTheme.textStyleNormal,
          readOnly: _readOnly,
          showCursor: !isListSelector,
          cursorColor: MyTheme.textStyleNormal.color,
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide(color: MyTheme.colorAccentHigh),
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.zero),
            filled: true,
            fillColor: active
                ? MyTheme.colorBackgroundLight
                : MyTheme.colorBackgroundDark,
            isDense: true,
            suffixIconConstraints: BoxConstraints.tight(Size(30, 25)),
            suffixIcon: (active && openDetails != null) || isListSelector
                ? Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: ColumnElem(
                      inactiveTextStyle: MyTheme.textStyleNormal,
                      activeColor: MyTheme.colorBackgroundDark,
                      minimumWidth: true,
                      hoverable: true,
                      hoveringCursor: SystemMouseCursors.click,
                      clickable: true,
                      onTap: isListSelector
                          ? _dropdownSuffixOnTap
                          : openDetails,
                      child: Center(child: Text(isListSelector ? "⮟" : "...")),
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return label != null
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: MyTheme.paddingSmall,
            children: [
              Text(label!, style: MyTheme.textStyleNormal),
              _textBox(),
            ],
          )
        : _textBox();
  }
}
