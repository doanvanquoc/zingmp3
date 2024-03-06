import 'package:app_nghe_nhac/models/playlist.dart';
import 'package:app_nghe_nhac/services/song/song_api.dart';
import 'package:flutter/material.dart';

class PlaylistLogic with ChangeNotifier {
  BuildContext context;
  PlaylistLogic({required this.context});
  bool isExpand = false;
  SongApi songApi = SongApi.client(isLoading: true);
  Playlist? playlist;
}
