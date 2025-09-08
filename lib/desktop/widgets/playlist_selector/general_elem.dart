import 'package:fadeplay/desktop/data/tracks/playlist_folder.dart';
import 'package:fadeplay/desktop/objects/playlist_selector/playlist_or_folder.dart';
import 'package:fadeplay/desktop/settings/theme.dart';
import 'package:fadeplay/desktop/widgets/general/column_elem.dart';
import 'package:fadeplay/desktop/widgets/playlist_selector/playlist_elem.dart';
import 'package:flutter/material.dart';

class PlaylistSelectorElem extends StatefulWidget {
  const PlaylistSelectorElem({
    super.key,
    required this.folder,
    required this.remainingElems,
    required this.width,
  });

  final PlaylistFolder folder;
  final List<PlaylistOrFolder> remainingElems;
  final double width;

  @override
  State<PlaylistSelectorElem> createState() => _PlaylistSelectorElemState();
}

class _PlaylistSelectorElemState extends State<PlaylistSelectorElem> {
  late List<PlaylistOrFolder> _remainingChildren;
  late List<PlaylistOrFolder> _myChildren;
  var _unfolded = true;

  @override
  void initState() {
    super.initState();
    _recomputeChildren();
  }

  @override
  void didUpdateWidget(covariant PlaylistSelectorElem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.remainingElems != widget.remainingElems ||
        oldWidget.folder != widget.folder) {
      _recomputeChildren();
    }
  }

  void _recomputeChildren() {
    _remainingChildren = List<PlaylistOrFolder>.from(widget.remainingElems)
      ..removeWhere((e) => e.folder == widget.folder)
      ..removeWhere((e) => e.getContainingFolder == widget.folder);

    _myChildren = widget.remainingElems
        .where((e) => e.getContainingFolder == widget.folder)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final double arrowWidth = 16;

    final Widget baseTitle = IgnorePointer(
      child: ColumnElem(
        inactiveTextStyle: MyTheme.textStyleNormal,
        minimumWidth: true,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: MyTheme.paddingSmall),
          child: Text(widget.folder.name),
        ),
      ),
    );

    return Stack(
      children: [
        ColumnElem(
          inactiveTextStyle: MyTheme.textStyleNormal,
          minimumWidth: true,
          hoverable: true,
          activeColor: MyTheme.colorBackgroundDark,
          inactiveColor: MyTheme.colorBackgroundVeryDark,
          focusable: true,
          child: SizedBox(width: widget.width),
        ),
        IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ColumnElem(
                    inactiveTextStyle: MyTheme.textStyleNormal,
                    minimumWidth: true,
                    clickable: true,
                    onTap: () => setState(() => _unfolded = !_unfolded),
                    child: Center(
                      child: SizedBox(
                        width: arrowWidth,
                        child: Text(
                          _unfolded ? "⮝" : "⮟",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  Expanded(child: VerticalDivider(thickness: 2)),
                ],
              ),
              _unfolded
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        baseTitle,
                        for (final child in _myChildren)
                          child.isFolder
                              ? PlaylistSelectorElem(
                                  folder: child.folder!,
                                  remainingElems: _remainingChildren,
                                  width: widget.width - arrowWidth,
                                )
                              : PlaylistSelectorPlaylistElem(
                                  playlist: child.playlist!,
                                  width: widget.width - arrowWidth,
                                ),
                      ],
                    )
                  : baseTitle,
            ],
          ),
        ),
      ],
    );
  }
}
