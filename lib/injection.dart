import 'package:app_nghe_nhac/services/audio_handler.dart';
import 'package:get_it/get_it.dart';

final localtor = GetIt.instance;

void init() {
  localtor.registerSingleton(AudioPlayerServices());
}
