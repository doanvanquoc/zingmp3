import 'dart:developer';
import 'dart:io';

import 'package:app_nghe_nhac/app/const.dart';
import 'package:app_nghe_nhac/app/ultils.dart';
import 'package:app_nghe_nhac/models/artist.dart';
import 'package:app_nghe_nhac/models/banner.dart';
import 'package:app_nghe_nhac/models/home.dart';
import 'package:app_nghe_nhac/models/lyric.dart';
import 'package:app_nghe_nhac/models/playlist.dart';
import 'package:app_nghe_nhac/models/sentence.dart';
import 'package:app_nghe_nhac/models/song.dart';
import 'package:app_nghe_nhac/models/top100_response.dart';
import 'package:app_nghe_nhac/screens/home/widgets/banner_item.dart';
import 'package:app_nghe_nhac/screens/home/widgets/category_item.dart';
import 'package:app_nghe_nhac/screens/home/widgets/country_item.dart';
import 'package:app_nghe_nhac/screens/home/widgets/home_item.dart';
import 'package:app_nghe_nhac/screens/home/widgets/playlist_item.dart';
import 'package:app_nghe_nhac/screens/new_release_chart/new_release_chart.dart';
import 'package:app_nghe_nhac/screens/play_music/play_music.dart';
import 'package:app_nghe_nhac/screens/playlist/play_list.dart';
import 'package:app_nghe_nhac/screens/search/search.dart';
import 'package:app_nghe_nhac/screens/top100/top100.dart';
import 'package:app_nghe_nhac/services/audio_handler.dart';
import 'package:app_nghe_nhac/services/home/home_api.dart';
import 'package:app_nghe_nhac/services/song/song_api.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lyric/lyrics_model_builder.dart';
import 'package:flutter_lyric/lyrics_reader_model.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';

part 'home_logic.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeLogic logic;
  @override
  void initState() {
    logic = HomeLogic(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: logic,
      // ignore: deprecated_member_use
      child: WillPopScope(
        onWillPop: () async {
          if (logic.isExpanded) {
            logic.onExpand();
            return false;
          }
          return true;
        },
        child: Scaffold(
          body: Consumer<HomeLogic>(
            builder: (context, logic, child) {
              if (logic.banners.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              return Stack(
                children: [
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Khám pházzzz',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                ),
                                IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              SearchScreen(logic: logic),
                                        ),
                                      ).then((value) {
                                        if (logic.isExpanded) {
                                          logic.onExpand();
                                        }
                                      });
                                    },
                                    icon: const Icon(Icons.search_outlined)),
                              ],
                            ),
                            HomeItem(
                              child: CarouselSlider(
                                options: CarouselOptions(
                                  height: 200,
                                  viewportFraction: 1,
                                  autoPlay: true,
                                  autoPlayInterval: const Duration(seconds: 5),
                                  autoPlayAnimationDuration:
                                      const Duration(milliseconds: 800),
                                  autoPlayCurve: Curves.fastOutSlowIn,
                                  enlargeCenterPage: true,
                                ),
                                items: logic.banners
                                    .map(
                                      (e) => InkWell(
                                        onTap: () {
                                          if (e.type == BannerType.PLAYLIST) {
                                            logic.resetPlaylist();
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    PlayListScreen(
                                                  homeLogic: logic,
                                                  encodeId: e.encodeId,
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                        child: BannerItem(banner: e),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                            const SizedBox(height: 20),
                            HomeItem(
                              title: 'Chủ đề & thể loại',
                              child: SizedBox(
                                height: 80,
                                child: ListView(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                NewReleaseChart(
                                              homeLogic: logic,
                                            ),
                                          ),
                                        );
                                      },
                                      child: const CategoryItem(
                                        icon: Icons.music_note_outlined,
                                        title: kLatestMusicRaking,
                                        color: kLatestMusicRakingColor,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Top100Screen(
                                              homeLogic: logic,
                                            ),
                                          ),
                                        );
                                      },
                                      child: const CategoryItem(
                                        color: kTop100Color,
                                        icon: Icons.star,
                                        title: kTop100,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    const CategoryItem(
                                      color: kVietnameseMusicColor,
                                      title: kVietnameseMuscic,
                                    ),
                                    const SizedBox(width: 10),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 30),
                            HomeItem(
                              title: 'Mới phát hành',
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    height: 35,
                                    child: ListView.separated(
                                      separatorBuilder: (context, index) =>
                                          const SizedBox(width: 10),
                                      scrollDirection: Axis.horizontal,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: logic.filters.length,
                                      itemBuilder: (_, index) =>
                                          GestureDetector(
                                        onTap: () =>
                                            logic.onChangeFilter(index),
                                        child: CountryItem(
                                          isSelected:
                                              logic.currentFilter == index,
                                          title: logic.filters[index],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  SizedBox(
                                    height: 250,
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: (logic.displaySongs.length / 3)
                                          .ceil(),
                                      itemBuilder: (context, index) {
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: List.generate(
                                            3,
                                            (innerIndex) {
                                              final songIndex =
                                                  innerIndex + (index * 3);
                                              if (songIndex <
                                                  logic.displaySongs.length) {
                                                return ConstrainedBox(
                                                  constraints: BoxConstraints(
                                                    minWidth:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            100,
                                                  ),
                                                  child: GestureDetector(
                                                    behavior:
                                                        HitTestBehavior.opaque,
                                                    onTap: () {
                                                      if (logic.selectedSong ==
                                                              null ||
                                                          logic.selectedSong!
                                                                  .encodeId !=
                                                              logic
                                                                  .displaySongs[
                                                                      songIndex]
                                                                  .encodeId ||
                                                          logic.isError ||
                                                          logic.isStop) {
                                                        logic.playMusic(
                                                            logic.displaySongs[
                                                                songIndex]);
                                                      }
                                                      logic.onSelectSong(
                                                          logic.displaySongs[
                                                              songIndex]);
                                                      logic.onExpand();
                                                    },
                                                    child: Row(
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          child:
                                                              CachedNetworkImage(
                                                            imageUrl: logic
                                                                .displaySongs[
                                                                    songIndex]
                                                                .thumbnail!,
                                                            fit: BoxFit.cover,
                                                            height: 60,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 10),
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              logic
                                                                  .displaySongs[
                                                                      songIndex]
                                                                  .title!,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .titleMedium,
                                                            ),
                                                            Text(
                                                              logic
                                                                  .displaySongs[
                                                                      songIndex]
                                                                  .artists
                                                                  .map((e) =>
                                                                      e.name)
                                                                  .join(", "),
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .titleSmall!
                                                                  .copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal),
                                                            ),
                                                            Text(
                                                              AppUltils.calculateDayAgo(logic
                                                                  .displaySongs[
                                                                      songIndex]
                                                                  .releaseDate),
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .titleSmall!
                                                                  .copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      color: Colors
                                                                          .grey),
                                                            ),
                                                            const SizedBox(
                                                                height: 10),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                            width: 10),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }
                                              return const SizedBox.shrink();
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            HomeItem(
                              title: logic.chillPlayList!.title,
                              child: SizedBox(
                                height: 200,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemBuilder: (_, index) => InkWell(
                                    onTap: () {
                                      logic.resetPlaylist();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PlayListScreen(
                                            homeLogic: logic,
                                            encodeId: logic.chillPlayList!
                                                .playLists[index].encodeId!,
                                          ),
                                        ),
                                      );
                                    },
                                    child: PlaylistItem(
                                      playlist:
                                          logic.chillPlayList!.playLists[index],
                                    ),
                                  ),
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(width: 10),
                                  itemCount:
                                      logic.chillPlayList!.playLists.length,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            HomeItem(
                              title: logic.remixPlayList!.title,
                              child: SizedBox(
                                height: 200,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemBuilder: (_, index) => InkWell(
                                    onTap: () {
                                      logic.resetPlaylist();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PlayListScreen(
                                            homeLogic: logic,
                                            encodeId: logic.remixPlayList!
                                                .playLists[index].encodeId!,
                                          ),
                                        ),
                                      );
                                    },
                                    child: PlaylistItem(
                                      playlist:
                                          logic.remixPlayList!.playLists[index],
                                    ),
                                  ),
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(width: 10),
                                  itemCount:
                                      logic.remixPlayList!.playLists.length,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            HomeItem(
                              title: logic.fellingPlayList!.title,
                              child: SizedBox(
                                height: 200,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemBuilder: (_, index) => InkWell(
                                    onTap: () {
                                      logic.resetPlaylist();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PlayListScreen(
                                            homeLogic: logic,
                                            encodeId: logic.fellingPlayList!
                                                .playLists[index].encodeId!,
                                          ),
                                        ),
                                      );
                                    },
                                    child: PlaylistItem(
                                      playlist: logic
                                          .fellingPlayList!.playLists[index],
                                    ),
                                  ),
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(width: 10),
                                  itemCount:
                                      logic.fellingPlayList!.playLists.length,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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
                            logic.onNext(logic.displaySongs);
                          },
                          onPrevious: () {
                            logic.onPrevious(logic.displaySongs);
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
      ),
    );
  }
}
