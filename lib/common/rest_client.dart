import 'package:dio/dio.dart';

class RestClient {
   final dio = createDio();

  RestClient._internal();

  static final _singleton = RestClient._internal();

  factory RestClient() => _singleton;

  static Dio createDio() {
    var dio = Dio(BaseOptions(
      baseUrl: "http://10.0.2.2:3000/",
      receiveTimeout: 15000, // 15 seconds
      connectTimeout: 15000,
      sendTimeout: 15000,
    ));

 
    return dio;
  }
}
