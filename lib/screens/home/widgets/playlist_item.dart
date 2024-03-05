import 'package:app_nghe_nhac/models/playlist.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PlaylistItem extends StatelessWidget {
  const PlaylistItem({super.key, required this.playlist});
  final Playlist playlist;
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 150, maxWidth: 150),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: playlist.thumbnail!,
              fit: BoxFit.cover,
              height: 150,
            ),
          ),
          if (playlist.sortDescription != null) const SizedBox(height: 10),
          if (playlist.sortDescription != null)
            Text(
              playlist.sortDescription!.isNotEmpty
                  ? playlist.sortDescription!
                  : playlist.title!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.grey),
            ),
        ],
      ),
    );
  }
}
