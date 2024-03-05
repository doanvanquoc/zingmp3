import 'package:app_nghe_nhac/models/playlist.dart';

class PlaylistSection {
  final String? title;
  final String? sectionType;
  final List<Playlist>? playlists;

  PlaylistSection.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        sectionType = json['sectionType'],
        playlists = json['items'] != null
            ? (json['items'] as List).map((e) => Playlist.fromJson(e)).toList()
            : null;
}
