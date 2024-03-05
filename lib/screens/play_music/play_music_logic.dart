part of 'play_music.dart';

class PlayMusicLogic with ChangeNotifier {
  BuildContext context;
  PlayMusicLogic(this.context);

  SongApi api = SongApi.client();
  String? songLink;
  final audioPlayer = AudioPlayerServices.audioPlayer;
  Duration duration = const Duration();
  Duration position = const Duration();
  bool isPlaying = false;

  Future<bool> getMusicLink(String id) async {
    try {
      final res = await api.getMusicLink(id);
      log('Get song link: $res');
      if (res['err'] != 0) {
        log('Lỗi get song link: ${res['msg']}');
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).clearSnackBars();
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi get song link: ${res['msg']}'),
            duration: const Duration(seconds: 2),
          ),
        );
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        notifyListeners();
        return false;
      } else {
        songLink = res['data']['128'];

        notifyListeners();
        return true;
      }
    } catch (e) {
      log('Lỗi get song link: $e');
      return false;
    }
  }

  void togglePlay(AnimationController controller) {
    if (isPlaying) {
      audioPlayer.pause();
      controller.stop();
    } else {
      audioPlayer.play();
      controller.repeat();
    }
    isPlaying = !isPlaying;
    notifyListeners();
  }

  void playMusic(Song song) {
// Tạo một đối tượng Audio Source từ MediaItem
    if (isPlaying) {
      audioPlayer.stop();
      isPlaying = false;
    }
    final audioSource = AudioSource.uri(
      Uri.parse(songLink!),
      tag: MediaItem(
        id: song.encodeId!,
        album: song.artists.map((e) => e.name).join(', '),
        title: song.title!,
        artUri: Uri.parse(song.thumbnail!),
      ),
    );
    audioPlayer.play();
    isPlaying = true;
    audioPlayer.setAudioSource(audioSource);
    audioPlayer.processingStateStream.listen((processingState) {
      log(processingState.toString());
      if (processingState == ProcessingState.completed) {
        audioPlayer.stop();
        audioPlayer.seek(Duration.zero);
        log('co vao');
        isPlaying = false;
        notifyListeners();
      }
    });
    audioPlayer.durationStream.listen((event) {
      duration = event!;
      notifyListeners();
    });
    audioPlayer.positionStream.listen((event) {
      // position = event.inSeconds >= duration.inSeconds ? Duration.zero : event;
      // isPlaying = event.inSeconds >= duration.inSeconds ? false : true;
      // notifyListeners();
      position = event;
      notifyListeners();
    });

    notifyListeners();
  }

  void onChangePosition(Duration duration) {
    audioPlayer.seek(duration);
    notifyListeners();
  }
}
