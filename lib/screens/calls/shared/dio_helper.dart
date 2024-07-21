import 'package:dio/dio.dart';

import 'constats.dart';

class DioHelper {
  static late Dio dio;

  static init() {
    dio = Dio(
      BaseOptions(
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(seconds: 60), // 30 seconds
        receiveTimeout: const Duration(seconds: 60), // 30 seconds
      ),
    );
  }

  static Future<Response> getData(
      {required String endPoint,
      Map<String, dynamic>? query,
      required String baseUrl}) async {
    dio.options.baseUrl = baseUrl;
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    try {
      return await dio.get(
        endPoint,
        queryParameters: query,
      );
      // ignore: deprecated_member_use
    } on DioError catch (ex) {
      // ignore: deprecated_member_use
      if (ex.type == DioErrorType.connectionTimeout) {
        throw Exception("Connection Timeout Exception");
      }
      // ignore: deprecated_member_use
      if (ex.type == DioErrorType.receiveTimeout) {
        throw Exception("Receive Timeout Exception");
      }
      throw Exception(ex.message);
    }
  }

  static Future<Response> postData({
    required String endPoint,
    Map<String, dynamic>? query,
    required Map<String, dynamic> data,
    bool isRow = true,
    bool isPut = false,
    String lang = 'en',
    String? token,
    required String baseUrl,
  }) async {
    dio.options.followRedirects = true;
    dio.options.validateStatus = (status) => true;

    dio.options.baseUrl = baseUrl;
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'key= $fcmKey',
    };

    return !isPut
        ? await dio.post(
            endPoint,
            queryParameters: query,
            data: isRow ? data : FormData.fromMap(data),
          )
        : await dio.put(
            endPoint,
            queryParameters: query,
            data: isRow ? data : FormData.fromMap(data),
          );
  }
}
