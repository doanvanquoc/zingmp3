import 'dart:developer';

import 'package:app_nghe_nhac/services/api_routes.dart';
import 'package:dio/dio.dart';

class ClientAPI {
  Dio init() {
    Dio dio = Dio();
    dio.interceptors.add(CustomInterceptors(dio));
    dio.options.baseUrl = ApiRoutes.baseUrl;
    return dio;
  }
}

class CustomInterceptors extends QueuedInterceptor {
  final Dio _dio;
  CustomInterceptors(this._dio);

  void showLoading() {
    if (_dio.options.headers['isLoading'] ?? true) {
      // Loading.show();
    }
  }

  void hideLoading() {
    if (_dio.options.headers['isLoading'] ?? true) {
      // Loading.hide();
    }
  }

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // log(options.data.toString());
    log(
      'REQUEST[${options.method}] => PATH: ${options.uri}',
    );
    // var accessToken = LocalStorage().token;
    showLoading();
    // if (accessToken.isNotEmpty) {
    //   options.headers['Authorization'] = 'Bearer ' + accessToken;
    // }
    return super.onRequest(options, handler);
  }

  @override
  Future onResponse(Response response, ResponseInterceptorHandler handler) {
    hideLoading();
    // log(
    //   'RESPONSE[${response.statusCode}] => Data : ${response.data}',
    // );
    super.onResponse(response, handler);
    return Future.value(response);
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    log(
      'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.uri}',
    );
    // if (err.response?.statusCode == 401 && !_routesExcludeRefreshToken.contains(err.requestOptions.path)) {
    //   // RequestOptions options = err.response!.requestOptions;
    //   return ;
    // }
    hideLoading();

    log('$err');
    super.onError(err, handler);
    return Future.error(err);
  }
}
