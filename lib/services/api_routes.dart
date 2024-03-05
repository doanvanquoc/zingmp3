class ApiRoutes {
  static const String baseUrl = 'https://zingmp3.vanquoc.me/api/';
  static const String getHome = 'home';
  static const String getMusicLink = 'song?id={id}';
  static const String getPlaylistDetail = 'detailplaylist?id={id}';
  static const String getNewReleaseChart = 'newreleasechart';
  static const String getTop100Chart = 'top100';
  static const String getArtist = 'artist?name={name}';
  static const String search = 'search?keyword={keyword}';
  static const String getLyric = 'lyric?id={id}';
}
