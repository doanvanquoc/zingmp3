import 'dart:developer';

import 'package:app_nghe_nhac/screens/artist/artist.dart';
import 'package:app_nghe_nhac/screens/home/home.dart';
import 'package:app_nghe_nhac/screens/play_music/play_music.dart';
import 'package:app_nghe_nhac/screens/playlist/play_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key, required this.logic});
  final HomeLogic logic;
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: ChangeNotifierProvider.value(
          value: widget.logic,
          child: Consumer<HomeLogic>(
            builder: (context, logic, child) {
              return WillPopScope(
                onWillPop: () async {
                  if (widget.logic.isExpanded) {
                    widget.logic.onExpand();
                    return false;
                  }
                  return true;
                },
                child: Scaffold(
                  appBar: widget.logic.isExpanded
                      ? null
                      : AppBar(
                          title: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: widget.logic.searchController,
                                  decoration: InputDecoration(
                                    contentPadding:
                                        const EdgeInsets.only(left: 10),
                                    hintText: 'Nhập tên ca sĩ/bài hát/album...',
                                    hintStyle: TextStyle(color: Colors.grey[400]),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                    fillColor: Colors.grey[200],
                                    filled: true,
                                  ),
                                  onChanged: (value) {
                                    widget.logic.onSearch();
                                  },
                                ),
                              ),
                            ],
                          ),
                          bottom: const TabBar(tabs: [
                            Tab(
                              text: 'Bài hát',
                            ),
                            Tab(
                              text: 'Nghệ sĩ',
                            ),
                            Tab(
                              text: 'Playlist',
                            ),
                          ]),
                        ),
                  body: Consumer<HomeLogic>(
                    builder: (context, logic, child) {
                      if (logic.isSeacrching) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return Stack(
                        children: [
                          TabBarView(children: [
                            logic.searchSong != null
                                ? ListView.builder(
                                    itemCount: logic.searchSong!.length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          if (logic.selectedSong == null ||
                                              logic.selectedSong!.encodeId !=
                                                  logic.searchSong![index]
                                                      .encodeId ||
                                              logic.isError ||
                                              logic.isStop) {
                                            logic.playMusic(
                                                logic.searchSong![index]);
                                          }
                                          logic.onExpand();
                                          log('is expanded: ${logic.isExpanded}');
                                          logic.onSelectSong(
                                              logic.searchSong![index]);
                                        },
                                        child: ListTile(
                                          leading: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image.network(
                                              logic.searchSong![index].thumbnail!,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          title: Text(
                                              logic.searchSong![index].title!),
                                          subtitle: Text(logic
                                              .searchSong![index].artists
                                              .map((e) => e.name)
                                              .join(", ")),
                                          trailing: const Icon(
                                              Icons.more_vert_outlined),
                                        ),
                                      );
                                    },
                                  )
                                : const SizedBox(),
                            logic.searchArtist != null
                                ? ListView.separated(
                                    padding: const EdgeInsets.only(top: 10),
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(height: 10),
                                    itemCount: logic.searchArtist!.length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          widget.logic.resetArtist();
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                            builder: (context) {
                                              return ArtistScreen(
                                                artist:
                                                    logic.searchArtist![index],
                                                homeLogic: widget.logic,
                                              );
                                            },
                                          ));
                                        },
                                        child: ListTile(
                                          leading: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image.network(
                                              logic.searchArtist![index]
                                                  .thumbnail!,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          title: Text(
                                              logic.searchArtist![index].name!),
                                          trailing: const Icon(
                                              Icons.more_vert_outlined),
                                        ),
                                      );
                                    },
                                  )
                                : const SizedBox(),
                            logic.searchPlaylist != null
                                ? ListView.builder(
                                    itemCount: logic.searchPlaylist!.length,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () {
                                          widget.logic.resetPlaylist();
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                            builder: (context) {
                                              return PlayListScreen(
                                                encodeId: logic
                                                    .searchPlaylist![index]
                                                    .encodeId!,
                                                homeLogic: widget.logic,
                                              );
                                            },
                                          ));
                                        },
                                        child: ListTile(
                                          leading: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image.network(
                                              logic.searchPlaylist![index]
                                                  .thumbnail!,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          title: Text(logic
                                              .searchPlaylist![index].title!),
                                          subtitle: logic.searchPlaylist![index]
                                                      .artists !=
                                                  null
                                              ? Text(logic
                                                  .searchPlaylist![index].artists!
                                                  .map((e) => e.name)
                                                  .join(", "))
                                              : const Text('Đang cập nhật'),
                                          trailing: const Icon(
                                              Icons.more_vert_outlined),
                                        ),
                                      );
                                    },
                                  )
                                : const SizedBox(),
                          ]),
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
                                    logic.onNext(logic.searchSong!);
                                  },
                                  onPrevious: () {
                                    logic.onPrevious(logic.searchSong!);
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
          )),
    );
  }
}
