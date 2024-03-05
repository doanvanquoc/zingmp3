import 'package:app_nghe_nhac/models/word.dart';

class LyricSentence {
  final List<LyricWord> words;
  LyricSentence.fromJson(Map<String, dynamic> json)
      : words = (json['words'] as List)
            .map((word) => LyricWord.fromJson(word))
            .toList();

  @override
  String toString() {
    return 'LyricSentence(words: $words)';
  }
  
  
}
