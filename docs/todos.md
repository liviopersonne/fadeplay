## Assets

- [ ] Asset is never loading on the first try

## FullMusicPlayer

FIXME:

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
- [ ] Make t value (transition percent) a public value
- [ ] Remove the precise position subscription and replace it by a future delay to trigger the transition,
      and update the delay on a discontinuity (if that stream exists) or on status change or on active player switch
- [ ] Check if I can use the just_audio `clip` function to help with stuff
- [ ] Fadeout ending after the end of a song, or starting before the end of song because of clipping
- [ ] Two fadeouts overlapping because transitions are too close
