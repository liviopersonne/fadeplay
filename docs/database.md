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
- Album
- Track number
- Year

## Database

### Tracks

- All metadata except artists and albums become IDs
- Id
- Created at
- Modified at
- Mood
- Score
- Instruments
- Source
- Language
- Solos
- Safety
- Image path (try to keep this compatible with musicbee)
- Lyrics path

### Artists / Albums

- Id
- Original name
- Translated name
- Image path (try to keep this compatible with musicbee)

### Playlists

- Id
- Image path
- Id of corresponding tracks

### Enums

- Instruments
- Moods
- Languages
- Safeties

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
