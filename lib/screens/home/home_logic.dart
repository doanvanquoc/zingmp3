part of 'home.dart';

class HomeLogic with ChangeNotifier {
  BuildContext context;
  HomeLogic(this.context) {
    getHome();
  }
  final audioPlayer = AudioPlayerServices.audioPlayer;
  bool isBlock = false;
  List<ZingBanner> banners = [];
  List<ZingBanner> tempBanners = [];
  List<Song> latestSongs = [];
  Artist? artist;
  ZingHome? chillPlayList;
  ZingHome? remixPlayList;
  ZingHome? fellingPlayList;
  Song? selectedSong;
  bool isExpanded = false;
  HomeApi homeApi = HomeApi.client();
  int currentFilter = 0;
  List<String> filters = ['Tất cả', 'Việt Nam', 'Quốc Tế'];
  SongApi api = SongApi.client();
  String? songLink;
  Duration duration = const Duration();
  Duration position = const Duration();
  bool isPlaying = false;
  bool isError = false;
  bool isStop = false;
  Playlist? playlist;
  List<Song>? newReleaseSongs;
  List<Top100Reponse>? top100Playlists;
  final TextEditingController searchController = TextEditingController();
  List<Song>? searchSong;
  List<Playlist>? searchPlaylist;
  List<Artist>? searchArtist;
  bool isSeacrching = false;
  List<Song> vietnamSongs = [];
  List<Song> interSongs = [];
  List<Song> displaySongs = [];
  Lyric? lyric;
  String lyricString = '';
  LyricsReaderModel? lyricModel;
  int playProgress = 0;

  void resetPlaylist() {
    playlist = null;
    notifyListeners();
  }

  void getHome() async {
    try {
      final res = await homeApi.getHome();
      banners = (res['data']['items'][0]['items'] as List)
          .map((e) => ZingBanner.fromJson(e))
          .toList();
      tempBanners = banners;
      banners.shuffle();
      latestSongs = (res['data']['items'][2]['items']['all'] as List)
          .map((e) => Song.fromJson(e))
          .toList();
      displaySongs = latestSongs;
      vietnamSongs =
          latestSongs.where((element) => element.isWorldWide).toList();
      interSongs =
          latestSongs.where((element) => element.isWorldWide == false).toList();
      chillPlayList = ZingHome.fromJson(res['data']['items'][3]);
      remixPlayList = ZingHome.fromJson(res['data']['items'][4]);
      fellingPlayList = ZingHome.fromJson(res['data']['items'][5]);
      notifyListeners();
    } catch (e) {
      log('Lỗi get home: $e');
      notifyListeners();
    }
  }

  void onChangeFilter(int index) {
    currentFilter = index;
    if (currentFilter == 0) {
      displaySongs = latestSongs;
    } else if (currentFilter == 1) {
      displaySongs = vietnamSongs;
    } else {
      displaySongs = interSongs;
    }
    notifyListeners();
  }

  void onExpand() {
    isExpanded = !isExpanded;
    notifyListeners();
  }

  void onSelectSong(Song song) {
    selectedSong = song;
    notifyListeners();
  }

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
            content: Text('Lỗi: ${res['msg']}'),
            duration: const Duration(seconds: 2),
          ),
        );
        // ignore: use_build_context_synchronously
        isExpanded = false;
        isError = true;
        notifyListeners();
        return false;
      } else {
        try {
          final response = await api.getLyric(id);
          lyric = Lyric.fromJson(response['data']);
          final res2 = await Dio().get(response['data']['file']);
          if (res2.statusCode == 200) {
            lyricString = res2.data;
            lyricModel = LyricsModelBuilder.create()
                .bindLyricToMain(lyricString)
                .getModel();

            notifyListeners();
          } else {
            throw Exception('Failed to load file');
          }
          // File file = File(response['data']['file']);
          // String txt = await file.readAsString();
          // log('file: $txt');
        } catch (e) {
          log('Loi get lyric: $e');
          return false;
        }
        songLink = res['data']['128'];
        isError = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      log('Lỗi get song link trong home: $e');
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

  Future<void> getPlaylistDetail(String id) async {
    try {
      var res = await api.getPlaylistDetail(id);
      playlist = Playlist.fromJson(res['data']);
      log(playlist.toString());
      notifyListeners();
    } catch (e) {
      log('Loi get playlist: $e');
      notifyListeners();
    }
  }

  Future playMusic(Song song) async {
// Tạo một đối tượng Audio Source từ MediaItem
    final check = await getMusicLink(song.encodeId!);
    if (check) {
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
          isStop = true;
          isPlaying = false;
          notifyListeners();
        }
      });
      audioPlayer.durationStream.listen((event) {
        if (event != null) {
          duration = event;
          notifyListeners();
        }
      });

      audioPlayer.positionStream.listen((event) {
        // position = event.inSeconds >= duration.inSeconds ? Duration.zero : event;
        // isPlaying = event.inSeconds >= duration.inSeconds ? false : true;
        // notifyListeners();
        position = event;
        playProgress = event.inMilliseconds;
        notifyListeners();
      });
    }
    notifyListeners();
  }

  void setPlayprogress(int value) {
    playProgress = value;
    notifyListeners();
  }

  void onChangePosition(Duration duration) {
    audioPlayer.seek(duration);
    notifyListeners();
  }

  void getNewReleaseChart() async {
    try {
      final res = await api.getNewReleaseChart();
      newReleaseSongs =
          (res['data']['items'] as List).map((e) => Song.fromJson(e)).toList();
      notifyListeners();
    } catch (e) {
      log('Lỗi get new release chart: $e');
      notifyListeners();
    }
  }

  void getTop100() async {
    try {
      final res = await api.getTop100Chart();
      top100Playlists =
          (res['data'] as List).map((e) => Top100Reponse.fromJson(e)).toList();
      notifyListeners();
    } catch (e) {
      log('Lỗi get top 100: $e');
      notifyListeners();
    }
  }

  void getArtistDetail(String alias) async {
    try {
      final res = await api.getArtist(alias);
      artist = Artist.fromJson(res['data']);
      notifyListeners();
    } catch (e) {
      log('Lỗi get artist detail: $e');
      notifyListeners();
    }
  }

  void resetArtist() {
    artist = null;
    notifyListeners();
  }

  void onSearch() async {
    isSeacrching = true;
    if (searchController.text.isEmpty) {
      searchSong = [];
      searchPlaylist = [];
      searchArtist = [];
      isSeacrching = false;
      notifyListeners();
      return;
    }
    try {
      final res = await api.search(searchController.text);
      searchSong =
          (res['data']['songs'] as List).map((e) => Song.fromJson(e)).toList();
      searchPlaylist = (res['data']['playlists'] as List)
          .map((e) => Playlist.fromJson(e))
          .toList();
      searchArtist = (res['data']['artists'] as List)
          .map((e) => Artist.fromJson(e))
          .toList();
      isSeacrching = false;
      notifyListeners();
    } catch (e) {
      isSeacrching = false;
      log('Lỗi search: $e');
      notifyListeners();
    }
    isSeacrching = false;
    notifyListeners();
  }

  void resetExpand() {
    isExpanded = false;
    notifyListeners();
  }

  void onNext(List<Song> songs) async {
    log('dau block');
    onBlock();
    songs = songs.where((element) => element.isWorldWide).toList();
    if (songs.indexOf(selectedSong!) == songs.length - 1) {
      selectedSong = songs[0];
    } else {
      selectedSong = songs[songs.indexOf(selectedSong!) + 1];
    }
    await playMusic(selectedSong!);
    await Future.delayed(const Duration(milliseconds: 500), () => onBlock());
    notifyListeners();
  }

  void onPrevious(List<Song> songs) async {
    onBlock();
    songs = songs.where((element) => element.isWorldWide).toList();
    if (songs.indexOf(selectedSong!) == 0) {
      selectedSong = songs[songs.length - 1];
    } else {
      selectedSong = songs[songs.indexOf(selectedSong!) - 1];
    }
    await playMusic(selectedSong!);
    await Future.delayed(const Duration(milliseconds: 500), () => onBlock());
    notifyListeners();
  }

  void onBlock() {
    isBlock = !isBlock;
    notifyListeners();
  }
}
