import 'package:fadeplay/desktop/data/tracks/playlist.dart';
import 'package:fadeplay/desktop/settings/theme.dart';
import 'package:fadeplay/desktop/widgets/general/column_elem.dart';
import 'package:flutter/material.dart';

class PlaylistSelectorPlaylistElem extends StatelessWidget {
  const PlaylistSelectorPlaylistElem({
    super.key,
    required this.playlist,
    required this.width,
  });

  final Playlist playlist;
  final double width;

  @override
  Widget build(BuildContext context) {
    return ColumnElem(
      inactiveTextStyle: MyTheme.textStyleNormal,
      minimumWidth: true,
      hoverable: true,
      activeColor: MyTheme.colorBackgroundDark,
      inactiveColor: MyTheme.colorBackgroundVeryDark,
      focusable: true,
      child: SizedBox(
        width: width,
        child: Padding(
          padding: EdgeInsets.only(left: MyTheme.paddingSmall),
          child: Text(playlist.name, overflow: TextOverflow.ellipsis),
        ),
      ),
    );
  }
}
