import 'package:app_nghe_nhac/app/ultils.dart';
import 'package:app_nghe_nhac/models/song.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class NewReleaseSongItem extends StatelessWidget {
  const NewReleaseSongItem({super.key, required this.song});
  final Song song;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: CachedNetworkImage(imageUrl: song.thumbnail!,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(
        song.title!,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(song.artists.map((e) => e.name).join(", ")),
          Text(AppUltils.calculateDayAgo(song.releaseDate)),
        ],
      ),
      trailing: const Icon(
        Icons.more_vert_outlined,
        color: Colors.grey,
      ),
    );
  }
}
