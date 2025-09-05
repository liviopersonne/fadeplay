import 'package:fadeplay/desktop/data/tracks/playlist.dart';
import 'package:fadeplay/desktop/data/tracks/playlist_folder.dart';
import 'package:fadeplay/desktop/settings/theme.dart';
import 'package:fadeplay/desktop/widgets/general/column_elem.dart';
import 'package:flutter/material.dart';

class PlaylistOrFolder {
  const PlaylistOrFolder.playlist(Playlist this.playlist)
    : isFolder = false,
      folder = null;

  const PlaylistOrFolder.folder(PlaylistFolder this.folder)
    : isFolder = true,
      playlist = null;

  final Playlist? playlist;
  final PlaylistFolder? folder;
  final bool isFolder;
}

class PlaylistSelector extends StatelessWidget {
  const PlaylistSelector({
    super.key,
    required this.playlists,
    required this.folders,
  });

  final List<Playlist> playlists;
  final List<PlaylistFolder> folders;

  @override
  Widget build(BuildContext context) {
    final List<PlaylistOrFolder> allElems = playlists
        .map((p) => PlaylistOrFolder.playlist(p))
        .followedBy(folders.map((f) => PlaylistOrFolder.folder(f)))
        .toList();

    final List<PlaylistOrFolder> rootElems = allElems
        .where(
          (e) => e.isFolder
              ? e.folder!.containingFolder == null
              : e.playlist!.containingFolder == null,
        )
        .toList();

    return ListView.builder(
      itemCount: rootElems.length,
      itemBuilder: (_, i) {
        final elem = rootElems[i];
        return Container();
        // return PlaylistSelectorElem(folder: elem.folder!, remainingFolders: allElems);
      },
    );
  }
}

class PlaylistSelectorElem extends StatefulWidget {
  const PlaylistSelectorElem({
    super.key,
    required this.folder,
    required this.remainingFolders,
  });

  final PlaylistFolder folder;
  final List<PlaylistFolder> remainingFolders;

  @override
  State<PlaylistSelectorElem> createState() => _PlaylistSelectorElemState();
}

class _PlaylistSelectorElemState extends State<PlaylistSelectorElem> {
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
  void didUpdateWidget(covariant PlaylistSelectorElem oldWidget) {
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

    final Widget baseButton = ColumnElem(
      inactiveTextStyle: MyTheme.textStyleNormal,
      inactiveColor: MyTheme.colorBackgroundVeryDark,
      activeColor: MyTheme.colorBackgroundDark,
      hoverable: true,
      hoveringCursor: SystemMouseCursors.click,
      minimumWidth: true,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: MyTheme.paddingSmall),
        child: Text(widget.folder.name),
      ),
    );

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
                child: Center(child: Text(_unfolded ? "⮝" : "⮟")),
              ),
              Expanded(child: VerticalDivider(thickness: 2)),
            ],
          ),
          _unfolded
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    baseButton,
                    for (final child in _myChildren)
                      PlaylistSelectorElem(
                        folder: child,
                        remainingFolders: _remainingChildren,
                      ),
                  ],
                )
              : baseButton,
        ],
      ),
    );
  }
}
