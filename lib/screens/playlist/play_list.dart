import 'package:app_nghe_nhac/screens/home/home.dart';
import 'package:app_nghe_nhac/screens/play_music/play_music.dart';
import 'package:app_nghe_nhac/screens/playlist/widgets/music_item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlayListScreen extends StatefulWidget {
  const PlayListScreen(
      {super.key, required this.encodeId, required this.homeLogic});
  final String encodeId;
  final HomeLogic homeLogic;
  @override
  State<PlayListScreen> createState() => _PlayListScreenState();
}

class _PlayListScreenState extends State<PlayListScreen> {
  @override
  void initState() {
   widget.homeLogic.getPlaylistDetail(widget.encodeId);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.homeLogic.isExpanded) {
          widget.homeLogic.onExpand();
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: ChangeNotifierProvider.value(
            value: widget.homeLogic,
            child: Consumer<HomeLogic>(
              builder: (context, homeLogic, child) {
                if (homeLogic.playlist == null) {
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
                            Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  imageUrl: homeLogic.playlist!.thumbnail!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              homeLogic.playlist!.title!,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              homeLogic.playlist!.sortDescription!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyMedium,
                              textAlign: TextAlign.center,
                            ),
                            ListView.builder(
                                itemBuilder: (_, index) {
                                  return InkWell(
                                    onTap: () {
                                      if (homeLogic.selectedSong == null ||
                                          homeLogic.selectedSong!.encodeId !=
                                              homeLogic.playlist!.songs![index]
                                                  .encodeId ||
                                          homeLogic.isError ||
                                          homeLogic.isStop) {
                                        homeLogic.playMusic(
                                            homeLogic.playlist!.songs![index]);
                                      }
                                      homeLogic.onSelectSong(
                                          homeLogic.playlist!.songs![index]);
                                      homeLogic.onExpand();
                                    },
                                    child: MusicItem(
                                        song: homeLogic.playlist!.songs![index]),
                                  );
                                },
                                itemCount: homeLogic.playlist!.songs!.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics())
                          ],
                        ),
                      ),
                    ),
                    if (homeLogic.selectedSong != null)
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                        left: 0,
                        top: homeLogic.isExpanded
                            ? 0
                            : MediaQuery.of(context).size.height,
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: PlayMusicScreen(
                            onNext: () {
                              homeLogic.onNext(homeLogic.playlist!.songs!);
                            
                            },
                            onPrevious: () {
                              homeLogic.onPrevious(homeLogic.playlist!.songs!);
                            },
                            logic: homeLogic,
                            song: homeLogic.selectedSong!,
                          ),
                        ),
                      ),
                  ],
                );
              },
            )),
      ),
    );
  }
}
