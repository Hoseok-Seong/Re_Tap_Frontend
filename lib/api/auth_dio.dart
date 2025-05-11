import 'package:dio/dio.dart';
import '../common/constants.dart';

class AuthDio {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppConstant.baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
      contentType: 'application/json',
    ),
  );

  static Dio get instance => _dio;
}