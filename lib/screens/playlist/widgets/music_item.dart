import 'package:app_nghe_nhac/models/song.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MusicItem extends StatelessWidget {
  const MusicItem({super.key, required this.song});
  final Song song;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SizedBox(
        width: 50,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CachedNetworkImage(
            imageUrl: song.thumbnail!,
            fit: BoxFit.cover,
          ),
        ),
      ),
      title: Text(song.title!, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        song.artists.map((e) => e.name).join(', '),
        style: const TextStyle(color: Colors.grey),
      ),
    );
  }
}
