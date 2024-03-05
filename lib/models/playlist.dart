import 'package:app_nghe_nhac/models/artist.dart';
import 'package:app_nghe_nhac/models/song.dart';

class Playlist {
  final String? encodeId;
  final String? thumbnail;
  final String? title;
  final String? sortDescription;
  final List<Artist>? artists;
  final List<Song>? songs;

  Playlist.fromJson(Map<String, dynamic> json)
      : encodeId = json['encodeId'],
        thumbnail = json['thumbnail'],
        title = json['title'],
        sortDescription = json['sortDescription'],
        songs = json['song'] != null
            ? (json['song']['items'] as List)
                .map((song) => Song.fromJson(song))
                .toList()
            : null,
        artists = json['artists'] != null ? (json['artists'] as List)
            .map((artist) => Artist.fromJson(artist))
            .toList() : null;

  @override
  String toString() {
    return 'Playlist(encodeId: $encodeId, thumbnail: $thumbnail, title: $title, sortDescription: $sortDescription, artists: $artists, songs: $songs)';
  }
}
