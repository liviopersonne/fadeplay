## Assets

- [ ] Asset is never loading on the first try

## FullMusicPlayer

- [x] Single player reaching the end of the song manually
- [x] Manual next
- [x] Auto next
- [x] Playlist initial index
- [x] Manual prev
- [x] Deal with next at the end of the playlist
- [x] Deal with prev at the start of the playist
- [x] Deal with loading a playlist at it's last index
- [x] Deal with reaching the last index of a playlist
- [x] Deal with crossFadeNext at the end of the playlist
- [x] Pausing during a transition (directly set volume at end value ?)
- [x] Pausing and playing during a transition
- [x] Update player status on active player switch
- [x] Check if exactly one player has a null index
- [x] Add `inTransition` in the player state
- [x] Make t value (transition percent) a public value
- [x] Fadeout ending after the end of a song
- [x] Two fadeouts overlapping because transitions are too close
- [ ] Fadein starting before the end of song because of clipping
- [ ] Remove the precise position subscription and replace it by a future delay to trigger the transition,
      and update the delay on a discontinuity or on status change or on active player switch
      Actually this seems complicated because what if the delay doesn't actually wait the right period ?

## AudioSource

- [ ] Une the `clip` function when loading a song

## ColumnBrowser

- [x] Colors in a layout
- [x] Highlight drag targets when hovering
- [x] Make drag targets invisible overwise
- [x] Actually insert the columns
- [x] Make draggable only horizontally
- [x] Add indicator if some columns have been cut
- [ ] Clip the dragging in the row

## ColumnSelector

- [ ] Deactivate hovering on present columns when dragging
- [ ] Remove the space between the present columns
