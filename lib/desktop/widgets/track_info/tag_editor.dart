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
    this.controller,
  }) : values = null,
       _menuController = null;

  TagEditor.selectFromList({
    super.key,
    this.label,
    this.textFieldWidth = 300,
    this.controller,
    required this.values,
  }) : active = true,
       openDetails = null,
       numbersOnly = false,
       _menuController = MenuController();

  final String? label;
  final bool active;
  final double textFieldWidth;
  final bool numbersOnly;
  final void Function()? openDetails;
  final TextEditingController? controller;
  final List<String>? values;
  final MenuController? _menuController;

  Widget _anchoredMenuWrapper({
    required Widget child,
    required bool isListSelector,
  }) {
    return isListSelector
        ? AnchoredMenu(
            menuItems: {
              "IteItem12Item12m8Item12Item12Item12Item12Item12": () {},
              "Item9": () {},
              "Item11": () {},
              "Item12Item12Item12": () {},
              "ItemItem1213": () {},
              "IteItem12Item12Item12m14": () {},
              "Item15": () {},
              "Item16": () {},
              "IteItem12m17": () {},
              "Item18": () {},
              "Item19": () {},
            },
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
          controller: controller,
          style: MyTheme.textStyleNormal,
          readOnly: !active,
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
