class LyricWord {
  final num startTime;
  final num endTime;
  final String word;

  LyricWord.fromJson(Map<String, dynamic> json)
      : startTime = json['startTime'],
        endTime = json['endTime'],
        word = json['data'];

        @override
  String toString() {
    return 'LyricWord(startTime: $startTime, endTime: $endTime, word: $word)';
  }
}
