

import 'package:just_audio/just_audio.dart';

class AudioPlayerServices {
  static final AudioPlayer _audioPlayer = AudioPlayer();

  static AudioPlayer get audioPlayer => _audioPlayer;
  AudioPlayerServices._internal();

  // Biến static để lưu trữ thể hiện duy nhất của lớp
  static final AudioPlayerServices _instance = AudioPlayerServices._internal();

  // Phương thức static để truy cập thể hiện duy nhất của lớp
  factory AudioPlayerServices() {
    return _instance;
  }
}
