//
// Copyright© 2021 Ti-Ding(上海醍顶信息科技有限公司). All Rights Reserved.
// file         dio_http.dart
// date         2023-01-18
// author       wl1395182472(wl1395182472@gmail.com)
// version      0.1
// brief        http请求工具
//

import 'package:dio/dio.dart';

import 'index.dart';

class DioUtil {
  ///openAi的api接口
  static const String _openaiBaseUrl = "https://api.openai.com/v1";

  ///dio工具类定义的变量
  static Dio get _dio => Dio(
        BaseOptions(
          baseUrl: _openaiBaseUrl,
          connectTimeout: LocalKeyValuePair.connectTimeout,
          receiveTimeout: LocalKeyValuePair.receiveTimeout,
          headers: {
            "Authorization": 'Bearer ${LocalKeyValuePair.openAiApiKey}',
          },
          contentType: 'application/json; charset=utf-8',
          //返回数据为json
          responseType: ResponseType.json,
          //不管发生错误都返回内容
          validateStatus: (status) => true,
        ),
      );

  /// dio的get请求
  static Future<Response> get({
    required String url,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onReceiveProgress,
  }) async {
    Response response = await _dio.get(
      url,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );
    return response;
  }

  /// dio的post请求
  static Future<Response> post({
    required String url,
    required dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    Response response = await _dio.post(
      url,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
    return response;
  }
}
