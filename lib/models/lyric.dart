import 'package:app_nghe_nhac/models/sentence.dart';

class Lyric {
  final List<LyricSentence> sentences;
  Lyric.fromJson(Map<String, dynamic> json)
      : sentences = (json['sentences'] as List).map((sentence) => LyricSentence.fromJson(sentence)).toList();

      @override
  String toString() {
    return 'Lyric(sentences: $sentences)';
  }

  String getLyric() {
    String lyric = '';
    for (var sentence in sentences) {
      for (var word in sentence.words) {
        lyric += '${word.word} ';
      }
      lyric += '\n';
    }
    return lyric;
  }

  // static formatDuration(int duration) {
  //   var minutes = (duration / 60).floor();
  //   var seconds = duration % 60;
  //   return '$minutes:${seconds < 10 ? '0$seconds' : seconds}';
  // }
  
}