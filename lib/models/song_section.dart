import 'package:app_nghe_nhac/models/song.dart';

class SongSection {
  final String? sectionType;
  final String? title;
  final List<Song>? songs;

  SongSection.fromJson(Map<String, dynamic> json)
      : sectionType = json['sectionType'],
        title = json['title'],
        songs = json['items'] != null ? (json['items'] as List).map((e) => Song.fromJson(e)).toList() : null;
}
