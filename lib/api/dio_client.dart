import 'package:dio/dio.dart';
import '../common/constants.dart';

class DioClient {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppConstant.baseUrl,
      connectTimeout: Duration(seconds: 5),
      receiveTimeout: Duration(seconds: 5),
      contentType: 'application/json',
    ),
  );

  static Dio get instance => _dio;
}