import 'package:app_nghe_nhac/models/playlist.dart';

class ZingHome {
  final String title;
  List<Playlist> playLists;

  ZingHome.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        playLists = (json['items'] as List)
            .map((playlist) => Playlist.fromJson(playlist))
            .toList();

}