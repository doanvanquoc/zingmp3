import 'dart:async';
import 'dart:developer';

import 'package:app_nghe_nhac/app/ultils.dart';
import 'package:app_nghe_nhac/models/song.dart';
import 'package:app_nghe_nhac/screens/artist/artist.dart';
import 'package:app_nghe_nhac/screens/home/home.dart';
import 'package:app_nghe_nhac/services/audio_handler.dart';
import 'package:app_nghe_nhac/services/song/song_api.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lyric/lyrics_reader.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';

part 'play_music_logic.dart';

class PlayMusicScreen extends StatefulWidget {
  const PlayMusicScreen(
      {super.key,
      required this.song,
      required this.logic,
      this.onNext,
      this.onPrevious});
  final Song song;
  final HomeLogic logic;
  final Function()? onNext;
  final Function()? onPrevious;
  @override
  State<PlayMusicScreen> createState() => _PlayMusicScreenState();
}

class _PlayMusicScreenState extends State<PlayMusicScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
    // logic.getMusicLink(widget.song.encodeId).then((value) {
    //   if (value) {
    //     logic.playMusic(widget.song);
    //   }
    // });

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: widget.logic.onExpand,
          icon: const Icon(Icons.arrow_back_ios_rounded),
        ),
        title: Text(widget.song.title!),
      ),
      body: ChangeNotifierProvider.value(
        value: widget.logic,
        child: Consumer<HomeLogic>(
          builder: (context, value, child) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    AnimatedBuilder(
                        animation: _controller,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: _controller.value * 2 * 3.14,
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(size.height * 2 / 10),
                              child: CachedNetworkImage(
                                imageUrl: widget.song.thumbnail!,
                                height: size.height * 4 / 10,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        }),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(
                          FontAwesomeIcons.share,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                widget.song.title!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                              ),
                              const SizedBox(height: 10),
                              InkWell(
                                onTap: () {
                                  widget.logic.resetArtist();
                                  widget.logic.onExpand();
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) {
                                      return ArtistScreen(
                                        artist: widget.song.artists.first,
                                        homeLogic: widget.logic,
                                      );
                                    },
                                  ));
                                },
                                child: Text(
                                  widget.song.artists
                                      .map((e) => e.name)
                                      .join(', '),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        fontSize: 16,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.normal,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        const Icon(
                          FontAwesomeIcons.heart,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    const SizedBox(height: 80),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        thumbShape:
                            const RoundSliderThumbShape(enabledThumbRadius: 8),
                        overlayShape:
                            const RoundSliderOverlayShape(overlayRadius: 8.0),
                      ),
                      child: Slider(
                        activeColor: Colors.grey,
                        value: value.position.inSeconds.toDouble(),
                        min: 0.0,
                        max: value.duration.inSeconds.toDouble(),
                        onChanged: (double valueX) {
                          value.onChangePosition(
                              Duration(seconds: valueX.toInt()));
                        },
                      ),
                    ),
                    const SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(AppUltils.formartDuration(value.position)),
                          Text(AppUltils.formartDuration(value.duration)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: !widget.logic.isBlock
                              ? () async {
                                  if (widget.onPrevious != null) {
                                    await widget.onPrevious!();
                                  }
                                }
                              : null,
                          child: const Icon(
                            FontAwesomeIcons.backwardStep,
                            size: 30,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(width: 20),
                        GestureDetector(
                          onTap: () => value.togglePlay(_controller),
                          child: Icon(
                            value.isPlaying
                                ? FontAwesomeIcons.pause
                                : FontAwesomeIcons.play,
                            size: 40,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(width: 20),
                        GestureDetector(
                          onTap: !widget.logic.isBlock
                              ? () async {
                                  if (widget.onNext != null) {
                                    await widget.onNext!();
                                  }
                                }
                              : null,
                          
                          child: const Icon(
                            FontAwesomeIcons.forwardStep,
                            size: 30,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 300,
                      child: LyricsReader(
                        lyricUi: CustomLyricUI(),
                        model: value.lyricModel,
                        playing: value.isPlaying,
                        position: value.playProgress,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class CustomLyricUI extends LyricUI {
  @override
  TextStyle getPlayingExtTextStyle() => const TextStyle(color: Colors.black);

  @override
  TextStyle getOtherExtTextStyle() => const TextStyle(color: Colors.black);

  @override
  TextStyle getOtherMainTextStyle() => const TextStyle(color: Colors.black);

  @override
  TextStyle getPlayingMainTextStyle() => const TextStyle(
      color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16);

  @override
  double getInlineSpace() => 25;

  @override
  double getLineSpace() => 25;

  @override
  double getPlayingLineBias() => 0.5;

  @override
  LyricAlign getLyricHorizontalAlign() => LyricAlign.CENTER;

  @override
  LyricBaseLine getBiasBaseLine() => LyricBaseLine.CENTER;

  @override
  bool enableHighlight() => true;

  @override
  HighlightDirection getHighlightDirection() => HighlightDirection.LTR;
}
