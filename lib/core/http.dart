import 'package:dio/dio.dart';
import '../env/env.dart';
import 'log.dart';

Dio createDio() {
  final dio = Dio(
    BaseOptions(
      baseUrl: Env.apiBaseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  if (Env.enableLogs) {
    dio.interceptors.add(
      LogInterceptor(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        logPrint: (obj) => log.d(obj),
      ),
    );
  }

  return dio;
}
