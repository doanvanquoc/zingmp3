class ZingBanner {
  final String encodeId;
  final String banner;
  final BannerType type;

  ZingBanner.fromJson(Map<String, dynamic> json)
      : encodeId = json['encodeId'],
        banner = json['banner'],
        type = json['type'] == 1 ? BannerType.SONG : BannerType.PLAYLIST;

  @override
  String toString() {
    return 'ZingBanner{encodeId: $encodeId, banner: $banner, type: $type}';
  }
}

// ignore: constant_identifier_names
enum BannerType { SONG, PLAYLIST }
