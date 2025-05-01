import 'package:dio/dio.dart';
import '../common/constants.dart';

class DioClient {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppConstant.baseUrl,
      connectTimeout: Duration(seconds: 50),
      receiveTimeout: Duration(seconds: 50),
      contentType: 'application/json',
    ),
  );

  static Dio get instance => _dio;
}