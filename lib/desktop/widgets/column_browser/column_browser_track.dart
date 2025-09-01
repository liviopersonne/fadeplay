import 'package:fadeplay/desktop/objects/column_browser/column_browser_layout.dart';
import 'package:fadeplay/desktop/objects/tracks/track.dart';
import 'package:fadeplay/desktop/settings/theme.dart';
import 'package:fadeplay/desktop/widgets/column_browser/column_browser_hotkeys.dart';
import 'package:fadeplay/desktop/widgets/general/color_size_box.dart';
import 'package:fadeplay/desktop/widgets/general/column_elem.dart';
import 'package:fadeplay/desktop/widgets/general/focus_on_click.dart';
import 'package:fadeplay/desktop/widgets/general/overlayed_list.dart';
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
        child: OverlayedList(
          itemCount: columnLayout.elems.length,
          scrollingEnabled: false,
          direction: Axis.horizontal,
          itemSizes: (i) => columnLayout.elems[i].columnWidth,
          itemBuilder: (_, i) => SizedBox(
            width: columnLayout.elems[i].columnWidth,
            child: Padding(
              padding: EdgeInsets.only(
                left: separatorWidth + MyTheme.paddingTiny,
              ),
              child: Align(
                alignment: AlignmentGeometry.centerLeft,
                child: Text(
                  columnLayout.elems[i].column.getValue(track),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
          separatorBuilder: (_, _) => VerticalDivider(width: 1),
          separatorSizes: (_) => 1.0,
          edgeSeparators: false,
        ),
      ),
    );
  }
}
