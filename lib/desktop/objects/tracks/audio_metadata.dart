import 'dart:io';

import 'package:audio_metadata_reader/audio_metadata_reader.dart';
import 'package:fadeplay/desktop/objects/logger.dart';

final logger = Logging("AudioMetadata");

// NOTE: The functions here work only with the modifications I personnaly made to the audio_metadata_reader library
// To see these changes check:
//  - https://github.com/ClementBeal/audio_metadata_reader/pull/90 (fix genre duplication)
//  - https://github.com/ClementBeal/audio_metadata_reader/pull/91 (fix setArtist)

class TrackMetadata {
  final String? title;
  final String? artist;
  final String? album;
  final int? trackNumber;
  final int? trackTotal;
  final int? cdNumber;
  final int? cdTotal;
  final int? year;

  TrackMetadata({
    this.title,
    this.artist,
    this.album,
    this.trackNumber,
    this.trackTotal,
    this.cdNumber,
    this.cdTotal,
    this.year,
  });

  @override
  String toString() {
    return "TrackMetadata<${title ?? "No Title"} - ${artist ?? "No Artist"} - ${album ?? "No Album"}>";
  }

  String fullString() {
    return """TrackMetadata{
      Title: $title
      Artist: $artist
      Album: $album
      Year: $year
      Track: $trackNumber/$trackTotal
      Disk: $cdNumber/$cdTotal
}""";
  }
}

class MetadataReader {
  MetadataReader._();

  static bool _checkExtension(File audioFile) {
    if (audioFile.path.endsWith('.mp3')) {
      return true;
    } else if (audioFile.path.endsWith(".mp4") ||
        audioFile.path.endsWith(".m4a") ||
        audioFile.path.endsWith(".flac") ||
        audioFile.path.endsWith(".wav")) {
      logger.warn("Unrecommended extension for file '${audioFile.path}");
      return true;
    } else {
      logger.error("Unsupported extension for file '${audioFile.path}");
      return false;
    }
  }

  static TrackMetadata? readFileMetadata(File audioFile) {
    if (_checkExtension(audioFile)) {
      final audioMetadata = readMetadata(audioFile, getImage: false);
      return TrackMetadata(
        title: audioMetadata.title,
        artist: audioMetadata.artist,
        album: audioMetadata.album,
        trackNumber: audioMetadata.trackNumber,
        trackTotal: audioMetadata.trackTotal,
        cdNumber: audioMetadata.discNumber,
        cdTotal: audioMetadata.totalDisc,
        year: audioMetadata.year?.year,
      );
    }
    return null;
  }

  static void writeFileMetadata(TrackMetadata metadata, File audioFile) {
    if (_checkExtension(audioFile)) {
      updateMetadata(audioFile, (meta) {
        meta.setTitle(metadata.title);
        meta.setArtist(metadata.artist);
        meta.setAlbum(metadata.album);
        meta.setTrackNumber(metadata.trackNumber);
        meta.setTrackTotal(metadata.trackTotal);
        meta.setCD(metadata.cdNumber, metadata.cdTotal);
        meta.setYear(metadata.year == null ? null : DateTime(metadata.year!));
      });
    }
  }

  static Duration? readFileLength(File audioFile) {
    if (_checkExtension(audioFile)) {
      final audioMetadata = readMetadata(audioFile, getImage: false);
      return audioMetadata.duration;
    }
    return null;
  }
}
