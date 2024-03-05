import 'package:app_nghe_nhac/models/playlist_section.dart';
import 'package:app_nghe_nhac/models/song_section.dart';

class Artist {
  final String? id;
  final String? name;
  final String? thumbnail;
  final String? playlistId;
  final String? alias;
  final String? biography;
  final String? realname;
  final String? birthday;
  final String? national;
  final int? follow;
  final SongSection? songSection;
  final List<PlaylistSection>? playlistSections;

  Artist.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        thumbnail = json['thumbnail'],
        alias = json['alias'],
        biography = json['biography'],
        national = json['national'],
        realname = json['realname'],
        birthday = json['birthday'],
        follow = json['follow'],
        songSection = json['sections'] != null
            ? SongSection.fromJson(json['sections'][0])
            : null,
        playlistSections = json['sections'] != null
            ? (json['sections'] as List)
                .skip(1)
                .where(
                  (section) => section['sectionType'] == 'playlist',
                )
                .map((section) => PlaylistSection.fromJson(section))
                .toList()
            : null,
        playlistId = json['playlistId'];

  @override
  String toString() {
    return 'Artist(id: $id, name: $name, thumbnail: $thumbnail, playlistId: $playlistId, alias: $alias, biography: $biography, realname: $realname, follow: $follow)';
  }
}
