import 'package:app_nghe_nhac/screens/home/home.dart';
import 'package:app_nghe_nhac/screens/home/widgets/home_item.dart';
import 'package:app_nghe_nhac/screens/home/widgets/playlist_item.dart';
import 'package:app_nghe_nhac/screens/playlist/play_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Top100Screen extends StatefulWidget {
  const Top100Screen({super.key, required this.homeLogic});
  final HomeLogic homeLogic;
  @override
  State<Top100Screen> createState() => _Top100ScreenState();
}

class _Top100ScreenState extends State<Top100Screen> {
  @override
  void initState() {
    widget.homeLogic.getTop100();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider.value(
        value: widget.homeLogic,
        child: Consumer<HomeLogic>(
          builder: (context, logic, child) {
            if (logic.top100Playlists == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        SafeArea(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.arrow_back_ios_rounded),
                            ),
                          ),
                        ),
                        Text(
                          'Top 100',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (_, index) {
                            return HomeItem(
                              title: logic.top100Playlists![index].title,
                              child: SizedBox(
                                height: 250,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: logic
                                      .top100Playlists![index].playlists
                                      .map(
                                        (playlist) => Padding(
                                          padding: const EdgeInsets.all(8),
                                          child: InkWell(
                                            onTap: () {
                                              widget.homeLogic.resetPlaylist();
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      PlayListScreen(
                                                    homeLogic: widget.homeLogic,
                                                    encodeId: playlist.encodeId!,
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
                          itemCount: logic.top100Playlists!.length,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
