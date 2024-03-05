import 'package:app_nghe_nhac/services/api_routes.dart';
import 'package:app_nghe_nhac/services/client_api.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
part 'home_api.g.dart';
@RestApi()
abstract class HomeApi {
  factory HomeApi(Dio dio, {String baseUrl}) = _HomeApi;
  factory HomeApi.client({bool? isLoading}) {
    return HomeApi(
        ClientAPI().init()..options.headers['isLoading'] = isLoading);
  }

  @GET(ApiRoutes.getHome)
  Future<dynamic> getHome();
}
