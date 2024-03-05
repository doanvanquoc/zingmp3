import 'package:app_nghe_nhac/models/artist.dart';

class Song {
  final String? encodeId;
  final String? title;
  final String? thumbnail;
  final List<Artist> artists;
  final DateTime releaseDate;
  final bool isWorldWide;

  Song.fromJson(Map<String, dynamic> json)
      : encodeId = json['encodeId'],
        title = json['title'],
        thumbnail = json['thumbnail'],
        isWorldWide = json['isWorldWide'],
        releaseDate =
            DateTime.fromMillisecondsSinceEpoch(json['releaseDate'] * 1000),
        artists = json['artists'] != null
            ? (json['artists'] as List).map((e) => Artist.fromJson(e)).toList()
            : [];

  @override
  String toString() {
    return 'Song{encodeId: $encodeId, title: $title, artists: $artists}';
  }

  Song.empty()
      : encodeId = '',
        title = '',
        thumbnail = '',
        isWorldWide = false,
        releaseDate = DateTime.now(),
        artists = [];
}
