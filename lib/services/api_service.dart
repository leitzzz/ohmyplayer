import 'package:dio/dio.dart';

class ApiService {
  static final Dio _dio = Dio(BaseOptions(
    responseType: ResponseType.plain,
    // baseUrl: _baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  static Future<String> request(String streamUrl) async {
    try {
      final Response response = await _dio.get(streamUrl);
      return response.data;
    } catch (e) {
      // print(e);
      return '';
    }
  }
}
