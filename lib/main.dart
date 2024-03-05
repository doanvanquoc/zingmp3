import 'package:app_nghe_nhac/app/ultils.dart';
import 'package:app_nghe_nhac/injection.dart';
import 'package:app_nghe_nhac/screens/home/home.dart';
import 'package:app_nghe_nhac/screens/playlist/play_list_logic.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  init();
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeLogic(context)),
        ChangeNotifierProvider(create: (_) => PlaylistLogic(context: context)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Zing Mp3',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<StatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late AudioPlayer audioPlayer;
  bool isPlaying = false;
  Duration position = const Duration();
  Duration duration = const Duration();

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    audioPlayer.setUrl(
        "https://a128-zmp3.zmdcdn.me/ddfbdc80fdc60c20f34526dcedb10737?authen=exp=1709262317~acl=/ddfbdc80fdc60c20f34526dcedb10737/*~hmac=c3da1d3e571b12eadda9526d32fc611f");
    audioPlayer.positionStream.listen((event) {
      setState(() {
        position = event;
      });
    });
    audioPlayer.durationStream.listen((event) {
      setState(() {
        duration = event!;
      });
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  void toggleAudio() {
    if (isPlaying) {
      audioPlayer.pause();
    } else {
      audioPlayer.play();
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Just Audio Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Slider(
              value: position.inSeconds.toDouble(),
              min: 0.0,
              max: duration.inSeconds.toDouble(),
              onChanged: (double value) {
                setState(() {
                  audioPlayer.seek(Duration(seconds: value.toInt()));
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                    '${AppUltils.formartDuration(position)} / ${AppUltils.formartDuration(duration)}'),
              ),
            ),
            ElevatedButton(
              onPressed: toggleAudio,
              child: Text(isPlaying ? 'Pause Audio' : 'Play Audio'),
            ),
          ],
        ),
      ),
    );
  }
}
