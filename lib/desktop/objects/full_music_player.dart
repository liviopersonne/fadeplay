import 'dart:async';

import 'package:fadeplay/desktop/objects/logger.dart';
import 'package:fadeplay/desktop/objects/single_music_player.dart';
import 'package:fadeplay/desktop/settings/settings.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

/* FIXME:
  - [x] Single player reaching the end of the song manually
  - [x] Manual next
  - [x] Auto next
  - [x] Playlist initial index
  - [x] Manual prev
  - [x] Deal with next at the end of the playlist
  - [ ] Deal with prev at the start of the playist
  - [x] Deal with loading a playlist at it's last index
  - [x] Deal with reaching the last index of a playlist
  - [ ] Deal with crossFadeNext at the end of the playlist
  - [ ] Check if exactly one player has a null index
  - [ ] Fadeout ending after the end of a song, or starting before the end of song because of clipping
  - [ ] Two fadeouts overlapping because transitions are too close
  - [ ] Changing active player at start of transition (in case of pause)
  - [ ] Pausing during a transition (directly set volume at end value ?)
  - [ ] Add values in player status: InTransition
  - [ ] Make t value (transition percent) a public value
  - [ ] Update player status on active player switch
  - [ ] Remove the precise position subscription and replace it by a future delay to trigger the transition,
        and update the delay on a discontinuity (if that stream exists) or on status change or on active player switch
  - [ ] Check if I can use the just_audio `clip` function to help with stuff
*/

final logger = Logging("FullMusicPlayer");

/// A music player with 2 AudioPlayers than can crossfade between tracks
class FullMusicPlayer {
  final _player0 = SingleMusicPlayer();
  final _player1 = SingleMusicPlayer();
  StreamSubscription? _playerStatesSubscription;
  StreamSubscription? _precisePositionSubscription;
  StreamSubscription? _playerIndicesSubscription;
  int _activePlayerIndex = 0;
  int? _currentPlaylistLength;

  /// Whether the player is playing
  var playing = false;

  /// The player's current state
  var state = ProcessingState.idle;

  /// The player's current index
  int? index;

  FullMusicPlayer() {
    logger.debug("Insianciating a new FullMusicPlayer");

    // Setup listening streams
    final playerStatesStream = Rx.combineLatest2(
      _player0.player.playerStateStream,
      _player1.player.playerStateStream,
      (s0, s1) => (s0, s1),
    );

    _playerStatesSubscription = playerStatesStream.listen((states) {
      final (s0, s1) = states;
      _onNewPlayerStates(s0, s1);
    });

    final newCurrentIndexStream = Rx.combineLatest2(
      _player0.newCurrentIndexStream,
      _player1.newCurrentIndexStream,
      (i0, i1) => (i0, i1),
    );

    _playerIndicesSubscription = newCurrentIndexStream.listen((
      newIndices,
    ) async {
      final (i0, i1) = newIndices;
      await _onNewIndex(i0, i1);
    });
  }

  /// Dispose the player when you're done using it
  Future<void> dispose() async {
    _playerStatesSubscription?.cancel();
    _playerStatesSubscription = null;
    _precisePositionSubscription?.cancel();
    _precisePositionSubscription = null;
    _playerIndicesSubscription?.cancel();
    _playerIndicesSubscription = null;
    _player0.dispose();
    _player1.dispose();
    logger.debug("Disposed a FullMusicPlayer");
  }

  /// Gets the SingleMusicPlayer that is currently playing
  SingleMusicPlayer _getActivePlayer() =>
      _activePlayerIndex == 0 ? _player0 : _player1;

  /// Gets the SingleMusicPlayer that isn't currently playing
  SingleMusicPlayer _getInactivePlayer() =>
      _activePlayerIndex == 0 ? _player1 : _player0;

  /// Switches between the two SingleMusicPlayers
  void _switchActivePlayer() {
    final oldIndex = _activePlayerIndex;
    final newIndex = 1 - _activePlayerIndex;
    logger.debug("Switching active player from $oldIndex to $newIndex");
    _activePlayerIndex = newIndex;
  }

  /// Actions to do when one of the player states changes
  void _onNewPlayerStates(PlayerState s0, PlayerState s1) {
    playing = s0.playing | s1.playing;
    state = _activePlayerIndex == 0 ? s0.processingState : s1.processingState;
  }

  /// Actions to do when the player's index changes.
  /// This includes:
  /// - updating the full player's index
  /// - switching the active player if a new track was loaded and another one was already loaded
  /// - resuming the player if it was already playing
  Future<void> _onNewIndex(int? i0, int? i1) async {
    final wasPlaying = playing;
    final oldIndex = index;

    // Update the full player's index
    index = switch ((i0, i1)) {
      (null, null) => null,
      (null, _) || (_, null) => throw StateError(
        "Exactly one of the players has a null index",
      ),
      _ => i0! + i1!,
    };
    logger.debug("New player index $index (playing=$wasPlaying)");

    // Switch the active player if needed
    if (index != null && oldIndex != null) {
      if (index == _currentPlaylistLength) {
        // Reached the end of the playlist
        logger.log("Reached the end of the playlist, stopping players");
        await _player0.player.stop();
        await _player1.player.stop();
      }
      if (index == oldIndex - 1) {
        // Previous track loading, restart current track
        await _getActivePlayer().pause();
        await _getActivePlayer().seek(Duration.zero);
      }
      _switchActivePlayer();
    }

    // Resume the player if it was already playing
    if (wasPlaying) {
      await _getActivePlayer().play();
    }
  }

  /// Activates the more precise but ressource intensive stream
  /// that tracks the current position in the song
  /// - The `callback` function decides what to do when a new position is recieved
  void _activatePrecisePositionSubscription(void Function(Duration)? callback) {
    if (_precisePositionSubscription != null) {
      logger.error(
        "Tried to activate precise position subscription when it already existed",
      );
      _deactivatePrecisePositionSubscription();
    }
    _precisePositionSubscription = _getActivePlayer().precisePositionStream
        .listen(callback);
  }

  /// Deactivates the precise position stream to free ressources.
  /// This should always be called after a transition is completed
  void _deactivatePrecisePositionSubscription() {
    if (_precisePositionSubscription == null) {
      logger.error(
        "Tried to deactivate precise position subscription when it didn't exist",
      );
    }
    _precisePositionSubscription?.cancel();
    _precisePositionSubscription = null;
  }

  /// Plays the loaded music
  Future<void> play() async {
    logger.debug("Playing with activePlayer $_activePlayerIndex");
    if (playing) logger.warn("Called 'play' while already playing");
    await _getActivePlayer().play();
  }

  /// Pauses the player
  Future<void> pause() async {
    logger.debug("Paused player");
    if (!playing) logger.warn("Called 'pause' while already paused");
    await Future.wait([
      _getActivePlayer().pause(),
      _getInactivePlayer().pause(),
    ]);
  }

  /// Goes to next music without any transition
  /// This command automatically switches the active and inactive players with the `_onNewIndex` function
  Future<void> next() async {
    await _getActivePlayer().next();
  }

  /// Seeks a specific point in the current player
  Future<void> seek(Duration duration) async {
    await _getActivePlayer().seek(duration);
  }

  /// Goes to the previous music without any transition
  Future<void> prev() async {
    await _getInactivePlayer().prev();
  }

  Future<void> crossfadeNext({Duration? crossfadeDuration}) async {
    final duration = crossfadeDuration ?? Settings.crossfadeDuration;

    if (!_getActivePlayer().playing) {
      logger.warn("Tried to crossfade while paused");
      return await next();
    }

    await Future.wait([
      _getActivePlayer().fadeout(duration: duration),
      _getInactivePlayer().fadein(duration: duration),
    ]);

    await _getActivePlayer().next();
    _switchActivePlayer();
  }

  /// Loads a list of music in order
  Future<bool> loadPlaylist({
    required List<AudioSource> audioSources,
    bool preload = true,
    int? initialIndex,
    Duration? initialPosition,
  }) async {
    logger.debug("Loading playlist of ${audioSources.length} song(s)");
    _currentPlaylistLength = audioSources.length;

    List<AudioSource> audioSources1 = [];
    List<AudioSource> audioSources2 = [];
    for (var i = 0; i < audioSources.length; i++) {
      if (i % 2 == 0) {
        audioSources1.add(audioSources[i]);
      } else {
        audioSources2.add(audioSources[i]);
      }
    }

    // Set initial values
    final (initialIndex1, initialIndex2) = initialIndex == null
        ? (null, null)
        : ((initialIndex + 1) ~/ 2, initialIndex ~/ 2);

    final (
      initialPosition1,
      initialPosition2,
    ) = (initialPosition == null || initialIndex == null)
        ? (null, null)
        : (initialIndex % 2 == 0)
        ? (initialPosition, null)
        : (null, initialPosition);

    final success1 = await _player0.loadPlaylist(
      audioSources: audioSources1,
      preload: preload,
      initialIndex: initialIndex1,
      initialPosition: initialPosition1,
    );
    final success2 = await _player1.loadPlaylist(
      audioSources: audioSources2,
      preload: preload,
      initialIndex: initialIndex2,
      initialPosition: initialPosition2,
    );

    index = initialIndex ?? 0;
    // set active player to _player0 if the initial index is pair, and vice versa
    _activePlayerIndex = index! % 2;

    return success1 && success2;
  }
}
