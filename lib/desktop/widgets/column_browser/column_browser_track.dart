import 'package:fadeplay/desktop/objects/column_browser/column_browser_layout.dart';
import 'package:fadeplay/desktop/objects/tracks/track.dart';
import 'package:fadeplay/desktop/settings/theme.dart';
import 'package:fadeplay/desktop/widgets/column_browser/column_browser_hotkeys.dart';
import 'package:fadeplay/desktop/widgets/general/color_size_box.dart';
import 'package:fadeplay/desktop/widgets/general/column_elem.dart';
import 'package:fadeplay/desktop/widgets/general/focus_on_click.dart';
import 'package:flutter/material.dart';

class BrowserTrack extends StatelessWidget {
  const BrowserTrack({
    super.key,
    required this.track,
    required this.columnLayout,
    required this.separatorWidth,
  });

  final ColumnBrowserLayout columnLayout;
  final Track track;
  final double separatorWidth;

  @override
  Widget build(BuildContext context) {
    return Actions(
      actions: {OpenTrackDetailsIntent: OpenTrackDetailsAction(track: track)},
      child: ColumnElem(
        inactiveTextStyle: MyTheme.textStyleNormal,
        inactiveColor: MyTheme.colorAccentLow,
        activeColor: MyTheme.colorAccentHigh,
        focusable: true,
        child: Row(
          children: [
            for (int i = 0; i < columnLayout.elems.length; i++) ...[
              SizedBox(
                width: columnLayout.elems[i].columnWidth,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: separatorWidth + MyTheme.paddingTiny,
                  ),
                  child: Text(
                    columnLayout.elems[i].column.getValue(track),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
