import 'package:app_nghe_nhac/app/ultils.dart';
import 'package:app_nghe_nhac/models/artist.dart';
import 'package:app_nghe_nhac/screens/home/home.dart';
import 'package:app_nghe_nhac/screens/home/widgets/home_item.dart';
import 'package:app_nghe_nhac/screens/home/widgets/playlist_item.dart';
import 'package:app_nghe_nhac/screens/play_music/play_music.dart';
import 'package:app_nghe_nhac/screens/playlist/play_list.dart';
import 'package:app_nghe_nhac/screens/playlist/widgets/music_item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ArtistScreen extends StatefulWidget {
  const ArtistScreen(
      {super.key, required this.artist, required this.homeLogic});
  final Artist artist;
  final HomeLogic homeLogic;
  @override
  State<ArtistScreen> createState() => _ArtistScreenState();
}

class _ArtistScreenState extends State<ArtistScreen> {
  @override
  void initState() {
    widget.homeLogic.getArtistDetail(widget.artist.alias!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: widget.homeLogic,
        child: Consumer<HomeLogic>(
          builder: (context, logic, child) {
            return WillPopScope(
              onWillPop: () async {
                if (logic.isExpanded) {
                  logic.onExpand();
                  return false;
                }
                return true;
              },
              child: Scaffold(
                appBar: widget.homeLogic.isExpanded
                    ? null
                    : AppBar(
                        leading: IconButton(
                            onPressed: () {
                              widget.homeLogic.resetExpand();
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.arrow_back_ios_rounded)),
                        title: Text(widget.artist.name!),
                        surfaceTintColor: Colors.transparent,
                      ),
                body: Consumer<HomeLogic>(
                  builder: (context, logic, child) {
                    if (logic.artist == null) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return Stack(
                      children: [
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: logic.artist!.thumbnail!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                                  Positioned(
                                    bottom: 40,
                                    left: 20,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          logic.artist!.name!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineMedium!
                                              .copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                        ),
                                        Text(
                                          '${AppUltils.formatNumber(logic.artist!.follow!)} người theo dõi',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                color: Colors.white,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    HomeItem(
                                      title: logic.artist!.songSection!.title!,
                                      child: ListView.builder(
                                        itemBuilder: (_, index) => InkWell(
                                          onTap: () {
                                            if (logic.selectedSong == null ||
                                                logic.selectedSong!.encodeId !=
                                                    logic
                                                        .artist!
                                                        .songSection!
                                                        .songs![index]
                                                        .encodeId ||
                                                logic.isError ||
                                                logic.isStop) {
                                              logic.playMusic(logic.artist!
                                                  .songSection!.songs![index]);
                                            }
                                            logic.onExpand();
                                            logic.onSelectSong(logic.artist!
                                                .songSection!.songs![index]);
                                          },
                                          child: MusicItem(
                                              song: logic.artist!.songSection!
                                                  .songs![index]),
                                        ),
                                        itemCount: logic.artist!.songSection!
                                                    .songs!.length >=
                                                5
                                            ? 5
                                            : logic.artist!.songSection!.songs!
                                                .length,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                      ),
                                    ),
                                    ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemBuilder: (_, index) {
                                        return HomeItem(
                                          title: logic.artist!
                                              .playlistSections![index].title!,
                                          child: SizedBox(
                                            height: 250,
                                            child: ListView(
                                              scrollDirection: Axis.horizontal,
                                              children: logic
                                                  .artist!
                                                  .playlistSections![index]
                                                  .playlists!
                                                  .map(
                                                    (playlist) => Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8),
                                                      child: InkWell(
                                                        onTap: () {
                                                          widget.homeLogic
                                                              .resetPlaylist();
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  PlayListScreen(
                                                                homeLogic: widget
                                                                    .homeLogic,
                                                                encodeId: playlist
                                                                    .encodeId!,
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        child: PlaylistItem(
                                                          playlist: playlist,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                  .toList(),
                                            ),
                                          ),
                                        );
                                      },
                                      itemCount: logic
                                          .artist!.playlistSections!.length,
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      'Thông tin',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      logic.artist!.biography!,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        const Text('Tên thật: '),
                                        Text(
                                          logic.artist!.realname!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        const Text('Ngày sinh: '),
                                        Text(
                                          logic.artist!.birthday == null ||
                                                  logic
                                                      .artist!.birthday!.isEmpty
                                              ? 'Chưa cập nhật'
                                              : logic.artist!.birthday!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        const Text('Quốc gia: '),
                                        Text(
                                          logic.artist!.national == null ||
                                                  logic
                                                      .artist!.national!.isEmpty
                                              ? 'Chưa cập nhật'
                                              : logic.artist!.national!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (logic.selectedSong != null)
                          AnimatedPositioned(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                            left: 0,
                            top: logic.isExpanded
                                ? 0
                                : MediaQuery.of(context).size.height,
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              child: PlayMusicScreen(
                                onNext: () {
                                  logic.onNext(
                                      logic.artist!.songSection!.songs!);
                                },
                                onPrevious: () {
                                  logic.onPrevious(
                                      logic.artist!.songSection!.songs!);
                                },
                                logic: logic,
                                song: logic.selectedSong!,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            );
          },
        ));
  }
}
