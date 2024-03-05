import 'package:app_nghe_nhac/screens/home/home.dart';
import 'package:app_nghe_nhac/screens/new_release_chart/widgets/chart_item.dart';
import 'package:app_nghe_nhac/screens/play_music/play_music.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewReleaseChart extends StatefulWidget {
  const NewReleaseChart({super.key, required this.homeLogic});
  final HomeLogic homeLogic;
  @override
  State<NewReleaseChart> createState() => _NewReleaseChartState();
}

class _NewReleaseChartState extends State<NewReleaseChart> {
  @override
  void initState() {
    widget.homeLogic.getNewReleaseChart();
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
            builder: (context, logic, child) {
              if (logic.newReleaseSongs == null) {
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
                            'BXH Nhạc Mới',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 20),
                          ListView.separated(
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 10),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: logic.newReleaseSongs!.length,
                            itemBuilder: (context, index) {
                              final song = logic.newReleaseSongs![index];
                              return InkWell(
                                  onTap: () {
                                    if (logic.selectedSong == null ||
                                        logic.selectedSong!.encodeId !=
                                            logic.newReleaseSongs![index]
                                                .encodeId ||
                                        logic.isError ||
                                        logic.isStop) {
                                      logic.playMusic(
                                          logic.newReleaseSongs![index]);
                                    }
                                    logic.onSelectSong(
                                        logic.newReleaseSongs![index]);
                                    logic.onExpand();
                                  },
                                  child: ChartItem(
                                      song: song, ranking: index + 1));
                            },
                          ),
                        ],
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
                            logic.onNext(logic.newReleaseSongs!);
                          },
                          onPrevious: () {
                            logic.onPrevious(logic.newReleaseSongs!);
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
