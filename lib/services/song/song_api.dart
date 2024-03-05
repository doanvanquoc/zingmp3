import 'package:app_nghe_nhac/services/api_routes.dart';
import 'package:app_nghe_nhac/services/client_api.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
part 'song_api.g.dart';

@RestApi()
abstract class SongApi {
  factory SongApi(Dio dio, {String baseUrl}) = _SongApi;
  factory SongApi.client({bool? isLoading}) {
    return SongApi(
        ClientAPI().init()..options.headers['isLoading'] = isLoading);
  }

  @GET(ApiRoutes.getMusicLink)
  Future<dynamic> getMusicLink(
    @Path('id') String id,
  );

  @GET(ApiRoutes.getPlaylistDetail)
  Future<dynamic> getPlaylistDetail(
    @Path('id') String id,
  );

  @GET(ApiRoutes.getNewReleaseChart)
  Future<dynamic> getNewReleaseChart();

  @GET(ApiRoutes.getTop100Chart)
  Future<dynamic> getTop100Chart();

  @GET(ApiRoutes.getArtist)
  Future<dynamic> getArtist(
    @Path('name') String name,
  );

  @GET(ApiRoutes.search)
  Future<dynamic> search(
    @Path('keyword') String keyword,
  );

  @GET(ApiRoutes.getLyric)
  Future<dynamic> getLyric(
    @Path('id') String id,
  );
}
