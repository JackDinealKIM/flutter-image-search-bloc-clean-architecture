import 'dart:convert';

import 'package:dio/dio.dart';

import '../log.dart';

class DioInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    try {
      String json = jsonEncode(options.data);
      Log.i('==================== REQUEST ====================\nMETHOD: ${options.method}\nURL: ${options.path}\nBODY: $json');
    } catch(e) {
      String json = options.data.toString();
      Log.i('==================== REQUEST ====================\nMETHOD: ${options.method}\nURL: ${options.path}\nBODY: $json');
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    String json = jsonEncode(response.data);
    Log.i('==================== RESPONSE ====================\nSTATE CODE: ${response.statusCode}\nURL: ${response.requestOptions.path}\nBODY: $json');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    String json = jsonEncode(err.response?.data);
    Log.i('==================== ERROR ====================\nSTATE CODE: ${err.response?.statusCode}\nURL: ${err.requestOptions.path}\nJSON: $json');
    super.onError(err, handler);
  }
}
