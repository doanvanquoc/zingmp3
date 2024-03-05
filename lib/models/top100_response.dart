import 'package:app_nghe_nhac/models/playlist.dart';

class Top100Reponse {
  final String title;
  final List<Playlist> playlists;

  Top100Reponse.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        playlists = (json['items'] as List)
            .map((playlist) => Playlist.fromJson(playlist))
            .toList();
}
