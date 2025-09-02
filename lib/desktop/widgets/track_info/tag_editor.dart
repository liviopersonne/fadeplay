import 'package:fadeplay/desktop/settings/theme.dart';
import 'package:fadeplay/desktop/widgets/general/column_elem.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// TODO: Add autocomplete
class TagEditor extends StatelessWidget {
  const TagEditor({
    super.key,
    required this.label,
    this.active = true,
    this.textFieldWidth = 400,
    this.numbersOnly = false,
    this.openDetails,
    this.controller,
  }) : values = null;

  const TagEditor.selectFromList({
    super.key,
    required this.label,
    this.textFieldWidth = 300,
    this.controller,
    required this.values,
  }) : active = true,
       openDetails = null,
       numbersOnly = false;

  final String label;
  final bool active;
  final double textFieldWidth;
  final bool numbersOnly;
  final void Function()? openDetails;
  final TextEditingController? controller;
  final List<String>? values;

  @override
  Widget build(BuildContext context) {
    final bool isListSelector = values != null;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      spacing: MyTheme.paddingSmall,
      children: [
        Text(label, style: MyTheme.textStyleNormal),
        ConstrainedBox(
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
              border: OutlineInputBorder(borderRadius: BorderRadius.zero),
              filled: true,
              fillColor: active
                  ? MyTheme.colorBackgroundLight
                  : MyTheme.colorBackgroundDark,
              isDense: true,
              suffixIconConstraints: BoxConstraints.tight(Size(30, 25)),
              suffixIcon: active && openDetails != null
                  ? Padding(
                      padding: const EdgeInsets.only(right: 5.0),
                      child: ColumnElem(
                        inactiveTextStyle: MyTheme.textStyleNormal,
                        activeColor: MyTheme.colorBackgroundDark,
                        minimumWidth: true,
                        hoverable: true,
                        hoveringCursor: SystemMouseCursors.click,
                        clickable: true,
                        onTap: openDetails,
                        child: Center(child: Text("...")),
                      ),
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}
