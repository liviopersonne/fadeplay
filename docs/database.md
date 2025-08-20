Track information will be split into 3 locations: metadata, filepath & sql database

- Metadata is more adapted for intrinsic and static info on a track
- Database is more adapted for dynamic and user info on a track
- Filepath will be used for covers

However, if we want to make queries on the data, we need it to be in the database (otherwise we need to check all tracks). But we also want to keep metadata for portability. So we'll just duplicate all metadata into the database and then periodically check that they correspond.

We won't store cover images or lyrics in metadata because it will take a lot of storage space.

But sometimes the data we want to show (metadata) isn't exactly the same as the data we want to query (database), so there will be adaptations. An example of this is the artist: `metadata = A & B feat. C` / `database = [A, B, C]`

## Metadata

- Title
- Artist
- ? Album
- ? Track number
- ? Disk number
- ? Year

## Database

### Tracks

- All metadata except
  - ? added original title (for translations)
  - ? salbum becomes an id
  - artist becomes
    - artistString (for representation)
    - the many to many link between track and artist is stored in a separate table TrackArtists
- Id
- File path
- Created at
- Duration (in ms) > 0
- ? Start time (> 0 < duration) (in ms) (in case I trim the file)
- ? End time (> 0 < duration) (in ms)
- ? Rating
- ? Mood (many to many)
- ? Instruments (many to many)
- ? SourceId (many to one)
- ? Languages (many to many)
- ? Solos (many to many)
- ? Safety (many to many)
- ? Image path (try to keep this compatible with musicbee)
- ? Lyrics path

### Artists / Albums

- Id
- Name / Title
- ? Original name / title (in original language)
- ? Image path (try to keep this compatible with musicbee)

### Sources

- Id
- Title
- ? Original title
- ? Image path

### TrackArtists

- Track id
- Artist id
- ArtistType

### Playlists

- Id
- Name
- ? Image path
- ? containingFolderId (id of the folder in which this playlist is contained)
- Id of corresponding tracks (many to many)

### PlaylistFolder

- Id
- Name
- ? Image path
- ? containingFolderId

### Transitions

- Id
- Created at
- Track 1 id
- Track 2 id
- Fadeout end (in ms)
- Fadeout duration (in ms)
- Fadein start
- Fadein duration
- (= 0) Delay (delay between the 2 tracks)
- ? Comment
- Type (enuma that tells if the transition was created manually or for a mix)

### Mixes

<!-- TODO: Add mixes to database -->

### Real enums

- TransitionType
  - manual automatic mix
- ArtistType
  - artist featured composer remixer cover
- Safety
  - safe lyrics language weirdVoice screaming ost other

### Enums defined during seeding (can add values)

- Mood
  - banger battle bop chill epic exploration melancholy
- Instrument
  - amenDrums bass choir cuivres flute guitare guitareElectrique harpe piano saxophone traditionalJapanese violon voix
- Language
  - franch english japanese chaosLanguage latin

## Filepath (try to keep this compatible with musicbee)

### Files will be organized like this:

|           | Album               | No album    |
| --------- | ------------------- | ----------- |
| Source    | `<source>/<album>/` | `<source>/` |
| No source | `<artist>/album`    | `<artist>/` |

### Images will be organized like this:

| Album                | No album       |
| -------------------- | -------------- |
| `/<album>/Cover.jpg` | `/<track>.jpg` |

## Other data

Lyrics: Will be stored somewhere in the filepath

<!-- TODO: Correctly delete files associated with objects when they are deleted (mainly images) -->

<!-- TODO: Fix Musicbee bug that happens when you set album covers before putting the tracks in their respective folders, and every track gets the same cover -->
