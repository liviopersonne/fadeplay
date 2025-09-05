import 'package:fadeplay/desktop/data/tracks/playlist.dart';
import 'package:fadeplay/desktop/data/tracks/playlist_folder.dart';
import 'package:fadeplay/desktop/settings/theme.dart';
import 'package:fadeplay/desktop/widgets/general/button.dart';
import 'package:fadeplay/desktop/widgets/general/column_elem.dart';
import 'package:flutter/material.dart';

class PlaylistSelector extends StatelessWidget {
  const PlaylistSelector({
    super.key,
    required this.playlists,
    required this.folders,
  });

  final List<Playlist> playlists;
  final List<PlaylistFolder> folders;

  Widget _uniquePlaylistItem(Playlist playlist) {
    return ColumnElem(
      inactiveTextStyle: MyTheme.textStyleNormal,
      hoverable: true,
      hoveringCursor: SystemMouseCursors.click,
      child: Text(playlist.name),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class PlaylistFolderSelector extends StatefulWidget {
  const PlaylistFolderSelector({
    super.key,
    required this.folder,
    required this.remainingFolders,
  });

  final PlaylistFolder folder;
  final List<PlaylistFolder> remainingFolders;

  @override
  State<PlaylistFolderSelector> createState() => _PlaylistFolderSelectorState();
}

class _PlaylistFolderSelectorState extends State<PlaylistFolderSelector> {
  late List<PlaylistFolder> _remainingChildren;
  late List<PlaylistFolder> _myChildren;
  bool _unfolded = true;

  @override
  void initState() {
    super.initState();
    logger.log("Init ${widget.folder.name}");
    _recomputeChildren();

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && widget.folder.name == "11") {
        setState(() {
          _myChildren.add(
            PlaylistFolder(name: "99", containingFolder: widget.folder),
          );
          // _myChildren.removeWhere((f) => f.name == "13");
          // _myChildren.removeWhere((f) => f.name == "12");
        });
      }
    });
  }

  @override
  void didUpdateWidget(covariant PlaylistFolderSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.remainingFolders != widget.remainingFolders ||
        oldWidget.folder != widget.folder) {
      _recomputeChildren();
    }
  }

  void _recomputeChildren() {
    logger.log("Recompute ${widget.folder.name}");

    _remainingChildren = List<PlaylistFolder>.from(widget.remainingFolders)
      ..remove(widget.folder)
      ..removeWhere((f) => f.containingFolder == widget.folder);

    _myChildren = widget.remainingFolders
        .where((f) => f.containingFolder == widget.folder)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    logger.log("Build ${widget.folder.name}");

    return IntrinsicHeight(
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
                child: Align(
                  alignment: AlignmentGeometry.center,
                  child: Text(_unfolded ? "⮝" : "⮟"),
                ),
              ),
              Expanded(child: VerticalDivider(thickness: 2)),
            ],
          ),
          _unfolded
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyButton.menuButton(text: widget.folder.name, width: 40),
                    for (final child in _myChildren)
                      PlaylistFolderSelector(
                        folder: child,
                        remainingFolders: _remainingChildren,
                      ),
                  ],
                )
              : MyButton.menuButton(text: widget.folder.name, width: 40),
        ],
      ),
    );
  }
}
